extends Node
class_name GameState

var equipment_script# = load("res://Equipment.gd")
var equipment_instance
var equipment_data


#@onready var synchronizer := $MultiplayerSynchronizer
var all_duels_done := true
var selected_race: String = ""
var gladiator_attributes: Dictionary = {}
var gladiator_alive: int = 0
var skeleton_alive: int = 0

##
var gladiator_data = {}
var all_gladiators = {}  # peer_id => gladiator_data

var selected_name = "PlayerName"
##
@onready var spawn_points = {
	"left": [],
	"right": []
}
@onready var meeting_points 

signal gladiator_life_changed(id: int, new_life: int)
signal gladiator_attribute_changed(new_all_gladiators: Dictionary)
signal countdown_updated(time_left: int)
signal card_stock_changed(new_all_cards_stock: Dictionary)
#signal card_stock_initialize(new_attr_cards_stock: Dictionary)
signal send_gladiator_data_to_peer_signal(peer_id: int, gladiator_data: Dictionary)
signal card_buy_result(peer_id: int, success: bool)


'var weapon_slot1 := {
	"min_dmg": 1, 
	"max_dmg": 3,
	"durability": 30,
	"req": 20,
	"crit": 0.1,
	"speed": 1,
	"range": 150,
	"parry:": true,
	"block": false,
	"attributes": 
		{
			"weapon_skill": 0,
			"avoidance": 0
		}
	}'

var attr_cards_stock
var all_cards_stock

const RACE_MODIFIERS = {
	"Orc": {
		"strength": 1.25,
		"weapon_skill": 1.0,
		"quickness": 0.7,
		"crit_rating": 1.2,
		"avoidance": 0.6,
		"health": 1.25,
		"resilience": 1.35,
		"endurance": 0.9
	},
	"Elf": {
		"strength": 0.7,
		"weapon_skill": 1.3,
		"quickness": 1.4,
		"crit_rating": 1.2,
		"avoidance": 1.55,
		"health": 0.8,
		"resilience": 0.7,
		"endurance": 1.35
	},
	"Human": {
		"strength": 1.0,
		"weapon_skill": 1.15,
		"quickness": 1.1,
		"crit_rating": 1.0,
		"avoidance": 1.1,
		"health": 1.1,
		"resilience": 1.1,
		"endurance": 1.2
	},
	"Troll": {
		"strength": 1.5,
		"weapon_skill": 0.8,
		"quickness": 0.6,
		"crit_rating": 1.0,
		"avoidance": 0.5,
		"health": 1.5,
		"resilience": 1.4,
		"endurance": 0.8
	}
}

func _ready():
	#print("🆔 Peer:", multiplayer.get_unique_id(), " Is server:", multiplayer.is_server())
	await get_tree().process_frame
	equipment_script = load("res://Equipment.gd")
	equipment_instance = equipment_script.new()
	equipment_data = equipment_instance.all_equipment
	print("equipment_data: " + str(equipment_data))
	
	all_cards_stock = create_card_pool()
	initialize_card_stock()
	



@rpc("any_peer", "call_local")
func broadcast_countdown(time_left: int):
	emit_signal("countdown_updated", time_left)
	#initialize_card_stock()

func get_equipment_by_name(item_name: String):
	for category in equipment_data.keys():
		var items = equipment_data[category]
		if items.has(item_name):
			var result := {}
			result[item_name] = items[item_name]
			return result
	return {}  # Return empty if not found

@rpc("authority", "call_local")
func equip_item(peer_id, item): pass

@rpc("authority", "call_local")
func send_gladiator_data_to_peer(id: int, _gladiator_data) -> void:
	emit_signal("send_gladiator_data_to_peer_signal", id, _gladiator_data)

@rpc("any_peer", "call_local")
func refresh_gladiator_data(id: int) -> void:
	#print("asdasdasd: " + str(all_gladiators[id]))
	rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators[id])

@rpc("authority", "call_local")
func notify_card_buy_result(id: int, success: bool, _gladiator_data) -> void:
	emit_signal("card_buy_result", id, success, _gladiator_data)

@rpc("any_peer", "call_local")
func buy_equipment_card(id: int, equipment: String, cost: int): 
	var success := false
	if all_cards_stock[equipment] >= 1:
		if all_gladiators[id]["gold"] >= cost:
			var item_dict = get_equipment_by_name(equipment)
			
			for slot_name in all_gladiators[id]["inventory"].keys():
				if all_gladiators[id]["inventory"][slot_name] == {}:
					all_gladiators[id]["inventory"][slot_name] = item_dict
					all_gladiators[id]["gold"] -= cost
					adjust_card_stock(equipment, "remove")
					success = true
					rpc_id(id, "notify_card_buy_result", id, success, all_gladiators[id])
					rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators[id])
					return
			print("No inventory space!")
		else: print("Not enough gold!")
	else: 
		print("No " + equipment + " cards left in stock!")
		
		rpc_id(id, "notify_card_buy_result", id, success, all_gladiators[id])
		rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators[id])

					
@rpc("any_peer", "call_local")
func sell_from_inventory(id: int, equipment: String): 
	var item_dict = get_equipment_by_name(equipment)
	#print("item_dict: " + str(item_dict))
	var price = item_dict[equipment]["price"]
	for slot_name in all_gladiators[id]["inventory"].keys():
		var item = all_gladiators[id]["inventory"][slot_name]

		# Check if the item is a dictionary and contains the equipment name
		if typeof(item) == TYPE_DICTIONARY and item.has(equipment):
			all_gladiators[id]["inventory"][slot_name] = {}  # Clear slot
			all_gladiators[id]["gold"] += int(price/2)
			print("gold: " + str(all_gladiators[id]["gold"]))
			adjust_card_stock(equipment, "add")  # Restore stock
			rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators[id])
			return  # Exit after first match

	print("Item not found in inventory!")
	
	
@rpc("any_peer", "call_local")
func buy_attribute_card(id: int, amount: int, attribute: String, cost: int):
	var success := false
	if all_cards_stock[attribute] >= 1:
		if all_gladiators[id]["gold"] >= cost:
			#print("modify_attribute called on peer: ", multiplayer.get_unique_id())
			var race = all_gladiators[id]["race"]
			
			if all_gladiators.has(id):
				var amount_after_bonuses = float(amount)*RACE_MODIFIERS[race][attribute]
				all_gladiators[id]["attributes"][attribute] += amount_after_bonuses
				all_gladiators[id]["gold"] -= cost
				emit_signal("gladiator_attribute_changed", all_gladiators)
				adjust_card_stock(attribute, "remove")
				success = true
				rpc_id(id, "notify_card_buy_result", id, success, all_gladiators[id])
				rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators[id])
		else: print("Not enough gold!")
	else: 
		print("No " + attribute + " cards left in stock!")
		rpc_id(id, "notify_card_buy_result", id, success, all_gladiators[id])
		
func create_card_pool():
	attr_cards_stock = {
		"strength": 100,
		"weapon_skill": 100,
		"quickness": 50,
		"crit_rating": 50,
		"avoidance": 50,
		"health": 100,
		"resilience": 50,
		"endurance": 100,
	}
	var _all_cards_stock = {}  # Create a fresh dictionary

	# Copy original attr_cards_stock values into it
	for key in attr_cards_stock.keys():
		_all_cards_stock[key] = attr_cards_stock[key]

	# Now add stock values from equipment_data
	for category in equipment_data.keys():
		for item_name in equipment_data[category].keys():
			var item_data = equipment_data[category][item_name]
			if item_data.has("stock"):
				_all_cards_stock[item_name] = item_data["stock"]
				
	#print("asdasd" + str(_all_cards_stock))
	return _all_cards_stock
		
@rpc("any_peer")
func initialize_card_stock():
	emit_signal("card_stock_changed", all_cards_stock)

@rpc("any_peer")
func adjust_card_stock(card: String, action: String):
	if action == "remove": all_cards_stock[card] -= 1
	if action == "add": all_cards_stock[card] += 1
	
	emit_signal("card_stock_changed", all_cards_stock)

@rpc("any_peer")
func modify_gladiator_life(id: int, life_lost: int):
	if all_gladiators.has(id):
		all_gladiators[id]["player_life"] -= life_lost
		var new_life = all_gladiators[id]["player_life"]
		emit_signal("gladiator_life_changed", id, new_life)

func submit_gladiator(data: Dictionary):
	gladiator_data = data
	print("Submiting gladiator for peer: %d" % [multiplayer.get_unique_id()])
	if multiplayer.get_unique_id() == 1:
		_store_gladiator(multiplayer.get_unique_id(), data)
	else:
		print("📨 Sending gladiator to host via rpc_id...")
		_submit_gladiator_remote.rpc_id(1, data)
	

@rpc("any_peer", "call_local")
func _submit_gladiator_remote(data: Dictionary):
	var sender_id = multiplayer.get_remote_sender_id()
	print("✅ Host received gladiator from peer:", sender_id)
	_store_gladiator(sender_id, data)

func _store_gladiator(peer_id: int, data: Dictionary):
	all_gladiators[peer_id] = data
	print("🎯 Gladiator stored for peer:", peer_id)
	print(all_gladiators)
	if all_gladiators.size() >= NetworkManager_.max_players + 1:
		
		_start_game.rpc()
		_start_game()
		
@rpc("authority")
func _start_game():
	print("All gladiators submitted! Starting game...")
	get_tree().change_scene_to_file("res://main.tscn")
	#initialize_card_stock()
	#print("initialize_card_stock()")

func _assign_authority():
	if multiplayer.is_server():
		print("🌐 Assigning multiplayer authority on host " + str(multiplayer.get_unique_id()))
		set_multiplayer_authority(multiplayer.get_unique_id())
		
		print("✅ Authority set to:", get_multiplayer_authority())
	else:
		print("ℹ️ Client does not assign authority")
