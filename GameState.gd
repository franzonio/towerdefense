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
signal send_gladiator_data_to_peer_signal(peer_id: int, gladiator_data: Dictionary, all_gladiators)
signal card_buy_result(peer_id: int, success: bool)
signal broadcast_log_signal(message: String)
signal send_player_colors_to_peer_signal(id: int, colors: Dictionary)
signal send_equipment_dict_to_peer_signal(id: int, dict: Dictionary)
signal send_gladiator_data_to_peer_card_signal(id: int, dict: Dictionary)
signal broadcast_players_ready_signal(players_ready: int)
signal killed_by_server_signal(id: int)
signal reroll_cards_new_round_signal(active_players)

signal update_equipment_card_signal(id, item_dict_to_craft, slot, item)
signal add_item_to_inventory_signal(id, item_dict, slot_name)
signal remove_item_from_inventory_signal(id, item_dict, slot_name)
signal add_item_to_equipment_signal(peer_id, item_dict, category)
signal remove_item_from_equipment_signal(peer_id, item_dict, category)

signal signal_update_gold_req_in_shop_for_peer(id, gold)

var craft_cards_stock
var attr_cards_stock
var all_cards_stock

var exp_for_level = {"1": 0, "2": 10, "3": 12, "4": 14, "5": 18, "6": 22, "7": 26, "8": 30, "9": 34, "10": 36}

var peer_colors = [Color.ANTIQUE_WHITE, Color.AQUAMARINE, Color.CHOCOLATE, Color.DEEP_PINK,
				   Color.DODGER_BLUE,   Color.KHAKI,      Color.YELLOW,    Color.RED]
var player_colors := {}
var _players = []
var players_ready_list = []
var players_ready = 0
var active_players = []

var total_modifier_bonuses
var prev_total_modifier_bonuses

const RACE_MODIFIERS = {
	"Orc": {
		"strength": 1.25,
		"quickness": 0.7,
		"crit_rating": 1.2,
		"avoidance": 0.6,
		"health": 1.25,
		"resilience": 1.35,
		"endurance": 0.9,
		"sword_mastery": 1.0,
		"axe_mastery": 1.1,
		"mace_mastery": 1.2,
		"stabbing_mastery": 1.0,
		"flagellation_mastery": 1.15,
		"shield_mastery": 0.95,
		"unarmed_mastery": 1.0
	},
	"Elf": {
		"strength": 0.7,
		"quickness": 1.4,
		"crit_rating": 1.2,
		"avoidance": 1.55,
		"health": 0.8,
		"resilience": 0.7,
		"endurance": 1.35,
		"sword_mastery": 1.15,
		"axe_mastery": 1.0,
		"mace_mastery": 1.0,
		"stabbing_mastery": 1.3,
		"flagellation_mastery": 1.1,
		"shield_mastery": 1.2,
		"unarmed_mastery": 1.0
	},
	"Human": {
		"strength": 1.0,
		"quickness": 1.1,
		"crit_rating": 1.0,
		"avoidance": 1.1,
		"health": 1.1,
		"resilience": 1.1,
		"endurance": 1.2,
		"sword_mastery": 1.1,
		"axe_mastery": 1.1,
		"mace_mastery": 1.1,
		"stabbing_mastery": 1.1,
		"flagellation_mastery": 1.1,
		"shield_mastery": 1.1,
		"unarmed_mastery": 1.0
	},
	"Troll": {
		"strength": 1.5,
		"quickness": 0.6,
		"crit_rating": 1.0,
		"avoidance": 0.5,
		"health": 1.5,
		"resilience": 1.4,
		"endurance": 0.8,
		"sword_mastery": 0.7,
		"axe_mastery": 0.8,
		"mace_mastery": 1.1,
		"stabbing_mastery": 0.7,
		"flagellation_mastery": 1.15,
		"shield_mastery": 0.7,
		"unarmed_mastery": 1.0
	}
}



func _ready():
	#print("🆔 Peer:", multiplayer.get_unique_id(), " Is server:", multiplayer.is_server())
	await get_tree().process_frame
	equipment_script = load("res://Equipment.gd")
	equipment_instance = equipment_script.new()
	equipment_data = equipment_instance.all_equipment
	#print("equipment_data: " + str(equipment_data))
	
	all_cards_stock = create_card_pool()
	initialize_card_stock()

func create_card_pool():
	craft_cards_stock = {
		"scroll_of_luck": 50,
		"scroll_of_injection": 50
	}
	
	attr_cards_stock = {
		"strength": 100,
		"quickness": 50,
		"crit_rating": 50,
		"avoidance": 50,
		"health": 100,
		"resilience": 50,
		"endurance": 100,
		"sword_mastery": 100,
		"axe_mastery": 100,
		"mace_mastery": 100,
		"stabbing_mastery": 100,
		"flagellation_mastery": 100,
		"shield_mastery": 100
	}
	var _all_cards_stock = {}  # Create a fresh dictionary

	for key in craft_cards_stock.keys():
		_all_cards_stock[key] = craft_cards_stock[key]
		
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

@rpc("any_peer", "call_local")
func update_all_equipment_cards(id):
	#print("update_all_equipment_cards")
	for slot_name in all_gladiators[id]["inventory"].keys():
		var slot_data = all_gladiators[id]["inventory"][slot_name]
		if slot_data.size() > 0:
			var first_key = slot_data.keys()[0]
			rpc_id(id, "update_equipment_card", id, slot_data, slot_name, first_key)

@rpc("any_peer", "call_local")
func update_gold_req_in_shop_for_peer(id, gold):
	print(all_gladiators)
	emit_signal("signal_update_gold_req_in_shop_for_peer", id, gold)

@rpc("any_peer", "call_local")
func grant_exp_for_peer(id: int, amount: int, cost: int):
	if all_gladiators[id]["gold"] >= cost:
		all_gladiators[id]["gold"] -= cost
		all_gladiators[id]["exp"] += amount
		var current_level = all_gladiators[id]["level"]
		var current_exp = all_gladiators[id]["exp"]

		while true:
			var next_level = str(int(current_level) + 1)
			if not exp_for_level.has(next_level):
				break  # Max level reached

			var required_exp = exp_for_level[next_level]
			if current_exp >= required_exp:
				current_exp -= required_exp
				current_level = str(int(current_level) + 1)
				
			else:
				break

		all_gladiators[id]["level"] = current_level
		all_gladiators[id]["exp"] = current_exp
		rpc_id(id, "update_gold_req_in_shop_for_peer", id, all_gladiators[id]["gold"])
		rpc("send_gladiator_data_to_peer", id, all_gladiators[id], all_gladiators)
		update_all_equipment_cards(id)
	else: add_to_peer_log(id, "Not enough gold!")

@rpc("any_peer", "call_local")
func grant_gold_for_peer(id: int, base_amount: int, opponent_id: int, winner: bool):
	var peer_color = all_gladiators[id]["color"].to_html()
	var opponent_color = all_gladiators[opponent_id]["color"].to_html()
	
	var peer_name = "[color=%s]%s[/color]" % [peer_color, all_gladiators[id]["name"]]
	var opponent_name = "[color=%s]%s[/color]" % [opponent_color, all_gladiators[opponent_id]["name"]]

	var win_streak_quotes = [
	peer_name + " is hailed—streak commands glory!",
	#peer_name + " is cheered—victories stir the crowd",
	#peer_name + " is revered—unbroken reign ignites awe",
	peer_name + " is exalted—triumphs sway the emperor!",
	peer_name + " is immortalized—streak crowns a legend!"]
	
	var loss_streak_quotes = [
	peer_name + " endures—the crowd spares a coin...",
	peer_name + " perseveres—pity swells in the stands...",
	#peer_name + " rises—defeat feeds the people’s compassion",
	peer_name + " struggles—the emperor’s hand turns generous...",
	peer_name + " endures legend’s trial—gold fuels the return..."]

	var break_streak_quotes = [
	peer_name + " strikes—" + opponent_name + "'s streak falls!",
	#peer_name + " topples " + opponent_name + "—cheers shake the arena",
	peer_name + " ends " + opponent_name + "'s reign—the emperor rises to applaud!",
	#peer_name + " shatters " + opponent_name + "'s destiny—gold rains from the stands",
	peer_name + " breaks " + opponent_name + "'s legend—the empire rewards the impossible!"]

	# --- Tunable parameters ---
	var WIN_STREAK_STEP := 3          # Wins per +1 gold
	var WIN_STREAK_CAP := 3           # Max gold from win streak
	var LOSS_STREAK_STEP := 2         # Losses per +1 gold
	var LOSS_STREAK_CAP := 4          # Max gold from loss streak
	
	var STREAK_BREAK_BONUS_SAME := 1  # You both had win streaks
	var STREAK_BREAK_BONUS_UPSET := 3 # You had loss streak, opponent had win streak
	
	# Gold thresholds and corresponding bonuses
	var INCOME_GOLD_THRESHOLDS := [10, 20, 30, 40, 50]
	var INCOME_GOLD_BONUSES :=    [1,   2,  3,  4,  5]
	
	# --- Logic ---
	var peer_streak = all_gladiators[id]["streak"]
	var peer_gold = all_gladiators[id]["gold"]
	var total_bonus = 0
	var streak_bonus = 0
	var streak_break_bonus = 0
	var income_bonus = 0
	
	# 1. Streak bonus
	if peer_streak > 0: # win-streak
		streak_bonus += min(peer_streak / WIN_STREAK_STEP, WIN_STREAK_CAP)
	elif peer_streak < 0: # loss-streak
		streak_bonus += min(abs(peer_streak) / LOSS_STREAK_STEP, LOSS_STREAK_CAP)
	
	# Announce streak bonus quote
	if peer_streak > 0 and streak_bonus > 0 and peer_streak % WIN_STREAK_STEP == 0:
		var index = min(int(streak_bonus) - 1, win_streak_quotes.size() - 1)
		add_to_log(id, win_streak_quotes[index])
	elif peer_streak < 0 and streak_bonus > 0 and peer_streak % LOSS_STREAK_STEP == 0:
		var index = min(int(streak_bonus) - 1, loss_streak_quotes.size() - 1)
		add_to_log(id, loss_streak_quotes[index])

	# 2. Opponent streak break bonus
	var opponent_streak = all_gladiators[opponent_id]["streak"]
	if opponent_streak > WIN_STREAK_STEP and winner:
		if peer_streak > 0:
			streak_break_bonus += STREAK_BREAK_BONUS_SAME
		elif peer_streak <= 0:
			streak_break_bonus += STREAK_BREAK_BONUS_UPSET
			
	if opponent_streak > 0 and streak_break_bonus:
		var streak_tier = min(opponent_streak / WIN_STREAK_STEP, WIN_STREAK_CAP)
		var index = int(streak_tier) - 1  # Tier 1 → index 0, Tier 2 → index 1, etc.
		if index >= 0 and index < break_streak_quotes.size():
			add_to_log(id, break_streak_quotes[index])

	
	# 3. Income bonus
	for i in range(INCOME_GOLD_THRESHOLDS.size()):
		if peer_gold >= INCOME_GOLD_THRESHOLDS[i] and (i == INCOME_GOLD_THRESHOLDS.size() - 1 or peer_gold < INCOME_GOLD_THRESHOLDS[i+1]):
			income_bonus += INCOME_GOLD_BONUSES[i]
			break
	
	total_bonus = streak_bonus + streak_break_bonus + income_bonus
	if winner: total_bonus += 1
	#print(all_gladiators[id]["name"] + " total_bonus: " + str(total_bonus))
	# 4. Final gold addition
	var gold_from_gear = all_gladiators[id].get("total_modifier_bonuses", {})
	gold_from_gear = gold_from_gear.get("to_gold_income", 0)
	all_gladiators[id]["gold"] += base_amount + int(total_bonus) + gold_from_gear
	#print(str(base_amount + int(total_bonus)) + " gold for peer " + str(id))
	rpc_id(id, "update_gold_req_in_shop_for_peer", id, all_gladiators[id]["gold"])
	rpc("send_gladiator_data_to_peer", id, all_gladiators[id], all_gladiators)


@rpc("any_peer", "call_local")
func modify_streak(id: int, win: bool):
	var current_streak = all_gladiators[id]["streak"]
	if current_streak >= 0 and win: # continue win streak
		all_gladiators[id]["streak"] += 1
	elif current_streak <= 0 and !win: # continue loss streak
		all_gladiators[id]["streak"] -= 1
	elif current_streak <= 0 and win: # broke loss streak
		all_gladiators[id]["streak"] = 1
	elif current_streak >= 0 and !win: # broke win streak
		all_gladiators[id]["streak"] = -1
	
	rpc("send_gladiator_data_to_peer", id, all_gladiators[id], all_gladiators)
	
	
@rpc("authority", "call_local")
func send_player_colors_to_peer(id: int, _player_colors) -> void:
	emit_signal("send_player_colors_to_peer_signal", id, _player_colors)

@rpc("any_peer", "call_local")
func get_player_colors(id: int) -> void:
	#print("asdasdasd: " + str(all_gladiators[id]))
	rpc_id(id, "send_player_colors_to_peer", id, player_colors)
	
func assign_peer_colors(players): 
	#print("In GameState | players: " + str(players))
	_players = players
	var shuffled_colors = peer_colors.duplicate()
	shuffled_colors.shuffle()

	var i = 0
	for peer_id in players.keys():
		if i < shuffled_colors.size():
			player_colors[peer_id] = shuffled_colors[i]
			i += 1
		else:
			push_error("Not enough colors for all players!")
	#print(player_colors)
	
@rpc("any_peer", "call_local")
func client_send_ready_to_host(id: int):
	rpc("broadcast_players_ready", id)

@rpc("any_peer", "call_local")
func broadcast_players_ready(id: int):# -> void:
	if id in players_ready_list: return# or id == 1: return
	else: 
		players_ready_list.append(id)
		players_ready = len(players_ready_list)
		print("players_ready_list: " + str(players_ready_list))
		emit_signal("broadcast_players_ready_signal", players_ready)
	
@rpc("any_peer", "call_local")
func broadcast_log(message: String) -> void:
	emit_signal("broadcast_log_signal", message)

@rpc("any_peer", "call_local")
func add_to_log_from_peer(id: int, message: String) -> void:
	#print("asdasdasd: " + str(all_gladiators[id]))
	rpc_id(id, "broadcast_log", message)

@rpc("any_peer", "call_local")
func add_to_peer_log(id: int, message: String) -> void:
	#print("asdasdasd: " + str(all_gladiators[id]))
	rpc_id(id, "broadcast_log", message)

@rpc("any_peer", "call_local")
func add_to_log(_id: int, message: String) -> void:
	#print("asdasdasd: " + str(all_gladiators[id]))
	rpc("broadcast_log", message)

@rpc("any_peer", "call_local")
func broadcast_countdown(time_left: int):
	emit_signal("countdown_updated", time_left)
	#initialize_card_stock()

@rpc("any_peer", "call_local")
func send_equipment_dict_to_peer(id, dict: Dictionary) -> void:
	emit_signal("send_equipment_dict_to_peer_signal", id, dict)

@rpc("any_peer", "call_local")
func get_equipment_by_name(id, item_name: String):
	for category in equipment_data.keys():
		var items = equipment_data[category]
		if items.has(item_name):
			var result := {}
			result[item_name] = items[item_name]
			#print("Sending to peer " + str(id) + ": " + str(result))
			rpc_id(id, "send_equipment_dict_to_peer", id, result)
			return result
	#return {}  # Return empty if not found

@rpc("any_peer", "call_local")
func unequip_item(peer_id, equipment, equipment_button_parent_name, category):
	prev_total_modifier_bonuses = total_modifier_bonuses
	#print("Unqeuip equipment not implemented yet")
	# 1. Remove from all_gladiators[peer_id][equipment_button_parent_name]
	# 2. Add to 
	var item_dict = all_gladiators[peer_id][category] #get_equipment_by_name(peer_id, equipment)
	#var type = item_dict[equipment]["type"] # to be implemented
	var hands = item_dict[equipment].get("hands", -1)
	var item = equipment_button_parent_name.replace("Slot", "").to_lower()
	var modifier_attributes = item_dict[equipment]["modifiers"].get("attributes", {})
	var modifier_bonuses = item_dict[equipment]["modifiers"].get("bonuses", {})
	var weight = item_dict[equipment].get("weight", 0)
	#var unequip_success = 0
	
	
	for slot_name in all_gladiators[peer_id]["inventory"].keys():
		if all_gladiators[peer_id]["inventory"][slot_name] == {}:
			all_gladiators[peer_id]["inventory"][slot_name] = item_dict
			#unequip_success = 1
			
			if hands == 2:
				all_gladiators[peer_id]["weapon1"] = get_equipment_by_name(peer_id, "unarmed")
				all_gladiators[peer_id]["weapon2"] = get_equipment_by_name(peer_id, "unarmed")
			elif item == "weapon1" or item == "weapon2": all_gladiators[peer_id][item] = get_equipment_by_name(peer_id, "unarmed")
			else: all_gladiators[peer_id][item] = {}
			
			remove_attribute_bonuses(peer_id)
			# Remove item modifier attributes from items
			if modifier_attributes != {}:
				for attribute in modifier_attributes:
					#var key = "increased_" + attribute
					all_gladiators[peer_id]["attributes"][attribute] -= modifier_attributes[attribute]#/(1+float(prev_total_modifier_bonuses.get(key, 0))/100)
			
			# TODO Remove item modifier bonuses
			#if modifier_bonuses != {}: 1 
			total_modifier_bonuses = collect_gladiator_bonuses(peer_id)
			all_gladiators[peer_id]["total_modifier_bonuses"] = total_modifier_bonuses
			
			add_attribute_bonuses(peer_id)
			
			#print("x prev " + str(float(prev_total_modifier_bonuses.get("increased_health", 0))))
			#attribute_bonuses(peer_id)
			print(all_gladiators[peer_id]["attributes"]["endurance"])
			
			# Remove weight of item
			if weight: all_gladiators[peer_id]["weight"] -= weight
			
			#print(all_gladiators[peer_id])
			rpc_id(peer_id, "add_item_to_inventory", peer_id, item_dict, slot_name)
			rpc_id(peer_id, "remove_item_from_equipment", peer_id, item_dict, category)
			rpc_id(peer_id, "update_equipment_card", peer_id, all_gladiators[peer_id]["inventory"][slot_name], slot_name, equipment)
			rpc("send_gladiator_data_to_peer", peer_id, all_gladiators[peer_id], all_gladiators)
			update_all_equipment_cards(peer_id)
			return
	
	add_to_peer_log(peer_id, "[INFO] ❌No inventory space!")

	

@rpc("any_peer", "call_local")
func equip_item(peer_id, equipment, selected_slot):
	var item_dict = all_gladiators[peer_id]["inventory"][selected_slot] #get_equipment_by_name(peer_id, equipment)
	var type = item_dict[equipment]["type"]
	var category = item_dict[equipment]["category"]
	var str_req = item_dict[equipment].get("str_req", 0) 
	var lvl_req = item_dict[equipment].get("level", 0) 
	var modifier_attributes = item_dict[equipment]["modifiers"].get("attributes", {})
	var modifier_bonuses = item_dict[equipment]["modifiers"].get("bonuses", {})
	var weight = item_dict[equipment].get("weight", 0)
	var equip_success = 0
	
	if category in ["sword", "axe", "flagellation", "stabbing", "mace"]:
		category = "weapon"
	
	if int(all_gladiators[peer_id]["level"]) >= lvl_req:
		if all_gladiators[peer_id]["attributes"]["strength"] >= str_req:
			if type == "weapon" and category != "shield":
				var _hands = item_dict[equipment]["hands"] # to be implemented
				var _skill_req = item_dict[equipment]["skill_req"] # to be implemented
				
				if _hands == 2 and all_gladiators[peer_id]["weapon1"].keys()[0] == "unarmed" and all_gladiators[peer_id]["weapon2"].keys()[0] == "unarmed":
					all_gladiators[peer_id]["weapon1"] = item_dict
					all_gladiators[peer_id]["weapon2"] = item_dict
					category = "weapon1"
					equip_success = 1
				elif _hands == 1 and all_gladiators[peer_id]["weapon1"].keys()[0] == "unarmed": 
					all_gladiators[peer_id]["weapon1"] = item_dict
					category = "weapon1"
					equip_success = 1
				elif _hands == 1 and all_gladiators[peer_id]["weapon2"].keys()[0] == "unarmed": 
					all_gladiators[peer_id]["weapon2"] = item_dict
					equip_success = 1
					category = "weapon2"
				else: add_to_peer_log(peer_id, "[INFO] ❌Cannot equip more weapons!")
					
			elif category == "shield":
				if all_gladiators[peer_id]["weapon2"].keys()[0] == "unarmed": 
					all_gladiators[peer_id]["weapon2"] = item_dict
					category = "weapon2"
					equip_success = 1
				else: add_to_peer_log(peer_id, "[INFO] ❌Can only wear shield in off-hand!")
					
			elif category == "head":
				if all_gladiators[peer_id]["head"] == {}: 
					all_gladiators[peer_id]["head"] = item_dict
					equip_success = 1
				else: add_to_peer_log(peer_id, "[INFO] ❌Already wearing a helmet")
				
			elif category == "chest":
				if all_gladiators[peer_id]["chest"] == {}: 
					all_gladiators[peer_id]["chest"] = item_dict
					equip_success = 1
				else: add_to_peer_log(peer_id, "[INFO] ❌Already wearing a chest")
				
			elif category == "shoulders":
				if all_gladiators[peer_id]["shoulders"] == {}: 
					all_gladiators[peer_id]["shoulders"] = item_dict
					equip_success = 1
				else: add_to_peer_log(peer_id, "[INFO] ❌Already wearing shoulders")
				
			elif category == "belt":
				if all_gladiators[peer_id]["belt"] == {}: 
					all_gladiators[peer_id]["belt"] = item_dict
					equip_success = 1
				else: add_to_peer_log(peer_id, "[INFO] ❌Already wearing belt")
				
			elif category == "boots":
				if all_gladiators[peer_id]["boots"] == {}: 
					all_gladiators[peer_id]["boots"] = item_dict
					equip_success = 1
				else: add_to_peer_log(peer_id, "[INFO] ❌Already wearing boots")
				
			elif category == "gloves":
				if all_gladiators[peer_id]["gloves"] == {}: 
					all_gladiators[peer_id]["gloves"] = item_dict
					equip_success = 1
				else: add_to_peer_log(peer_id, "[INFO] ❌Already wearing gloves")
				
			elif category == "legs":
				if all_gladiators[peer_id]["legs"] == {}: 
					all_gladiators[peer_id]["legs"] = item_dict
					equip_success = 1
				else: add_to_peer_log(peer_id, "[INFO] ❌Already wearing legs")
				
			elif category == "amulet":
				if all_gladiators[peer_id]["amulet"] == {}: 
					all_gladiators[peer_id]["amulet"] = item_dict
					equip_success = 1
				else: add_to_peer_log(peer_id, "[INFO] ❌Already wearing amulet")
				
			elif category == "ring": 
				if all_gladiators[peer_id]["ring1"] == {}: 
					all_gladiators[peer_id]["ring1"] = item_dict
					category = "ring1"
					equip_success = 1
				elif all_gladiators[peer_id]["ring2"] == {}: 
					all_gladiators[peer_id]["ring2"] = item_dict
					category = "ring2"
					equip_success = 1
				else: add_to_peer_log(peer_id, "[INFO] ❌Cannot equip more rings!")
				
			else: add_to_peer_log(peer_id, "[INFO] ❌Invalid item type! Please report this as a bug.")

			#for slot_name in all_gladiators[peer_id]["inventory"].keys():
				#var item = all_gladiators[peer_id]["inventory"][slot_name]

			if equip_success:# and typeof(item) == TYPE_DICTIONARY and item.has(equipment):
				all_gladiators[peer_id]["inventory"][selected_slot] = {}  # Clear slot
				#print("Removing " + selected_slot + " from inventory")
				rpc_id(peer_id, "remove_item_from_inventory", peer_id, item_dict, selected_slot)
				rpc_id(peer_id, "add_item_to_equipment", peer_id, item_dict, category)
				rpc_id(peer_id, "update_equipment_card", peer_id, all_gladiators[peer_id][category], category, equipment)
				#update_all_equipment_cards(peer_id)
				
			prev_total_modifier_bonuses = all_gladiators[peer_id].get("total_modifier_bonuses", {})
			total_modifier_bonuses = collect_gladiator_bonuses(peer_id)
			all_gladiators[peer_id]["total_modifier_bonuses"] = total_modifier_bonuses

			remove_attribute_bonuses(peer_id)
			# Apply item modifier attributes from items
			if modifier_attributes != {}:
				for attribute in modifier_attributes:
					#var key = "increased_" + attribute
					all_gladiators[peer_id]["attributes"][attribute] += modifier_attributes[attribute]#*(1+float(total_modifier_bonuses.get(key, 0))/100)
					
			add_attribute_bonuses(peer_id)
					#print((1+float(all_gladiators[peer_id]["total_modifier_bonuses"].get("increased_health", 0))))
					
			

			
			# TODO Apply item modifier bonuses
			#if modifier_bonuses != {}: 1 
			
			print(all_gladiators[peer_id]["attributes"]["endurance"])
			#print(all_gladiators[peer_id])
			
			# Add weight of item
			if weight: all_gladiators[peer_id]["weight"] += weight
				
			#print(all_gladiators[peer_id])
			rpc("send_gladiator_data_to_peer", peer_id, all_gladiators[peer_id], all_gladiators)
			update_all_equipment_cards(peer_id)
		else: add_to_peer_log(peer_id, "[INFO] ❌Need " + str(str_req) + " strength to equip item, you have " + str(int(all_gladiators[peer_id]["attributes"]["strength"])) + "!")
	else: add_to_peer_log(peer_id, "[INFO] ❌Item requires level " + str(lvl_req) + " to equip, you are level " + str(all_gladiators[peer_id]["level"]))


func remove_attribute_bonuses(peer_id):
	#all_gladiators[peer_id]["attributes"]["strength"] = all_gladiators[peer_id]["attributes"].get("strength", 0)/(1+float(prev_total_modifier_bonuses.get("increased_strength", 0))/100)
	#all_gladiators[peer_id]["attributes"]["quickness"] = all_gladiators[peer_id]["attributes"].get("quickness", 0)/(1+float(prev_total_modifier_bonuses.get("increased_quickness", 0))/100)
	#all_gladiators[peer_id]["attributes"]["crit_rating"] = all_gladiators[peer_id]["attributes"].get("crit_rating", 0)/(1+float(prev_total_modifier_bonuses.get("increased_crit_rating", 0))/100)
	#all_gladiators[peer_id]["attributes"]["avoidance"] = all_gladiators[peer_id]["attributes"].get("avoidance", 0)/(1+float(prev_total_modifier_bonuses.get("increased_avoidance", 0))/100)
	#all_gladiators[peer_id]["attributes"]["health"] = all_gladiators[peer_id]["attributes"].get("health", 0)/(1+float(prev_total_modifier_bonuses.get("increased_health", 0))/100)
	#all_gladiators[peer_id]["attributes"]["resilience"] = all_gladiators[peer_id]["attributes"].get("resilience", 0)/(1+float(prev_total_modifier_bonuses.get("increased_resilience", 0))/100)
	#all_gladiators[peer_id]["attributes"]["endurance"] = all_gladiators[peer_id]["attributes"].get("endurance", 0)/(1+float(prev_total_modifier_bonuses.get("increased_endurance", 0))/100)
	
	var all_attributes = all_gladiators[peer_id]["attributes"].keys()
	for attr in all_attributes:
		var increased_string = "increased_" + attr
		all_gladiators[peer_id]["attributes"][attr] = all_gladiators[peer_id]["attributes"].get(attr, 0)/(1+float(prev_total_modifier_bonuses.get(increased_string, 0))/100)

func add_attribute_bonuses(peer_id):
	#all_gladiators[peer_id]["attributes"]["strength"] = all_gladiators[peer_id]["attributes"].get("strength", 0)*(1+float(all_gladiators[peer_id]["total_modifier_bonuses"].get("increased_strength", 0))/100)
	#all_gladiators[peer_id]["attributes"]["quickness"] = all_gladiators[peer_id]["attributes"].get("quickness", 0)*(1+float(all_gladiators[peer_id]["total_modifier_bonuses"].get("increased_quickness", 0))/100)
	#all_gladiators[peer_id]["attributes"]["crit_rating"] = all_gladiators[peer_id]["attributes"].get("crit_rating", 0)*(1+float(all_gladiators[peer_id]["total_modifier_bonuses"].get("increased_crit_rating", 0))/100)
	#all_gladiators[peer_id]["attributes"]["avoidance"] = all_gladiators[peer_id]["attributes"].get("avoidance", 0)*(1+float(all_gladiators[peer_id]["total_modifier_bonuses"].get("increased_avoidance", 0))/100)
	#all_gladiators[peer_id]["attributes"]["health"] = all_gladiators[peer_id]["attributes"].get("health", 0)*(1+float(all_gladiators[peer_id]["total_modifier_bonuses"].get("increased_health", 0))/100)
	#all_gladiators[peer_id]["attributes"]["resilience"] = all_gladiators[peer_id]["attributes"].get("resilience", 0)*(1+float(all_gladiators[peer_id]["total_modifier_bonuses"].get("increased_resilience", 0))/100)
	#all_gladiators[peer_id]["attributes"]["endurance"] = all_gladiators[peer_id]["attributes"].get("endurance", 0)*(1+float(all_gladiators[peer_id]["total_modifier_bonuses"].get("increased_endurance", 0))/100)
	
	var all_attributes = all_gladiators[peer_id]["attributes"].keys()
	for attr in all_attributes:
		var increased_string = "increased_" + attr
		all_gladiators[peer_id]["attributes"][attr] = all_gladiators[peer_id]["attributes"].get(attr, 0)*(1+float(all_gladiators[peer_id]["total_modifier_bonuses"].get(increased_string, 0))/100)


@rpc("any_peer", "call_local")
func collect_gladiator_bonuses(id): 
	var merged := {}
	var excluded_keys := ["inventory", "total_modifier_bonuses"]
	var skip_weapon2 := false
	var gladiator = all_gladiators[id].duplicate(true)

	for key in gladiator.keys():
		if excluded_keys.has(key):
			continue

		var slot = gladiator[key]
		if typeof(slot) != TYPE_DICTIONARY:
			continue

		for item_key in slot.keys():
			var item = slot[item_key]
			if typeof(item) != TYPE_DICTIONARY:
				continue

			# Check if weapon1 is two-handed
			if key == "weapon1" and item.has("hands") and item["hands"] == 2:
				skip_weapon2 = true

			# Skip weapon2 if weapon1 is two-handed
			if key == "weapon2" and skip_weapon2 and item.has("type") and item["type"] == "weapon":
				continue

			# Collect bonuses
			if item.has("modifiers") and item["modifiers"].has("bonuses"):
				var bonuses = item["modifiers"]["bonuses"]
				for bonus_key in bonuses.keys():
					var value = bonuses[bonus_key]
					print(value)
					#var numeric_value = float(value) if typeof(value) in [TYPE_STRING, TYPE_INT, TYPE_FLOAT] and String(value).is_valid_float() else 0
					
					if bonus_key == "blood_rage":
						print("pause")
					
					if merged.has(bonus_key):
						if value is Array:
							for i in range(len(value)):
								#var numeric_value = float(value[i]) if typeof(value[i]) in [TYPE_STRING, TYPE_INT, TYPE_FLOAT] and String(value[i]).is_valid_float() else 0
								merged[bonus_key][i] += float(value[i])
						else:
							#var numeric_value = float(value) if typeof(value) in [TYPE_STRING, TYPE_INT, TYPE_FLOAT] and String(value).is_valid_float() else 0
							merged[bonus_key] += float(value)
					else:
						#if value is Array:
						#	for i in range(len(value)):
								#var numeric_value = float(value[i]) if typeof(value[i]) in [TYPE_STRING, TYPE_INT, TYPE_FLOAT] and String(value[i]).is_valid_float() else 0
						#		merged[bonus_key][i] = float(value[i])#numeric_value[i]
						#else:
							#var numeric_value = float(value) if typeof(value) in [TYPE_STRING, TYPE_INT, TYPE_FLOAT] and String(value).is_valid_float() else 0
						if value is Array: merged[bonus_key] = value
						else: merged[bonus_key] = float(value)
	return merged

@rpc("any_peer", "call_local")
func peer_attack_type(id, type): 
	all_gladiators[id]["attack_type"] = type
	rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators[id], all_gladiators)
	
@rpc("any_peer", "call_local")
func peer_stance(id, stance): 
	all_gladiators[id]["stance"] = stance
	rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators[id], all_gladiators)

@rpc("any_peer", "call_local")
func peer_concede(id, threshold): 
	all_gladiators[id]["concede"] = threshold
	rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators[id], all_gladiators)
	
@rpc("any_peer", "call_local")
func send_gladiator_data_to_peer_card(id: int, _gladiator_data, _all_gladiators) -> void:
	emit_signal("send_gladiator_data_to_peer_card_signal", id, _gladiator_data, _all_gladiators)

@rpc("any_peer", "call_local")
func refresh_gladiator_data_card(id: int) -> void:
	#print("asdasdasd: " + str(all_gladiators[id]))
	rpc_id(id, "send_gladiator_data_to_peer_card", id, all_gladiators[id], all_gladiators)
	
@rpc("any_peer", "call_local")
func send_gladiator_data_to_peer(id: int, _gladiator_data, _all_gladiators) -> void:
	emit_signal("send_gladiator_data_to_peer_signal", id, _gladiator_data, _all_gladiators)

@rpc("any_peer", "call_local")
func refresh_gladiator_data(id: int) -> void:
	#print("asdasdasd: " + str(all_gladiators[id]))
	rpc("send_gladiator_data_to_peer", id, all_gladiators.get(id, {}), all_gladiators)

@rpc("authority", "call_local")
func notify_card_buy_result(id: int, success: bool, _gladiator_data) -> void:
	emit_signal("card_buy_result", id, success, _gladiator_data)


@rpc("any_peer", "call_local")
func update_equipment_card(id, item_dict_to_craft, slot, item):
	#print("update_equipment_card")
	#print(item)
	emit_signal("update_equipment_card_signal", id, item_dict_to_craft, slot, item)
	
@rpc("any_peer", "call_local")
func add_item_to_inventory(id, item_dict, slot_name):
	emit_signal("add_item_to_inventory_signal", id, item_dict, slot_name)
	
@rpc("any_peer", "call_local")
func remove_item_from_inventory(id, item_dict, slot_name):
	emit_signal("remove_item_from_inventory_signal", id, item_dict, slot_name)

@rpc("any_peer", "call_local")
func add_item_to_equipment(peer_id, item_dict, category):
	emit_signal("add_item_to_equipment_signal", peer_id, item_dict, category)
	
@rpc("any_peer", "call_local")
func remove_item_from_equipment(peer_id, item_dict, category):
	emit_signal("remove_item_from_equipment_signal", peer_id, item_dict, category)
	
'''
signal update_equipment_card_signal(id, item_dict_to_craft, slot, item)
signal add_item_to_inventory_signal(id, item_dict, slot_name)
signal remove_item_from_inventory_signal(id, item_dict, slot_name)
signal add_item_to_equipment_signal(peer_id, item_dict, category)
signal remove_item_from_equipment_signal(peer_id, item_dict, category)
'''

@rpc("any_peer", "call_local")
func buy_equipment_card(id: int, equipment: String, cost: int, ): 
	var success := false
	if all_cards_stock[equipment] >= 1:
		if all_gladiators[id]["gold"] >= cost:
			var item_dict = get_equipment_by_name(id, equipment).duplicate(true)
			
			for slot_name in all_gladiators[id]["inventory"].keys():
				if all_gladiators[id]["inventory"][slot_name] == {}:
					#print(slot_name + " is empty, putting item there")
					item_dict[equipment]["inventory_slot"] = slot_name
					#print(item_dict)
					all_gladiators[id]["inventory"][slot_name] = item_dict
					all_gladiators[id]["gold"] -= cost
					adjust_card_stock(equipment, "remove")
					success = true
					rpc_id(id, "update_gold_req_in_shop_for_peer", id, all_gladiators[id]["gold"])
					rpc_id(id, "add_item_to_inventory", id, item_dict, slot_name)
					rpc_id(id, "notify_card_buy_result", id, success, all_gladiators[id])
					rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators[id], all_gladiators)
					return
			add_to_peer_log(id, "[INFO] ❌No inventory space!")
		else: add_to_peer_log(id, "[INFO] ❌Not enough gold!")
	else: 
		add_to_peer_log(id, "No " + equipment + " cards left in stock!")
		
		rpc_id(id, "notify_card_buy_result", id, success, all_gladiators[id])
		rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators[id], all_gladiators)

@rpc("any_peer", "call_local")
func sell_from_equipment(peer_id: int, equipment: String, equipment_button_parent_name, category): 
	# 1 remove from slot, increase gold
	# replace with unarmed if weapon is sold
	var item_dict = all_gladiators[peer_id][category]#get_equipment_by_name(peer_id, equipment)
	#var slot_name = item_dict.get("inventory_slot", "")
	var price = item_dict[equipment]["price"]
	#var type = item_dict[equipment]["type"] # to be implemented
	var hands = item_dict[equipment].get("hands", -1)
	var item = equipment_button_parent_name.replace("Slot", "").to_lower()
	var modifier_attributes = item_dict[equipment]["modifiers"].get("attributes", {})
	var modifier_bonuses = item_dict[equipment]["modifiers"].get("bonuses", {})
	var weight = item_dict[equipment].get("weight", 0)
	#var sell_success = 0
	
	if hands == 2:
		all_gladiators[peer_id]["weapon1"] = get_equipment_by_name(peer_id, "unarmed")
		all_gladiators[peer_id]["weapon2"] = get_equipment_by_name(peer_id, "unarmed")
	elif item == "weapon1" or item == "weapon2": all_gladiators[peer_id][item] = get_equipment_by_name(peer_id, "unarmed")
	else: all_gladiators[peer_id][item] = {}
	
	# Remove item modifier attributes from items
	if modifier_attributes != {}:
		for attribute in modifier_attributes:
			all_gladiators[peer_id]["attributes"][attribute] -= modifier_attributes[attribute]
	
	# TODO Remove item modifier bonuses
	if modifier_bonuses != {}: 1 
	
	# Remove weight of item
	if weight: all_gladiators[peer_id]["weight"] -= weight
	
	all_gladiators[peer_id]["gold"] += int(price/2)
	
	rpc_id(peer_id, "update_gold_req_in_shop_for_peer", peer_id, all_gladiators[peer_id]["gold"])
	adjust_card_stock(equipment, "add")  # Restore stock
	rpc_id(peer_id, "remove_item_from_equipment", peer_id, item_dict, category)
	rpc("send_gladiator_data_to_peer", peer_id, all_gladiators[peer_id], all_gladiators)
	return

	#print("Item not found in equipment panel!")
					
@rpc("any_peer", "call_local")
func sell_from_inventory(id: int, equipment: String, selected_slot): 
	if all_gladiators[id]["inventory"][selected_slot] == {}:
		add_to_peer_log(id, "[INFO] ❌Item not found in inventory!")
		return
	
	var item_dict = get_equipment_by_name(id, equipment)
	var price = item_dict[equipment]["price"]
	
	all_gladiators[id]["inventory"][selected_slot] = {}  # Clear slot
	all_gladiators[id]["gold"] += int(price/2)
	rpc_id(id, "update_gold_req_in_shop_for_peer", id, all_gladiators[id]["gold"])
	rpc_id(id, "remove_item_from_inventory", id, item_dict, selected_slot)
	adjust_card_stock(equipment, "add")  # Restore stock
	rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators[id], all_gladiators)
	

'''
	for slot_name in all_gladiators[id]["inventory"].keys():
		var item = all_gladiators[id]["inventory"][slot_name]
		

		# Check if the item is a dictionary and contains the equipment name
		if typeof(item) == TYPE_DICTIONARY and item.has(equipment) and item[equipment]["inventory_slot"] == slot_name:
			print("item to sell: " + str(item))
			all_gladiators[id]["inventory"][slot_name] = {}  # Clear slot
			all_gladiators[id]["gold"] += int(price/2)
			#print("gold: " + str(all_gladiators[id]["gold"]))
			emit_signal("sell_item_from_inventory", id, item_dict, slot_name)
			adjust_card_stock(equipment, "add")  # Restore stock
			rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators[id], all_gladiators)
			return  # Exit after first match
'''
	
	
@rpc("any_peer", "call_local")
func buy_craft_card(id, craft_name, cost):
	var success := false
	if all_cards_stock[craft_name] >= 1:
		if all_gladiators[id]["gold"] >= cost:
			all_gladiators[id]["crafting_mats"][craft_name] += 1
			all_gladiators[id]["gold"] -= cost
			adjust_card_stock(craft_name, "remove")
			success = true
			rpc_id(id, "notify_card_buy_result", id, success, all_gladiators[id])
			rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators[id], all_gladiators)
			rpc_id(id, "update_gold_req_in_shop_for_peer", id, all_gladiators[id]["gold"])
		else: add_to_peer_log(id, "[INFO] ❌Not enough gold!")
	else: 
		add_to_peer_log(id, "[INFO] ❌No " + craft_name + " cards left in stock!")
	
@rpc("any_peer", "call_local")
func buy_attribute_card(id: int, amount: int, attribute: String, cost: int):
	var success := false
	if all_cards_stock[attribute] >= 1:
		if all_gladiators[id]["gold"] >= cost:
			#print("modify_attribute called on peer: ", multiplayer.get_unique_id())
			var race = all_gladiators[id]["race"]
			
			total_modifier_bonuses = collect_gladiator_bonuses(id)
			if all_gladiators.has(id):
				var key = "increased_" + attribute
				var amount_after_bonuses = float(amount)*RACE_MODIFIERS[race][attribute]*(1+float(total_modifier_bonuses.get(key, 0))/100)
				print("amount_after_bonuses: " + str(amount_after_bonuses))
				all_gladiators[id]["attributes"][attribute] += amount_after_bonuses
				all_gladiators[id]["gold"] -= cost
				emit_signal("gladiator_attribute_changed", all_gladiators)
				adjust_card_stock(attribute, "remove")
				success = true
				rpc_id(id, "update_gold_req_in_shop_for_peer", id, all_gladiators[id]["gold"])
				rpc_id(id, "notify_card_buy_result", id, success, all_gladiators[id])
				rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators[id], all_gladiators)
				update_all_equipment_cards(id)
		else: add_to_peer_log(id, "[INFO] ❌Not enough gold!")
	else: 
		add_to_peer_log(id, "[INFO] ❌No " + attribute + " cards left in stock!")
		rpc_id(id, "notify_card_buy_result", id, success, all_gladiators[id])
		
		
		
@rpc("any_peer")
func initialize_card_stock():
	emit_signal("card_stock_changed", all_cards_stock)
	

@rpc("any_peer")
func adjust_card_stock(card: String, action: String):
	if action == "remove": all_cards_stock[card] -= 1
	if action == "add": all_cards_stock[card] += 1
	
	emit_signal("card_stock_changed", all_cards_stock)

@rpc("any_peer", "call_local")
func modify_gladiator_life(id: int, life_lost: int):
	if all_gladiators.has(id):
		var color = all_gladiators[id]["color"]
		var glad_name = all_gladiators[id]["name"]
		var hex_color = color.to_html()
		var formatted = "[color=%s]%s[/color] was defeated and lost [color=%s]%s life [/color]" % [hex_color, glad_name, Color.RED.to_html(), str(life_lost)]
		
		add_to_log(get_multiplayer_authority(), formatted)
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
	#var used_colors = []
	#for gladiator in all_gladiators.values():
	#	used_colors.append(gladiator.get("color"))
		
	#var available_colors = peer_colors.filter(func(c): return not used_colors.has(c))
	#var assigned_color = available_colors.pick_random()
	#print("peer_id: " + str(peer_id))
	#print("player_colors: " + str(player_colors))
	#print("player_colors[1]: " + str(player_colors[1]))
	
	if player_colors.has(int(peer_id)):
		data["color"] = player_colors[int(peer_id)]
	all_gladiators[peer_id] = data
	
	#print("🎯 Gladiator stored for peer:", peer_id)
	#print(all_gladiators)
	#print("all_gladiators.size(): " + str(all_gladiators.size()))
	#print("len(_players): " + str(len(_players)))
	players_ready += 1
	
	var total_peers = 0
	#if multiplayer.is_server(): 
	for i in multiplayer.get_peers():
		if i == 0: continue
		total_peers += 1
	print("all_gladiators.size(): " + str(all_gladiators.size()) + " | multiplayer.get_peers(): " + str(multiplayer.get_peers()))
	if all_gladiators.size() == total_peers+1:# and len(multiplayer.get_peers()) > 1:  # >= NetworkManager_.max_players + 1:
		
		#await get_tree().create_timer(2).timeout
		var countdown = 1
		for i in countdown:
			add_to_log(get_multiplayer_authority(), "✅ All players ready, starting game in %s..." % [str(countdown-i)])
			await get_tree().create_timer(1).timeout
		
		_start_game.rpc()
		_start_game()
		
@rpc("authority")
func _start_game():
	print("All gladiators submitted! Starting game...")
	players_ready_list = []
	get_tree().change_scene_to_file.bind("res://main.tscn").call_deferred()

func erase_all_data():
	all_gladiators = {}

func _assign_authority():
	if multiplayer.is_server():
		print("🌐 Assigning multiplayer authority on host " + str(multiplayer.get_unique_id()))
		set_multiplayer_authority(multiplayer.get_unique_id())
		
		print("✅ Authority set to:", get_multiplayer_authority())
	else:
		print("ℹ️ Client does not assign authority")

func kill_peer(id: int):
	emit_signal("killed_by_server_signal", id)
	
@rpc("any_peer", "call_local")
func reroll_cards_new_round(_active_players: Array):
	active_players = _active_players
	rpc("reroll_cards_new_round_send_signal", active_players)
	
@rpc("authority", "call_local")
func reroll_cards_new_round_send_signal(_active_players: Array):
	print("Emitting signal reroll_cards_new_round, active_players = " + str(_active_players))
	emit_signal("reroll_cards_new_round_signal", _active_players)


@rpc("any_peer", "call_local")
func use_craft_mat_on_item(id, craft_mat, item, slot):
	
	var stock_item = get_equipment_by_name(id, item).duplicate(true)
	var item_dict_to_craft = all_gladiators[id]["inventory"][slot].duplicate(true)
	var possible_attributes = attr_cards_stock.keys()
	var roll_interval_max = 3+2*item_dict_to_craft[item]["level"]
	
	# == TOME OF CHAOS ==
	if craft_mat == "scroll_of_luck": # Roll 3 attributes
		item_dict_to_craft = stock_item.duplicate(true)
		#print("stock item: " + str(item_dict_to_craft))
		var nbr_of_bonuses_pool = [0,0,1,1,2,2,3]
		var nbr_of_bonuses = randi() % nbr_of_bonuses_pool.size()
		var nbr_of_bonuses_to_roll = nbr_of_bonuses_pool[nbr_of_bonuses]
		var random_bonuses = get_bonuses_rolls(id, slot, nbr_of_bonuses_to_roll)
		#print("random_bonuses: " + str(random_bonuses))
		item_dict_to_craft[item]["modifiers"]["bonuses"] = random_bonuses.duplicate(true)
		
		var nbr_of_attributes_pool = [1,1,1,1,2,2,3]
		var nbr_of_attributes = randi() % nbr_of_attributes_pool.size()
		var nbr_of_attributes_to_roll = nbr_of_attributes_pool[nbr_of_attributes]
		var random_attributes = get_attribute_rolls(possible_attributes, nbr_of_attributes_to_roll, roll_interval_max)
		#print("random_attributes: " + str(random_attributes))
		item_dict_to_craft[item]["modifiers"]["attributes"] = random_attributes.duplicate(true)
		
	# == TOME OF INJECTION ==
	if craft_mat == "scroll_of_injection": # Add 1 new attribute
		var existing_attributes_on_item = item_dict_to_craft[item]["modifiers"]["attributes"].keys().size()
		var existing_bonuses_on_item = item_dict_to_craft[item]["modifiers"]["bonuses"].keys().size()
		
		var random_bonus = get_scroll_of_injection_bonus_roll(id, item, slot)
		var random_attribute = get_scroll_of_injection_attribute_roll(item_dict_to_craft[item]["modifiers"]["attributes"], possible_attributes, roll_interval_max)
		
		if existing_attributes_on_item >= 3 and existing_bonuses_on_item < 3: 
			if random_bonus == {}:
				add_to_peer_log(id, "[INFO] No more bonuses exists for this item!")
				return
			item_dict_to_craft[item]["modifiers"]["bonuses"][random_bonus.keys()[0]] = random_bonus[random_bonus.keys()[0]]
			
		elif existing_attributes_on_item < 3 and existing_bonuses_on_item >= 3: 
			item_dict_to_craft[item]["modifiers"]["attributes"][random_attribute.keys()[0]] = random_attribute[random_attribute.keys()[0]]
			
		elif existing_attributes_on_item < 3 and existing_bonuses_on_item < 3: 
			var coin_flip = randi() % 2
			if random_bonus == {}:
				coin_flip = 1
			
			if coin_flip == 0:
				item_dict_to_craft[item]["modifiers"]["bonuses"][random_bonus.keys()[0]] = random_bonus[random_bonus.keys()[0]]
			elif coin_flip == 1: 
				item_dict_to_craft[item]["modifiers"]["attributes"][random_attribute.keys()[0]] = random_attribute[random_attribute.keys()[0]]
			
		else:
			add_to_peer_log(id, "[INFO] ❌Item is full on modifiers!")
			return
		
	# == TOME OF LIBERTY ==
	if craft_mat == "scroll_of_liberty": print("") # Remove all/one modifiers
			
	var bonuses_after_craft = item_dict_to_craft[item]["modifiers"]["bonuses"]
		
	if "local_increased_attack_speed" in bonuses_after_craft:
		var wep_base_attack_speed = stock_item[item].get("speed", -1)
		item_dict_to_craft[item]["speed"] = wep_base_attack_speed*(1+float(bonuses_after_craft["local_increased_attack_speed"])/100.0)
		
	if "local_increased_crit_multi" in bonuses_after_craft:
		var wep_base_crit_multi = stock_item[item].get("crit_multi", -1)
		item_dict_to_craft[item]["crit_multi"] = wep_base_crit_multi*(1+float(bonuses_after_craft["local_increased_crit_multi"])/100.0)
		
	if "local_increased_crit_chance" in bonuses_after_craft:
		var wep_base_crit_chance = stock_item[item].get("crit_chance", -1)
		item_dict_to_craft[item]["crit_chance"] = wep_base_crit_chance*(1+float(bonuses_after_craft["local_increased_crit_chance"])/100.0)

	if "local_added_abs" in bonuses_after_craft:
		var base_abs = stock_item[item].get("absorb", -1)
		item_dict_to_craft[item]["absorb"] = base_abs + float(bonuses_after_craft["local_added_abs"])
		
	if "local_added_durability" in bonuses_after_craft or "local_increased_durability" in bonuses_after_craft:
		var base_durability = stock_item[item].get("durability", -1)
		var added_durability = float(bonuses_after_craft.get("local_added_durability", 0))
		var increased_durability = float(bonuses_after_craft.get("local_increased_durability", 0))
		item_dict_to_craft[item]["durability"] = (base_durability + added_durability)*(1+increased_durability/100.0)
				

			
	all_gladiators[id]["crafting_mats"][craft_mat] -= 1
	all_gladiators[id]["inventory"][slot] = item_dict_to_craft.duplicate(true)
	rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators[id], all_gladiators)
	rpc("send_gladiator_data_to_peer", id, all_gladiators[id], all_gladiators)
	rpc_id(id, "update_equipment_card", id, all_gladiators[id]["inventory"][slot], slot, item)
	
	print(all_gladiators[id])





func get_attribute_rolls(attribute_list: Array, nbr_of_rolls: int, roll_interval_max: int) -> Dictionary:
	var result := {}
	var mastery_attrs := []
	var non_mastery_attrs := []

	# Separate mastery and non-mastery attributes
	for attr in attribute_list:
		if "mastery" in attr:
			mastery_attrs.append(attr)
		else:
			non_mastery_attrs.append(attr)

	# Build weighted pool
	var weighted_pool := non_mastery_attrs.duplicate()
	if mastery_attrs.size() > 0:
		# Add one mastery placeholder to represent all mastery attributes
		weighted_pool.append("mastery_group")

	# Select attributes
	var selected := []
	var pool = weighted_pool.duplicate()
	pool.shuffle()

	for i in range(nbr_of_rolls):
		if pool.is_empty():
			break
		var pick = pool.pop_front()
		if pick == "mastery_group":
			selected.append(mastery_attrs.pick_random())
		else:
			selected.append(pick)

	# Roll values with exponential bias
	for attr in selected:
		var raw = randf()
		var curved = pow(raw, 1.2) # higher -> harder to get good rolls
		var roll = int(ceil(curved * roll_interval_max))
		roll = clamp(roll, 1, roll_interval_max)
		result[attr] = roll

	return result


func get_bonuses_rolls(id, slot, nbr_of_rolls):
	var item_dict_to_craft = all_gladiators[id]["inventory"][slot].duplicate(true)
	var possible_bonuses = get_possible_bonuses_for_item(item_dict_to_craft)
			
	var keys = possible_bonuses.keys()
	keys.shuffle()

	var selected := {}
	for i in range(min(nbr_of_rolls, keys.size())):
		var key = keys[i]
		selected[key] = possible_bonuses[key]

	return selected
		
		
func get_scroll_of_injection_attribute_roll(item_dict_to_craft: Dictionary, attribute_list: Array, roll_interval_max: int) -> Dictionary:
	var result := {}

	# Filter out attributes that already exist
	var available_attrs := []
	for attr in attribute_list:
		if not item_dict_to_craft.has(attr):
			available_attrs.append(attr)

	# If no new attributes are available, return empty
	if available_attrs.is_empty():
		return result

	# Pick one attribute randomly
	var chosen_attr = available_attrs.pick_random()

	# Roll value with exponential bias
	var raw = randf()
	var curved = pow(raw, 1)  # Bias toward lower values
	var roll = int(ceil(curved * roll_interval_max))
	roll = clamp(roll, 1, roll_interval_max)

	result[chosen_attr] = roll
	return result
			
			
func get_scroll_of_injection_bonus_roll(id, item, slot):
	var item_dict_to_craft = all_gladiators[id]["inventory"][slot].duplicate(true)
	var existing_bonuses = item_dict_to_craft[item]["modifiers"].get("bonuses", {})
	var possible_bonuses = get_possible_bonuses_for_item(item_dict_to_craft)
	
	var available_keys := []
	for key in possible_bonuses.keys():
		if not existing_bonuses.has(key):
			available_keys.append(key)

	if available_keys.is_empty():
		return {}  # No new bonuses available

	var chosen_key = available_keys.pick_random()
	return {chosen_key: possible_bonuses[chosen_key]}

			
			
func get_possible_bonuses_for_item(item_dict):
	var item = item_dict.keys()[0]
	var item_level = item_dict[item]["level"]
	var type = item_dict[item]["type"]
	var category = item_dict[item]["category"]
	var hands = item_dict[item].get("hands", -1)
	var durability = item_dict[item].get("durability", -1)
			
	var possible_bonuses = {}
	
	if type == "weapon" and category != "shield":
		if hands == 1:
			possible_bonuses = {
				"added_dmg": str(randi_range(1, item_dict[item]["min_dmg"]/2)) + "-" + 
							str(randi_range(item_dict[item]["min_dmg"]/2, item_dict[item]["max_dmg"]/2)),
				"increased_dmg": str(randi_range(2*item_level, 10*item_level)),
				"added_hit_chance": str(randi_range(1, item_level)),
				"local_increased_attack_speed": str(randi_range(item_level, 3*item_level)),
				"local_increased_crit_multi": str(randi_range(item_level, 4*item_level)),
				"local_increased_crit_chance": str(randi_range(item_level, 4*item_level)),
				"life_on_hit": str(randi_range(1, item_level)),
				"local_added_durability": str(randi_range(durability/5, durability/1.5)),
				"local_increased_durability": str(randi_range(2*item_level, 10*item_level)),
				
				"increased_sword_mastery": str(randi_range(item_level, 2*item_level)),
				"increased_axe_mastery": str(randi_range(item_level, 2*item_level)),
				"increased_stabbing_mastery": str(randi_range(item_level, 2*item_level)),
				"increased_mace_mastery": str(randi_range(item_level, 2*item_level)),
				"increased_flagellation_mastery": str(randi_range(item_level, 2*item_level)),
				"increased_shield_mastery": str(randi_range(item_level, 2*item_level))
			}
		elif hands == 2:
			possible_bonuses = {
				"added_dmg": str(2*randi_range(1, item_dict[item]["min_dmg"]/2)) + "-" + 
							str(2*randi_range(item_dict[item]["min_dmg"]/2, item_dict[item]["max_dmg"]/2)),
				"increased_dmg": str(2*randi_range(2*item_level, 10*item_level)),
				"added_hit_chance": str(randi_range(1, 2*item_level)),
				"local_increased_attack_speed": str(2*randi_range(item_level, 3*item_level)),
				"local_increased_crit_multi": str(2*randi_range(item_level, 4*item_level)),
				"local_increased_crit_chance": str(2*randi_range(item_level, 4*item_level)),
				"life_on_hit": str(2*randi_range(1, item_level)),
				"local_added_durability": str(randi_range(durability/5, durability/1.5)),
				"local_increased_durability": str(randi_range(4*item_level, 15*item_level)),
				
				"increased_sword_mastery": str(randi_range(item_level, 2*item_level)),
				"increased_axe_mastery": str(randi_range(item_level, 2*item_level)),
				"increased_stabbing_mastery": str(randi_range(item_level, 2*item_level)),
				"increased_mace_mastery": str(randi_range(item_level, 2*item_level)),
				"increased_flagellation_mastery": str(randi_range(item_level, 2*item_level)),
				"increased_shield_mastery": str(randi_range(item_level, 2*item_level))
			}
			
	if type == "weapon" and category == "shield":
		possible_bonuses = {
			"local_added_abs": str(randi_range(1, item_level)),
			"local_added_durability": str(randi_range(durability/5, durability/1.5)),
			"local_increased_durability": str(randi_range(2*item_level, 10*item_level)),
			"added_block_chance": str(randi_range(1, item_level)),
			"life_on_block": str(randi_range(item_level, 3*item_level)),
			
			"increased_sword_mastery": str(randi_range(item_level, 2*item_level)),
			"increased_axe_mastery": str(randi_range(item_level, 2*item_level)),
			"increased_stabbing_mastery": str(randi_range(item_level, 2*item_level)),
			"increased_mace_mastery": str(randi_range(item_level, 2*item_level)),
			"increased_flagellation_mastery": str(randi_range(item_level, 2*item_level)),
			"increased_shield_mastery": str(randi_range(item_level, 2*item_level))
			
			
		}
		
	if category == "ring":
		possible_bonuses = {
			"life_on_block": str(randi_range(item_level, 2*item_level)),
			"life_on_hit": str(2*randi_range(item_level, 1.5*item_level)),
			"added_hit_chance": str(randi_range(1, 2*item_level)),
			"global_increased_crit_chance": str(2*randi_range(item_level, 3*item_level)),
			"global_increased_crit_multi": str(2*randi_range(item_level, 3*item_level)),
			"global_increased_attack_speed": str(2*randi_range(item_level, 3*item_level)),
			
			"increased_health": str(randi_range(item_level, 2*item_level)),
			"increased_strength": str(randi_range(item_level, 2*item_level)),
			"increased_quickness": str(randi_range(item_level, 2*item_level)),
			"increased_crit_rating": str(randi_range(item_level, 2*item_level)),
			"increased_avoidance": str(randi_range(item_level, 2*item_level)),
			"increased_resilience": str(randi_range(item_level, 2*item_level)),
			"increased_endurance": str(randi_range(item_level, 2*item_level)),
			
			"blood_rage": [randf_range(0.25, 0.75), randi_range(item_level, 3*item_level)],
			"to_gold_income": str(clamp(randi_range(1, item_level/1.5), 1, 9999))
		}
		
	if category == "amulet" or category == "necklace":
		possible_bonuses = {
			"life_on_block": str(1.5*randi_range(item_level, 2*item_level)),
			"life_on_hit": str(3*randi_range(item_level, 1.5*item_level)),
			"added_hit_chance": str(1.5*randi_range(1, 2*item_level)),
			"global_increased_crit_chance": str(3*randi_range(item_level, 3*item_level)),
			"global_increased_crit_multi": str(3*randi_range(item_level, 3*item_level)),
			"global_increased_attack_speed": str(3*randi_range(item_level, 3*item_level)),
			
			"increased_health": str(randi_range(item_level, 2*item_level)),
			"increased_strength": str(randi_range(item_level, 2*item_level)),
			"increased_quickness": str(randi_range(item_level, 2*item_level)),
			"increased_crit_rating": str(randi_range(item_level, 2*item_level)),
			"increased_avoidance": str(randi_range(item_level, 2*item_level)),
			"increased_resilience": str(randi_range(item_level, 2*item_level)),
			"increased_endurance": str(randi_range(item_level, 2*item_level)),
			
			"blood_rage": str([randf_range(0.25, 0.75), randi_range(item_level, 3*item_level)]),
			"to_gold_income": str(clamp(randi_range(1, item_level/1.5), 1, 9999))
		}
		
	if category == "trinket":
		possible_bonuses = {
			"life_on_block": str(1.5*randi_range(item_level, 2*item_level)),
			"life_on_hit": str(3*randi_range(item_level, 1.5*item_level)),
			"added_hit_chance": str(1.5*randi_range(1, 2*item_level)),
			"global_increased_crit_chance": str(3*randi_range(item_level, 3*item_level)),
			"global_increased_crit_multi": str(3*randi_range(item_level, 3*item_level)),
			"global_increased_attack_speed": str(3*randi_range(item_level, 3*item_level)),
			
			"increased_health": str(randi_range(item_level, 2*item_level)),
			"increased_strength": str(randi_range(item_level, 2*item_level)),
			"increased_quickness": str(randi_range(item_level, 2*item_level)),
			"increased_crit_rating": str(randi_range(item_level, 2*item_level)),
			"increased_avoidance": str(randi_range(item_level, 2*item_level)),
			"increased_resilience": str(randi_range(item_level, 2*item_level)),
			"increased_endurance": str(randi_range(item_level, 2*item_level)),
			
			"blood_rage": [randf_range(0.25, 0.75), randi_range(item_level, 3*item_level)],
			"to_gold_income": str(clamp(randi_range(1, item_level/1.5), 1, 9999))
		}
		
	if category == "back":
		possible_bonuses = {
			"life_on_block": str(1.5*randi_range(item_level, 2*item_level)),
			"life_on_hit": str(3*randi_range(item_level, 1.5*item_level)),
			"added_hit_chance": str(1.5*randi_range(1, 2*item_level)),
			"global_increased_crit_chance": str(3*randi_range(item_level, 3*item_level)),
			"global_increased_crit_multi": str(3*randi_range(item_level, 3*item_level)),
			"global_increased_attack_speed": str(3*randi_range(item_level, 3*item_level)),
			
			"increased_health": str(randi_range(item_level, 2*item_level)),
			"increased_strength": str(randi_range(item_level, 2*item_level)),
			"increased_quickness": str(randi_range(item_level, 2*item_level)),
			"increased_crit_rating": str(randi_range(item_level, 2*item_level)),
			"increased_avoidance": str(randi_range(item_level, 2*item_level)),
			"increased_resilience": str(randi_range(item_level, 2*item_level)),
			"increased_endurance": str(randi_range(item_level, 2*item_level)),
			
			"increased_sword_mastery": str(randi_range(item_level, 2*item_level)),
			"increased_axe_mastery": str(randi_range(item_level, 2*item_level)),
			"increased_stabbing_mastery": str(randi_range(item_level, 2*item_level)),
			"increased_mace_mastery": str(randi_range(item_level, 2*item_level)),
			"increased_flagellation_mastery": str(randi_range(item_level, 2*item_level)),
			"increased_shield_mastery": str(randi_range(item_level, 2*item_level)),
			
			"to_gold_income": str(clamp(randi_range(1, item_level/1.5), 1, 9999))
		}
		
	if category == "belt":
		possible_bonuses = {
			"life_on_block": str(1.5*randi_range(item_level, 2*item_level)),
			"life_on_hit": str(3*randi_range(item_level, 1.5*item_level)),
			"added_hit_chance": str(1.5*randi_range(1, 2*item_level)),
			"global_increased_crit_chance": str(3*randi_range(item_level, 3*item_level)),
			"global_increased_crit_multi": str(3*randi_range(item_level, 3*item_level)),
			"global_increased_attack_speed": str(3*randi_range(item_level, 3*item_level)),
			
			"increased_health": str(randi_range(item_level, 2*item_level)),
			"increased_strength": str(randi_range(item_level, 2*item_level)),
			"increased_avoidance": str(randi_range(item_level, 2*item_level)),
			"increased_resilience": str(randi_range(item_level, 2*item_level)),
			"increased_endurance": str(randi_range(item_level, 2*item_level)),
			
			"to_gold_income": str(clamp(randi_range(1, item_level/1.5), 1, 9999))
		}
		
	if category in ["chest", "head", "legs", "shoulders"]:
		possible_bonuses = {
			"local_added_abs": str(randi_range(1, item_level)),
			"life_on_block": str(1.5*randi_range(item_level, 2*item_level)),
			"life_on_hit": str(3*randi_range(item_level, 1.5*item_level)),
			
			"increased_health": str(randi_range(item_level, 2*item_level)),
			"increased_avoidance": str(randi_range(item_level, 2*item_level)),
			"increased_resilience": str(randi_range(item_level, 2*item_level)),
			"increased_endurance": str(randi_range(item_level, 2*item_level)),
			
			"thorns": str(randi_range(1, item_level)),
			"to_gold_income": str(clamp(randi_range(1, item_level/1.5), 1, 9999))
			
		}
		
	if category == "boots":
		possible_bonuses = {
			"local_added_abs": str(clamp(randi_range(1, item_level/1.5), 1, 9999)),
			"life_on_block": str(1.5*randi_range(item_level, 2*item_level)),
			"life_on_hit": str(3*randi_range(item_level, 1.5*item_level)),
			
			"increased_health": str(randi_range(item_level, 2*item_level)),
			"increased_strength": str(randi_range(item_level, 2*item_level)),
			"increased_quickness": str(randi_range(item_level, 2*item_level)),
			"increased_avoidance": str(randi_range(item_level, 2*item_level)),
			"increased_resilience": str(randi_range(item_level, 2*item_level)),
			"increased_endurance": str(randi_range(item_level, 2*item_level)),
			
			"thorns": str(randi_range(1, item_level)),
			"to_gold_income": str(clamp(randi_range(1, item_level/1.5), 1, 9999))
		}
		
	if category == "gloves":
		possible_bonuses = {
			"local_added_abs": str(clamp(randi_range(1, item_level/1.5), 1, 9999)),
			"life_on_block": str(1.5*randi_range(item_level, 2*item_level)),
			"life_on_hit": str(3*randi_range(item_level, 1.5*item_level)),
			"added_hit_chance": str(1.5*randi_range(1, 2*item_level)),
			"global_increased_crit_chance": str(3*randi_range(item_level, 3*item_level)),
			"global_increased_crit_multi": str(3*randi_range(item_level, 3*item_level)),
			"global_increased_attack_speed": str(3*randi_range(item_level, 3*item_level)),
			
			"increased_health": str(randi_range(item_level, 2*item_level)),
			"increased_strength": str(randi_range(item_level, 2*item_level)),
			"increased_crit_rating": str(randi_range(item_level, 2*item_level)),
			"increased_quickness": str(randi_range(item_level, 2*item_level)),
			
			"increased_sword_mastery": str(randi_range(item_level, 2*item_level)),
			"increased_axe_mastery": str(randi_range(item_level, 2*item_level)),
			"increased_stabbing_mastery": str(randi_range(item_level, 2*item_level)),
			"increased_mace_mastery": str(randi_range(item_level, 2*item_level)),
			"increased_flagellation_mastery": str(randi_range(item_level, 2*item_level)),
			"increased_shield_mastery": str(randi_range(item_level, 2*item_level)),
			
			"thorns": str(randi_range(1, item_level)),
			"to_gold_income": str(randi_range(1, item_level/1.5))
		}
		
	### IDEAS ###
	# #% weapon hardening (reduces durability taken from parry)
	# #% attributes
	# 		- 
	# -#% global attribute requirements
	# 			# extra gold per round
	# 			# thorns damage
	# #% physical damage reduction
	# damage per # attribute
	# to life per # strength
	# 			drains X dmg per sec, inc dmg % / attack speed %

	return possible_bonuses
	
