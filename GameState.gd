extends Node
class_name GameState

var equipment_script# = load("res://Equipment.gd")
var equipment_instance
var equipment_data

var buy_ready = true

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
signal countdown_updated(time_left: int)
signal card_stock_changed(new_all_cards_stock: Dictionary)
#signal card_stock_initialize(new_attr_cards_stock: Dictionary)
signal send_gladiator_data_to_peer_signal(peer_id: int, all_gladiators: Dictionary)
signal card_buy_result(peer_id: int, success: bool, _parent)
signal broadcast_log_signal(message: String)
signal send_player_colors_to_peer_signal(id: int, colors: Dictionary)
signal send_equipment_dict_to_peer_signal(id: int, dict: Dictionary)
signal send_gladiator_data_to_peer_card_signal(id: int)#, dict: Dictionary)
signal broadcast_players_ready_signal(players_ready: int)
signal killed_by_server_signal(id: int)
signal reroll_cards_new_round_signal(active_players)
signal gladiator_attribute_changed(new_all_gladiators: Dictionary)

signal update_equipment_card_signal(id, item_dict_to_craft, slot, item)
signal add_item_to_inventory_signal(id, item_dict, slot_name)
signal remove_item_from_inventory_signal(id, item_dict, slot_name)
signal add_item_to_equipment_signal(peer_id, item_dict, category)
signal remove_item_from_equipment_signal(peer_id, item_dict, category)

signal update_hud_data_to_peer_signal(id, data)

signal signal_update_gold_req_in_shop_for_peer(id, gold)

signal refresh_inventory_ui_signal(id, inventory_dict)

var craft_cards_stock
var attr_cards_stock
var all_cards_stock
var regret_cards_stock

var exp_for_level = {"1": 0, "2": 10, "3": 12, "4": 14, "5": 18, "6": 22, "7": 26, "8": 30, "9": 34, "10": 36}

var peer_colors = ["4b726e", "d2c9a5", "b3a555", "ba9158",
				   "79444a",   "c77b58",     "847875",    "927441"]
var player_colors := {}
var _players = []
var players_ready_list = []
var players_ready = 0
var active_players = []

var total_modifier_bonuses = {}
var prev_total_modifier_bonuses = {}

var age_limits = {
	"Troll": {"Adult": 32, "Aged": 64, "Old": 84},
	"Orc": {"Adult": 32, "Aged": 64, "Old": 84},
	"Elf": {"Adult": 48, "Aged": 88, "Old": 108},
	"Human": {"Adult": 40, "Aged": 72, "Old": 92}}

var age_modifiers = {
		"Troll": {
			age_limits["Troll"]["Adult"]: {
				"strength": 1.2,
				"quickness": 0.9,
				"crit_rating": 1.0,
				"avoidance": 1.0,
				"health": 1.15,
				"resilience": 1.05,
				"endurance": 1.1,
			},
			age_limits["Troll"]["Aged"]: {
				"strength": 0.9,
				"quickness": 0.9,
				"crit_rating": 0.9,
				"avoidance": 0.9,
				"health": 0.9,
				"resilience": 0.9,
				"endurance": 0.9,
			},
			age_limits["Troll"]["Old"]: {
				"strength": 0.9,
				"quickness": 0.9,
				"crit_rating": 0.9,
				"avoidance": 0.9,
				"health": 0.9,
				"resilience": 0.9,
				"endurance": 0.9,
			},
		},
		"Orc": {
			age_limits["Orc"]["Adult"]: {
				"strength": 1.1,
				"quickness": 1.1,
				"crit_rating": 1.2,
				"avoidance": 1.05,
				"health": 1.10,
				"resilience": 1.10,
				"endurance": 1.05,
			},
			age_limits["Orc"]["Aged"]: {
				"strength": 0.95,
				"quickness": 0.9,
				"crit_rating": 0.95,
				"avoidance": 0.9,
				"health": 0.95,
				"resilience": 0.95,
				"endurance": 0.9,
			},
			age_limits["Orc"]["Old"]: {
				"strength": 0.9,
				"quickness": 0.9,
				"crit_rating": 0.9,
				"avoidance": 0.9,
				"health": 0.9,
				"resilience": 0.9,
				"endurance": 0.9,
			},
		},
		"Human": {
			age_limits["Human"]["Adult"]: {
				"strength": 1.05,
				"quickness": 1.15,
				"crit_rating": 1.1,
				"avoidance": 1.1,
				"health": 1.05,
				"resilience": 1.10,
				"endurance": 1.15,
			},
			age_limits["Human"]["Aged"]: {
				"strength": 0.95,
				"quickness": 0.9,
				"crit_rating": 0.95,
				"avoidance": 0.9,
				"health": 0.95,
				"resilience": 0.95,
				"endurance": 0.95,
			},
			age_limits["Human"]["Old"]: {
				"strength": 0.9,
				"quickness": 0.9,
				"crit_rating": 0.9,
				"avoidance": 0.9,
				"health": 0.9,
				"resilience": 0.9,
				"endurance": 0.9,
			},
		},
		"Elf": {
			age_limits["Elf"]["Adult"]: {
				"strength": 1.05,
				"quickness": 1.2,
				"crit_rating": 1.1,
				"avoidance": 1.2,
				"health": 1.05,
				"resilience": 1.10,
				"endurance": 1.15,
			},
			age_limits["Elf"]["Aged"]: {
				"strength": 0.95,
				"quickness": 0.95,
				"crit_rating": 0.95,
				"avoidance": 0.95,
				"health": 0.95,
				"resilience": 0.95,
				"endurance": 0.95,
			},
			age_limits["Elf"]["Old"]: {
				"strength": 0.9,
				"quickness": 0.9,
				"crit_rating": 0.9,
				"avoidance": 0.9,
				"health": 0.9,
				"resilience": 0.9,
				"endurance": 0.9,
			},
		},
	}

const RACE_MODIFIERS = {
	"Orc": {
		"strength": 1.25,
		"quickness": 0.8,
		"crit_rating": 1.1,
		"avoidance": 0.7,
		"health": 1.25,
		"resilience": 1.0,
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
		"strength": 0.8,
		"quickness": 1.4,
		"crit_rating": 1.2,
		"avoidance": 1.55,
		"health": 0.9,
		"resilience": 1.0,
		"endurance": 1.35,
		"sword_mastery": 1.25,
		"axe_mastery": 1.1,
		"mace_mastery": 1.05,
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
		"resilience": 1.0,
		"endurance": 1.2,
		"sword_mastery": 1.1,
		"axe_mastery": 1.1,
		"mace_mastery": 1.1,
		"stabbing_mastery": 1.1,
		"flagellation_mastery": 1.1,
		"shield_mastery": 1.0,
		"unarmed_mastery": 1.0
	},
	"Troll": {
		"strength": 1.5,
		"quickness": 0.6,
		"crit_rating": 0.9,
		"avoidance": 0.5,
		"health": 1.5,
		"resilience": 1.0,
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
		"scroll_of_luck": 100,
		"scroll_of_injection": 100
	}
	
	attr_cards_stock = {
		"strength": 100,
		"quickness": 100,
		"crit_rating": 100,
		"avoidance": 100,
		"health": 100,
		"resilience": 1,
		"endurance": 100,
		"sword_mastery": 50,
		"axe_mastery": 50,
		"mace_mastery": 50,
		"stabbing_mastery": 50,
		"flagellation_mastery": 50,
		"shield_mastery": 50
	}
	
	regret_cards_stock = {
		"regret_token1": 25
	}
	var _all_cards_stock = {}  # Create a fresh dictionary

	for key in craft_cards_stock.keys():
		_all_cards_stock[key] = craft_cards_stock[key]
		
	for key in attr_cards_stock.keys():
		_all_cards_stock[key] = attr_cards_stock[key]
		
	for key in regret_cards_stock.keys():
		_all_cards_stock[key] = regret_cards_stock[key]

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
	var g: Dictionary = all_gladiators[id]
	var inventory: Dictionary = g["inventory"]

	for slot_name in inventory.keys():
		var slot_data: Dictionary = inventory[slot_name]

		if slot_data.size() > 0:
			var first_key = slot_data.keys()[0]
			rpc_id(id, "update_equipment_card", id, slot_data, slot_name, first_key)



@rpc("any_peer", "call_local")
func update_gold_req_in_shop_for_peer(id, gold):
	#pretty_print_dict(all_gladiators)
	emit_signal("signal_update_gold_req_in_shop_for_peer", id, gold)

@rpc("any_peer", "call_local")
func grant_exp_for_peer(id: int, amount: int, cost: int):
	var g: Dictionary = all_gladiators[id]   # cache gladiator
	var gold: int = g["gold"]
	var exp: int = g["exp"]
	var level: int = int(g["level"])         # store as int for faster math

	if gold < cost:
		return

	# Apply cost and exp gain
	gold -= cost
	exp += amount

	# Level-up loop
	while true:
		var next_level := str(level + 1)

		if not exp_for_level.has(next_level):
			break  # max level reached

		var required_exp: int = exp_for_level[next_level]

		if exp >= required_exp:
			exp -= required_exp
			level += 1
		else:
			break

	# Write back updated values
	g["gold"] = gold
	g["exp"] = exp
	g["level"] = str(level)
	
	all_gladiators[id] = g

	# RPC updates
	#rpc_id(id, "update_gold_req_in_shop_for_peer", id, gold)
	#rpc_id(id, "send_gladiator_data_to_peer_card", id, g)
	rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators)
	rpc("update_hud_data_to_peer", id, g)

	update_all_equipment_cards(id)

@rpc("any_peer", "call_local")
func update_hud_data_to_peer(id: int, data):
	emit_signal("update_hud_data_to_peer_signal", id, data)
	

@rpc("any_peer", "call_local")
func grant_gold_for_peer(id: int, opponent_id: int, winner: bool):
	# --- Tunable parameters ---
	var WIN_STREAK_STEP := 3
	var WIN_STREAK_CAP := 3
	var LOSS_STREAK_STEP := 2
	var LOSS_STREAK_CAP := 4

	var STREAK_BREAK_BONUS_SAME := 1
	var STREAK_BREAK_BONUS_UPSET := 3

	var INCOME_GOLD_THRESHOLDS := [10, 20, 30, 40, 50]
	var INCOME_GOLD_BONUSES :=    [1,  2,  3,  4,  5]

	# --- Cache gladiator dictionaries ---
	var g: Dictionary = all_gladiators[id]
	var opp: Dictionary = all_gladiators[opponent_id] if opponent_id != -1 else null

	# --- Cache frequently used values ---
	var peer_color = g["color"]
	var peer_name := "[color=%s]%s[/color]" % [peer_color, g["name"]]

	var peer_streak: int = g["streak"]
	var peer_gold: int = g["gold"]

	var total_bonus := 0
	var streak_bonus := 0
	var income_bonus := 0
	var streak_break_bonus := 0
	var win_bonus = 1 if winner else 0
	var base_amount := 3

	# --- CASE: No opponent (walkover win) ---
	if opponent_id == -1:
		# Streak bonus
		if peer_streak > 0:
			streak_bonus = min(peer_streak / WIN_STREAK_STEP, WIN_STREAK_CAP)
		elif peer_streak < 0:
			streak_bonus = min(abs(peer_streak) / LOSS_STREAK_STEP, LOSS_STREAK_CAP)

		# Income bonus
		for i in INCOME_GOLD_THRESHOLDS.size():
			if peer_gold >= INCOME_GOLD_THRESHOLDS[i] and (i == INCOME_GOLD_THRESHOLDS.size() - 1 or peer_gold < INCOME_GOLD_THRESHOLDS[i+1]):
				income_bonus = INCOME_GOLD_BONUSES[i]
				break

		# Gear bonus
		var gear_mods = g.get("total_modifier_bonuses", {})
		var gold_from_gear = gear_mods.get("to_gold_income", 0)

		total_bonus = base_amount + win_bonus + income_bonus + streak_bonus + gold_from_gear

		g["income_last_round"] = {
			"base": base_amount,
			"win": win_bonus,
			"income": income_bonus,
			"streak": streak_bonus,
			"streak_break": 0,
			"gear": gold_from_gear
		}

		g["gold"] += int(total_bonus)
		all_gladiators[id] = g
		rpc_id(id, "update_gold_req_in_shop_for_peer", id, g["gold"])
		#rpc("send_gladiator_data_to_peer", id, all_gladiators)
		rpc_id(id, "update_hud_data_to_peer", id, g)

		add_to_log(id, peer_name + " gets walkover win!")
		return

	# --- CASE: Normal duel ---
	var opponent_color = opp["color"]
	var opponent_name := "[color=%s]%s[/color]" % [opponent_color, opp["name"]]

	var win_streak_quotes := [
		peer_name + " is on a killing spree!",
		peer_name + " is unstoppable!",
		peer_name + " is a Legend!"
	]

	var loss_streak_quotes := [
		peer_name + " falls behind...",
		peer_name + " endures...",
		peer_name + " suffers...",
		peer_name + " bleeds..."
	]

	var break_streak_quotes := [
		peer_name + " stops " + opponent_name + "'s killing spree!",
		peer_name + " breaks " + opponent_name + "'s dominance!",
		peer_name + " butchers " + opponent_name + "'s Legend!"
	]

	# --- Streak bonus ---
	if peer_streak > 0:
		streak_bonus = min(peer_streak / WIN_STREAK_STEP, WIN_STREAK_CAP)
	elif peer_streak < 0:
		streak_bonus = min(abs(peer_streak) / LOSS_STREAK_STEP, LOSS_STREAK_CAP)

	# (Quotes disabled in your original code)

	# --- Opponent streak break bonus ---
	var opponent_streak: int = opp["streak"]

	if opponent_streak > WIN_STREAK_STEP and winner:
		streak_break_bonus = STREAK_BREAK_BONUS_SAME if peer_streak > 0 else STREAK_BREAK_BONUS_UPSET


	# (Quotes disabled in your original code)

	# --- Income bonus ---
	for i in INCOME_GOLD_THRESHOLDS.size():
		if peer_gold >= INCOME_GOLD_THRESHOLDS[i] and (i == INCOME_GOLD_THRESHOLDS.size() - 1 or peer_gold < INCOME_GOLD_THRESHOLDS[i+1]):
			income_bonus = INCOME_GOLD_BONUSES[i]
			break

	# --- Gear bonus ---
	var gear_mods = g.get("total_modifier_bonuses", {})
	var gold_from_gear = gear_mods.get("to_gold_income", 0)

	# --- Final gold ---
	total_bonus = base_amount + win_bonus + income_bonus + streak_bonus + streak_break_bonus + gold_from_gear

	g["income_last_round"] = {
		"base": base_amount,
		"win": win_bonus,
		"income": income_bonus,
		"streak": streak_bonus,
		"streak_break": streak_break_bonus,
		"gear": gold_from_gear
	}

	g["gold"] += int(total_bonus)
	all_gladiators[id] = g

	rpc_id(id, "update_gold_req_in_shop_for_peer", id, g["gold"])
	#rpc("send_gladiator_data_to_peer", id, all_gladiators)
	rpc_id(id, "update_hud_data_to_peer", id, g)



@rpc("any_peer", "call_local")
func modify_streak(id: int, win: bool):
	var g = all_gladiators[id]
	var current_streak = g["streak"]
	if current_streak >= 0 and win: # continue win streak
		g["streak"] += 1
	elif current_streak <= 0 and !win: # continue loss streak
		g["streak"] -= 1
	elif current_streak <= 0 and win: # broke loss streak
		g["streak"] = 1
	elif current_streak >= 0 and !win: # broke win streak
		g["streak"] = -1
	
	all_gladiators[id] = g
	#rpc("send_gladiator_data_to_peer", id, all_gladiators)
	rpc_id(id, "update_hud_data_to_peer", id, g)
	
	
@rpc("authority", "call_local")
func send_player_colors_to_peer(id: int, _player_colors) -> void:
	emit_signal("send_player_colors_to_peer_signal", id, _player_colors)

@rpc("any_peer", "call_local")
func get_player_colors(id: int) -> void:
	rpc_id(id, "send_player_colors_to_peer", id, player_colors)
	
func assign_peer_colors(players): 
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
			#rpc_id(id, "send_equipment_dict_to_peer", id, result)
			return result
	#return {}  # Return empty if not found

@rpc("any_peer", "call_local")
func unequip_item(peer_id, equipment, equipment_button_parent_name, category):
	var g: Dictionary = all_gladiators[peer_id]              # cache gladiator
	var inventory: Dictionary = g["inventory"]              # cache inventory
	var item_dict: Dictionary = g[category]                 # cache category dict

	prev_total_modifier_bonuses[peer_id] = total_modifier_bonuses[peer_id]

	var item_data: Dictionary = item_dict[equipment]
	var hands: int = item_data.get("hands", -1)
	var item: String = equipment_button_parent_name.replace("Slot", "").to_lower()

	var modifier_attributes: Dictionary = item_data["modifiers"].get("attributes", {})
	var modifier_bonuses: Dictionary = item_data["modifiers"].get("bonuses", {})
	var weight: int = item_data.get("weight", 0)
	
	
	total_modifier_bonuses[peer_id] = collect_gladiator_bonuses(peer_id)
	var _total_str_after_unequip = total_str_after_unequip(peer_id, total_modifier_bonuses[peer_id].get("increased_strength", 0), item_data)
	var str_req_from_gear = collect_str_req_from_gear(peer_id) # [req, item]
	
	if _total_str_after_unequip < str_req_from_gear[0]:
		add_to_peer_log(peer_id, "[INFO] Cannot unequip because " + format_name(str_req_from_gear[1]) + " requires " + str(str_req_from_gear[0]) + " points")
	
		return

	# --- Find first empty inventory slot ---
	for slot_name in inventory.keys():
		var slot_data: Dictionary = inventory[slot_name]

		if slot_data.size() == 0:
			# Place item into inventory
			inventory[slot_name] = item_dict

			# Handle weapon slot resets
			if hands == 2:
				g["weapon1"] = get_equipment_by_name(peer_id, "unarmed")
				g["weapon2"] = get_equipment_by_name(peer_id, "unarmed")
			elif item == "weapon1" or item == "weapon2":
				g[item] = get_equipment_by_name(peer_id, "unarmed")
			else:
				g[item] = {}

			# Remove attribute bonuses
			remove_attribute_bonuses(peer_id)

			if modifier_attributes.size() > 0:
				var attrs: Dictionary = g["attributes"]
				for attribute in modifier_attributes:
					attrs[attribute] -= modifier_attributes[attribute]

			# Recalculate bonuses
			total_modifier_bonuses[peer_id] = collect_gladiator_bonuses(peer_id)
			g["total_modifier_bonuses"] = total_modifier_bonuses[peer_id]

			add_attribute_bonuses(peer_id)

			# Weight
			if weight != 0:
				g["weight"] -= weight

			# RPC updates
			rpc_id(peer_id, "add_item_to_inventory", peer_id, item_dict, slot_name)
			rpc_id(peer_id, "remove_item_from_equipment", peer_id, item_dict, category)

			# Upgrades
			g["inventory"] = check_for_item_upgrades(peer_id, inventory)

			all_gladiators[peer_id] = g
			
			rpc("send_gladiator_data_to_peer", peer_id, all_gladiators)
			#rpc_id(peer_id, "send_gladiator_data_to_peer_card", peer_id)#, g)

			update_all_equipment_cards(peer_id)
			return

	add_to_peer_log(peer_id, "[INFO] No inventory space!")


func check_for_item_upgrades(id: int, slots: Dictionary) -> Dictionary:
	var g: Dictionary = all_gladiators[id]
	var inventory: Dictionary = g["inventory"]
	var visual_updates: Array = []

	while true:
		var upgrade_found := false
		var counts: Dictionary = {}
		var slot_map: Dictionary = {}

		# --- 1. Count items and track their slots ---
		for slot_name in inventory.keys():
			var slot_data: Dictionary = inventory[slot_name]
			if slot_data.is_empty():
				continue

			var item_name: String = slot_data.keys()[0]
			var item: Dictionary = slot_data[item_name]

			counts[item_name] = counts.get(item_name, 0) + 1

			if not slot_map.has(item_name):
				slot_map[item_name] = []
			slot_map[item_name].append(slot_name)

		# --- 2. Find items that appear 3 times ---
		for item_name in counts.keys():
			if counts[item_name] < 3:
				continue

			var sample_slot: String = slot_map[item_name][0]
			var item: Dictionary = inventory[sample_slot][item_name]

			var category: String = item["category"]
			var class_type: String = item["class"]
			var tier: int = item["tier"]

			# --- 3. Find next tier in equipment_data ---
			var next_item_name: String = ""
			var category_dict: Dictionary = equipment_data[category]

			for eq_name in category_dict.keys():
				var eq: Dictionary = category_dict[eq_name]
				if eq["class"] == class_type and eq["tier"] == tier + 1:
					next_item_name = eq_name
					break

			if next_item_name == "":
				continue  # no upgrade exists

			# --- 4. Remove the three items ---
			var remove_slots: Array = slot_map[item_name].slice(0, 3)
			for s in remove_slots:
				inventory[s].clear()
				g["inventory"][s].clear()

				visual_updates.append({
					"type": "remove",
					"slot": s
				})

			# --- 5. Place upgraded item in first empty slot ---
			var upgraded_item: Dictionary = category_dict[next_item_name].duplicate(true)

			for slot_name in inventory.keys():
				var slot_data: Dictionary = inventory[slot_name]
				if slot_data.is_empty():
					upgraded_item["inventory_slot"] = slot_name

					inventory[slot_name][next_item_name] = upgraded_item
					g["inventory"][slot_name] = inventory[slot_name]

					visual_updates.append({
						"type": "add",
						"slot": slot_name,
						"item_name": next_item_name,
						"item": upgraded_item
					})

					upgrade_found = true
					break

			break  # break out of item_name loop

		if upgrade_found:
			continue  # restart while-loop with fresh counts

		break  # no upgrades found → exit loop

	# --- 6. Apply visual updates AFTER all upgrades are done ---
	rpc_id(id, "refresh_inventory_ui", id, inventory)
	return inventory



@rpc("any_peer", "call_local")
func refresh_inventory_ui(id, inventory_dict):
	emit_signal("refresh_inventory_ui_signal", id, inventory_dict)
	buy_ready = true



@rpc("any_peer", "call_local")
func equip_item(peer_id, equipment, selected_slot):
	var g: Dictionary = all_gladiators[peer_id]                     # cache gladiator
	var inventory: Dictionary = g["inventory"]                     # cache inventory
	var item_dict: Dictionary = inventory[selected_slot]           # cached item slot
	var item_data: Dictionary = item_dict[equipment]               # cached item data

	var type: String = item_data["type"]
	var category: String = item_data["category"]
	var str_req: int = item_data.get("str_req", 0)
	var lvl_req: int = item_data.get("level", 0)
	var modifier_attributes: Dictionary = item_data["modifiers"].get("attributes", {})
	var modifier_bonuses: Dictionary = item_data["modifiers"].get("bonuses", {})
	var weight: int = item_data.get("weight", 0)

	var equip_success := false

	# Normalize weapon categories
	if category in ["sword", "axe", "flagellation", "stabbing", "mace"]:
		category = "weapon"

	# --- Requirements ---
	var level_ok := int(g["level"]) >= lvl_req
	var strength_ok = g["attributes"]["strength"] >= str_req

	if not level_ok:
		add_to_peer_log(peer_id, "[INFO] Item requires level " + str(lvl_req) + ", you are level " + str(g["level"]))
		return

	if not strength_ok:
		add_to_peer_log(peer_id, "[INFO] Need " + str(str_req) + " strength, you have " + str(g["attributes"]["strength"]) + "!")
		return

	# --- EQUIP LOGIC ---
	if type == "weapon" and category != "shield":
		var hands: int = item_data.get("hands", 1)
		var skill_req = item_data.get("skill_req", "")  # unused but cached

		var w1_name: String = g["weapon1"].keys()[0]
		var w2_name: String = g["weapon2"].keys()[0]

		if hands == 2:
			if w1_name == "unarmed" and w2_name == "unarmed":
				g["weapon1"] = item_dict
				g["weapon2"] = item_dict
				category = "weapon1"
				equip_success = true
			else:
				add_to_peer_log(peer_id, "[INFO] Need both hands free for two‑handed weapon!")
				return

		elif hands == 1:
			if w1_name == "unarmed":
				g["weapon1"] = item_dict
				category = "weapon1"
				equip_success = true
			elif w2_name == "unarmed":
				g["weapon2"] = item_dict
				category = "weapon2"
				equip_success = true
			else:
				add_to_peer_log(peer_id, "[INFO] Cannot equip more weapons!")
				return

	elif category == "shield":
		var w2_name: String = g["weapon2"].keys()[0]
		if w2_name == "unarmed":
			g["weapon2"] = item_dict
			category = "weapon2"
			equip_success = true
		else:
			add_to_peer_log(peer_id, "[INFO] Shield can only be worn in off‑hand!")
			return

	else:
		# Armor categories
		var slot_name := category
		if category == "ring":
			if g["ring1"].is_empty():
				g["ring1"] = item_dict
				category = "ring1"
				equip_success = true
			elif g["ring2"].is_empty():
				g["ring2"] = item_dict
				category = "ring2"
				equip_success = true
			else:
				add_to_peer_log(peer_id, "[INFO] Cannot equip more rings!")
				return
		else:
			if g[slot_name].is_empty():
				g[slot_name] = item_dict
				equip_success = true
			else:
				add_to_peer_log(peer_id, "[INFO] Already wearing " + category)
				return

	# --- APPLY EQUIP EFFECTS ---
	if equip_success:
		inventory[selected_slot] = {}  # clear inventory slot

		rpc_id(peer_id, "remove_item_from_inventory", peer_id, item_dict, selected_slot)
		rpc_id(peer_id, "add_item_to_equipment", peer_id, item_dict, category)

		# Update bonuses
		prev_total_modifier_bonuses[peer_id] = g.get("total_modifier_bonuses", {})
		total_modifier_bonuses[peer_id] = collect_gladiator_bonuses(peer_id)
		g["total_modifier_bonuses"] = total_modifier_bonuses[peer_id]

		remove_attribute_bonuses(peer_id)

		if modifier_attributes.size() > 0:
			var attrs : Dictionary = g["attributes"]
			for attribute in modifier_attributes:
				attrs[attribute] += modifier_attributes[attribute]

		add_attribute_bonuses(peer_id)

		if weight != 0:
			g["weight"] += weight

		all_gladiators[peer_id] = g
		
		
		rpc("send_gladiator_data_to_peer", peer_id, all_gladiators)
		#rpc_id(peer_id, "send_gladiator_data_to_peer_card", peer_id)#, g)

		update_all_equipment_cards(peer_id)



func get_age_stage(_race: String, _round: int) -> String:
	var limits = age_limits[_race]

	for stage in limits.keys():
		if limits[stage] == _round:
			return stage

	return ""  # no match


func add_age_modifiers(current_round):
	var all_ids = all_gladiators.keys()

	#print("round: " + str(current_round))

	for id in all_ids:
		

		var race = all_gladiators[id]["race"]
		var attributes = all_gladiators[id]["attributes"]

		# Check if this race has age modifiers for this round
		if age_modifiers.has(race) and age_modifiers[race].has(current_round):
			var age = get_age_stage(race, current_round)
			all_gladiators[id]["age"] = age
			
			remove_attribute_bonuses(id)
			var modifiers = age_modifiers[race][current_round]

			# Apply each modifier to the gladiator's attributes
			for attr in attributes.keys():
				if modifiers.has(attr):
					attributes[attr] *= modifiers[attr]

			all_gladiators[id]["attributes"] = attributes.duplicate()
			add_attribute_bonuses(id)

func remove_attribute_bonuses(peer_id):
	var all_attributes = all_gladiators[peer_id]["attributes"].keys()
	for attr in all_attributes:
		var increased_string = "increased_" + attr
		all_gladiators[peer_id]["attributes"][attr] = all_gladiators[peer_id]["attributes"].get(attr, 0)/(1+float(prev_total_modifier_bonuses[peer_id].get(increased_string, 0))/100)

func add_attribute_bonuses(peer_id):
	var all_attributes = all_gladiators[peer_id]["attributes"].keys()
	for attr in all_attributes:
		var increased_string = "increased_" + attr
		all_gladiators[peer_id]["attributes"][attr] = all_gladiators[peer_id]["attributes"].get(attr, 0)*(1+float(all_gladiators[peer_id]["total_modifier_bonuses"].get(increased_string, 0))/100)

func format_name(raw_name: String) -> String:
	var parts = raw_name.split("_")
	var joined = ""
	for i in parts.size():
		joined += parts[i]
		if i < parts.size() - 1:
			joined += " "
	return joined.capitalize()

@rpc("any_peer", "call_local")
func collect_str_req_from_gear(id):
	var max_req = 0
	var which_item
	var str
	var result = [0, ""]
	
	var merged := {}
	var excluded_keys := ["inventory", "total_modifier_bonuses"]
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

			# Collect str req
			if item.has("str_req"):
				str = item["str_req"]
				
				if str > max_req:
					max_req = str
					which_item = item_key
					result = [max_req, which_item]
				
	return result
	
@rpc("any_peer", "call_local")
func total_str_after_unequip(id, bonus_gear, item_dict):
	#print(item_dict)
	remove_attribute_bonuses(id)
	var total_divided_by_bonus = all_gladiators[id]["attributes"]["strength"]
	add_attribute_bonuses(id)
	var total_after_unequip = (total_divided_by_bonus - item_dict["modifiers"]["attributes"].get("strength", 0))*(1 + (bonus_gear - int(item_dict["modifiers"]["bonuses"].get("increased_strength", 0)))/100.0)
	#print("total_after_unequip: " + str(total_after_unequip))
	return total_after_unequip

@rpc("any_peer", "call_local")
func collect_gladiator_total_attributes_from_gear(id, bonuses, attributes):
	var total_attributes = {}
	for attr in attributes:
			for key in bonuses:
				if key.contains(attr):
					total_attributes[attr] = + attributes[attr] * (1.0 + bonuses[key]/100.0)
	
	return total_attributes

@rpc("any_peer", "call_local")
func collect_gladiator_flat_attributes_from_equipment(id): 
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
			if item.has("modifiers") and item["modifiers"].has("attributes"):
				var attributes = item["modifiers"]["attributes"]
				for attribute_key in attributes.keys():
					var value = attributes[attribute_key]
					
					if merged.has(attribute_key):
						if value is Array:
							for i in range(len(value)):#var numeric_value = float(value[i]) if typeof(value[i]) in [TYPE_STRING, TYPE_INT, TYPE_FLOAT] and String(value[i]).is_valid_float() else 0
								merged[attribute_key][i] += float(value[i])
						else:
							merged[attribute_key] += float(value)
					else:
						if value is Array: merged[attribute_key] = value
						else: merged[attribute_key] = float(value)
	return merged

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
					
					if bonus_key == "blood_rage":
						print("pause")
					
					if merged.has(bonus_key):
						if value is Array:
							for i in range(len(value)):#var numeric_value = float(value[i]) if typeof(value[i]) in [TYPE_STRING, TYPE_INT, TYPE_FLOAT] and String(value[i]).is_valid_float() else 0
								merged[bonus_key][i] += float(value[i])
						else:
							merged[bonus_key] += float(value)
					else:
						if value is Array: merged[bonus_key] = value
						else: merged[bonus_key] = float(value)
	return merged

@rpc("any_peer", "call_local")
func peer_attack_type(id, type): 
	all_gladiators[id]["attack_type"] = type
	rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators)
	
@rpc("any_peer", "call_local")
func peer_stance(id, stance): 
	all_gladiators[id]["stance"] = stance
	rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators)

@rpc("any_peer", "call_local")
func peer_concede(id, threshold): 
	all_gladiators[id]["concede"] = threshold
	rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators)
	
@rpc("any_peer", "call_local")
func send_gladiator_data_to_peer_card(id: int):#, _gladiator_data) -> void:
	emit_signal("send_gladiator_data_to_peer_card_signal", id)#, _gladiator_data)

@rpc("any_peer", "call_local")
func refresh_gladiator_data_card(id: int) -> void:
	#print("asdasdasd: " + str(all_gladiators[id]))
	rpc_id(id, "send_gladiator_data_to_peer_card", id, all_gladiators[id])
	
@rpc("any_peer", "call_local")
func send_gladiator_data_to_peer(id: int, _all_gladiators) -> void:
	emit_signal("send_gladiator_data_to_peer_signal", id, _all_gladiators)

@rpc("any_peer", "call_local")
func refresh_gladiator_data(id: int) -> void:
	#print("asdasdasd: " + str(all_gladiators[id]))
	rpc("send_gladiator_data_to_peer", id, all_gladiators)

@rpc("authority", "call_local")
func notify_card_buy_result(id: int, success: bool, _parent) -> void:
	emit_signal("card_buy_result", id, success, _parent)


@rpc("any_peer", "call_local")
func update_equipment_card(id, item_dict_to_craft, slot, item):
	#print("update_equipment_card")
	#print(item)
	emit_signal("update_equipment_card_signal", id, item_dict_to_craft, slot, item)#, all_gladiators)
	
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
func buy_equipment_card(id: int, equipment: String, cost: int, parent_name = ""):
	buy_ready = false
	var success := false

	# --- Cache gladiator + inventory ---
	var g: Dictionary = all_gladiators[id]
	var inventory: Dictionary = g["inventory"]

	# --- Check stock ---
	if all_cards_stock[equipment] < 1:
		add_to_peer_log(id, "No " + equipment + " cards left in stock!")
		rpc_id(id, "notify_card_buy_result", id, success, parent_name)
		rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators)
		return

	# --- Check gold ---
	if g["gold"] < cost:
		rpc_id(id, "notify_card_buy_result", id, success, parent_name)
		return  # Not enough gold 
	
	# --- Create item ---
	var item_dict: Dictionary = get_equipment_by_name(id, equipment).duplicate(true)

	# --- Find empty inventory slot ---
	for slot_name in inventory.keys():
		var slot_data: Dictionary = inventory[slot_name]

		if slot_data.is_empty():
			# Place item
			item_dict[equipment]["inventory_slot"] = slot_name
			inventory[slot_name] = item_dict

			# Pay gold
			g["gold"] -= cost

			# Update stock
			adjust_card_stock(equipment, "remove")

			success = true

			# RPC updates
			rpc_id(id, "update_gold_req_in_shop_for_peer", id, g["gold"])
			rpc_id(id, "add_item_to_inventory", id, item_dict, slot_name)

			# Check upgrades
			g["inventory"] = check_for_item_upgrades(id, inventory)
			all_gladiators[id] = g
			
			rpc_id(id, "notify_card_buy_result", id, success, parent_name)
			rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators)
			#update_all_equipment_cards(id)
			return

	# --- No space ---
	success = false
	rpc_id(id, "notify_card_buy_result", id, success, parent_name)
	add_to_peer_log(id, "[INFO] No inventory space!")


@rpc("any_peer", "call_local")
func sell_from_equipment(peer_id: int, equipment: String, equipment_button_parent_name, category):
	var g: Dictionary = all_gladiators[peer_id]                     # cache gladiator
	var item_dict: Dictionary = g[category]                        # cached equipped item
	var item_data: Dictionary = item_dict[equipment]               # cached item data

	var price: int = item_data["price"]
	var hands: int = item_data.get("hands", -1)
	var item_slot: String = equipment_button_parent_name.replace("Slot", "").to_lower()

	var modifier_attributes: Dictionary = item_data["modifiers"].get("attributes", {})
	var modifier_bonuses: Dictionary = item_data["modifiers"].get("bonuses", {})
	var weight: int = item_data.get("weight", 0)
	
	total_modifier_bonuses[peer_id] = collect_gladiator_bonuses(peer_id)
	var _total_str_after_unequip = total_str_after_unequip(peer_id, total_modifier_bonuses[peer_id].get("increased_strength", 0), item_data)
	var str_req_from_gear = collect_str_req_from_gear(peer_id) # [req, item]
	
	if _total_str_after_unequip < str_req_from_gear[0]:
		add_to_peer_log(peer_id, "[INFO] Cannot unequip because " + format_name(str_req_from_gear[1]) + " requires " + str(str_req_from_gear[0]) + " points")
	
		return

	# --- Remove item from equipment slots ---
	if hands == 2:
		g["weapon1"] = get_equipment_by_name(peer_id, "unarmed")
		g["weapon2"] = get_equipment_by_name(peer_id, "unarmed")
	elif item_slot == "weapon1" or item_slot == "weapon2":
		g[item_slot] = get_equipment_by_name(peer_id, "unarmed")
	else:
		g[item_slot] = {}

	# --- Remove attribute modifiers ---
	if modifier_attributes.size() > 0:
		var attrs: Dictionary = g["attributes"]
		for attribute in modifier_attributes:
			attrs[attribute] -= modifier_attributes[attribute]

	# --- TODO: Remove modifier bonuses ---
	if modifier_bonuses.size() > 0:
		1  # placeholder (same as your original)

	# --- Remove weight ---
	if weight != 0:
		g["weight"] -= weight

	# --- Add gold (half price) ---
	g["gold"] += int(price / 2)
	all_gladiators[peer_id] = g

	# --- RPC updates ---
	rpc_id(peer_id, "update_gold_req_in_shop_for_peer", peer_id, g["gold"])
	adjust_card_stock(equipment, "add")
	rpc_id(peer_id, "remove_item_from_equipment", peer_id, item_dict, category)
	rpc("send_gladiator_data_to_peer", peer_id, all_gladiators)


	#print("Item not found in equipment panel!")
					
@rpc("any_peer", "call_local")
func sell_from_inventory(id: int, equipment: String, selected_slot): 
	var g = all_gladiators[id]
	if g["inventory"][selected_slot] == {}:
		add_to_peer_log(id, "[INFO] Item not found in inventory!")
		return
	
	var item_dict = get_equipment_by_name(id, equipment)
	var price = item_dict[equipment]["price"]
	
	g["inventory"][selected_slot] = {}  # Clear slot
	g["gold"] += int(price/2)
	all_gladiators[id] = g
	
	rpc_id(id, "update_gold_req_in_shop_for_peer", id, g["gold"])
	rpc_id(id, "remove_item_from_inventory", id, item_dict, selected_slot)
	adjust_card_stock(equipment, "add")  # Restore stock
	rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators)
	
	
	
@rpc("any_peer", "call_local")
func buy_craft_card(id, craft_name, cost, parent_name = ""):
	var success := false
	var g = all_gladiators[id]
	
	if all_cards_stock[craft_name] >= 1:
		if g["gold"] >= cost:
			g["crafting_mats"][craft_name] += 1
			g["gold"] -= cost
			all_gladiators[id] = g
			adjust_card_stock(craft_name, "remove")
			success = true
			rpc_id(id, "notify_card_buy_result", id, success, parent_name)
			rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators)
			rpc_id(id, "update_gold_req_in_shop_for_peer", id, g["gold"])
		else: return#add_to_peer_log(id, "[INFO] Not enough gold!")
	else: 
		rpc_id(id, "notify_card_buy_result", id, success, parent_name)
		add_to_peer_log(id, "[INFO] No " + craft_name + " cards left in stock!")
	
@rpc("any_peer", "call_local")
func buy_reroll(id):
	var cost = 2
	
	if all_gladiators[id]["gold"] >= cost:
		all_gladiators[id]["gold"] -= cost
		#rpc_id(id, "update_gold_req_in_shop_for_peer", id, all_gladiators[id]["gold"])
		#rpc_id(id, "send_gladiator_data_to_peer_card", id)#, all_gladiators[id])
		rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators)
	else:
		return#add_to_peer_log(id, "[INFO] Not enough gold!")
	
@rpc("any_peer", "call_local")
func buy_regret_token_card(id: int, amount: int, attribute: String, cost: int, modify_stock = true, parent_name = ""):
	var success := false
	if all_cards_stock[attribute] >= 1:
		if all_gladiators[id]["gold"] >= cost:
			
			if modify_stock: 
				adjust_card_stock(attribute, "remove")
			success = true
			all_gladiators[id]["gold"] -= cost
			all_gladiators[id]["regret_points"] += amount
			rpc_id(id, "notify_card_buy_result", id, success, parent_name)
			rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators)
			
	else: 
		add_to_peer_log(id, "[INFO] No " + attribute + " cards left in stock!")
		rpc_id(id, "notify_card_buy_result", id, success, parent_name)
	
@rpc("any_peer", "call_local")
func request_points(id, amount):
	all_gladiators[id]["points"] += amount
	rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators)
	
@rpc("any_peer", "call_local")
func buy_attribute_card(id: int, amount: int, attribute: String, cost: int, modify_stock := true, parent_name := ""):
	var g: Dictionary = all_gladiators[id]                     # cache gladiator
	var attrs: Dictionary = g["attributes"]                    # cache attributes
	var race: String = g["race"]                               # cache race
	var gold: int = g["gold"]                                  # cache gold

	var success := false

	# --- Stock check ---
	if all_cards_stock[attribute] < 1:
		add_to_peer_log(id, "[INFO] No " + attribute + " cards left in stock!")
		rpc_id(id, "notify_card_buy_result", id, success, parent_name)
		return

	# --- Gold check ---
	if gold < cost:
		rpc_id(id, "notify_card_buy_result", id, success, parent_name)
		return

	# --- Calculate bonuses ---
	total_modifier_bonuses[id] = collect_gladiator_bonuses(id)
	var total_attributes_from_eq_flat = collect_gladiator_flat_attributes_from_equipment(id)
	var total_attributes_from_gear_combined = collect_gladiator_total_attributes_from_gear(id, total_modifier_bonuses[id], total_attributes_from_eq_flat)
	#print("\ntotal attributes: \n" + str(total_attributes_from_gear_combined))
	
	
	var key := "increased_" + attribute
	var bonus_percent := float(total_modifier_bonuses[id].get(key, 0))

	var race_mult = RACE_MODIFIERS[race][attribute]
	var amount_after_bonuses = float(amount) * race_mult * (1.0 + bonus_percent / 100.0)

	# --- Prevent negative attribute dropping below 1 ---
	if amount_after_bonuses < 0:
		if attrs[attribute] + amount_after_bonuses < total_attributes_from_gear_combined.get(attribute, 0):
			add_to_peer_log(id, "[INFO] No points placed in " + format_name(attribute))
			#rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators)
			return

		var str_req_from_gear = collect_str_req_from_gear(id) # [req, item]
		
		if attrs[attribute] + amount_after_bonuses < str_req_from_gear[0]:
			add_to_peer_log(id, "[INFO] Cannot regret " + format_name(attribute) + " because " + format_name(str_req_from_gear[1]) + " requires " + str(str_req_from_gear[0]) + " points")
			#rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators)
			return

	# --- Apply attribute change ---
	attrs[attribute] += amount_after_bonuses
	g["gold"] = gold - cost

	# --- Stock modification ---
	if modify_stock:
		adjust_card_stock(attribute, "remove")

	success = true

	# --- Regret / points logic ---
	if amount < 0:
		g["regret_points"] += amount
		g["points"] -= amount
	else:
		if not modify_stock:
			g["points"] -= amount

	all_gladiators[id] = g
	# --- RPC updates ---
	#rpc_id(id, "update_gold_req_in_shop_for_peer", id, g["gold"])
	emit_signal("gladiator_attribute_changed", all_gladiators)
	rpc_id(id, "notify_card_buy_result", id, success, parent_name)
	rpc_id(id, "send_gladiator_data_to_peer", id, all_gladiators)
	#rpc_id(id, "send_gladiator_data_to_peer_card", id)#, g)

	update_all_equipment_cards(id)

		
		
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
		var hex_color = color#color.to_html()
		var formatted = "[color=%s]%s[/color] was defeated and lost [color=%s]%s life [/color]" % [hex_color, glad_name, Color.RED.to_html(), str(life_lost)]
		
		add_to_log(get_multiplayer_authority(), formatted)
		all_gladiators[id]["player_life"] -= life_lost
		var new_life = all_gladiators[id]["player_life"]
		emit_signal("gladiator_life_changed", id, new_life)

func submit_gladiator(data: Dictionary):
	gladiator_data = data
	#print("Submiting gladiator for peer: %d" % [multiplayer.get_unique_id()])
	if multiplayer.get_unique_id() == 1:
		_store_gladiator(multiplayer.get_unique_id(), data)
	else:
		#print("📨 Sending gladiator to host via rpc_id...")
		_submit_gladiator_remote.rpc_id(1, data)
	

@rpc("any_peer", "call_local")
func _submit_gladiator_remote(data: Dictionary):
	var sender_id = multiplayer.get_remote_sender_id()
	#print("✅ Host received gladiator from peer:", sender_id)
	_store_gladiator(sender_id, data)

func _store_gladiator(peer_id: int, data: Dictionary):
	if player_colors.has(int(peer_id)):
		data["color"] = player_colors[int(peer_id)]
	all_gladiators[peer_id] = data
	
	players_ready += 1
	
	var total_peers = 0
	for i in multiplayer.get_peers():
		if i == 0: continue
		total_peers += 1
		
	if all_gladiators.size() == total_peers+1:# and len(multiplayer.get_peers()) > 1:  # >= NetworkManager_.max_players + 1:
		
		var countdown = 1
		for i in countdown:
			add_to_log(get_multiplayer_authority(), "✅ All players ready, starting game in %s..." % [str(countdown-i)])
			await get_tree().create_timer(1).timeout
		
		_start_game.rpc()
		_start_game()
		
@rpc("authority")
func _start_game():
	#print("All gladiators submitted! Starting game...")
	players_ready_list = []
	get_tree().change_scene_to_file.bind("res://main.tscn").call_deferred()

func erase_all_data():
	all_gladiators = {}

func _assign_authority():
	if multiplayer.is_server():
		#print("🌐 Assigning multiplayer authority on host " + str(multiplayer.get_unique_id()))
		set_multiplayer_authority(multiplayer.get_unique_id())
		
		#print("✅ Authority set to:", get_multiplayer_authority())

func kill_peer(id: int):
	emit_signal("killed_by_server_signal", id)
	
@rpc("any_peer", "call_local")
func reroll_cards_new_round(_active_players: Array):
	active_players = _active_players
	rpc("reroll_cards_new_round_send_signal", active_players)
	
@rpc("authority", "call_local")
func reroll_cards_new_round_send_signal(_active_players: Array):
	#print("Emitting signal reroll_cards_new_round, active_players = " + str(_active_players))
	emit_signal("reroll_cards_new_round_signal", _active_players)


@rpc("any_peer", "call_local")
func use_craft_mat_on_item(id, craft_mat, item, slot):
	var g: Dictionary = all_gladiators[id]
	var inventory: Dictionary = g["inventory"]

	var stock_item: Dictionary = get_equipment_by_name(id, item).duplicate(true)
	var item_dict_to_craft: Dictionary = inventory[slot].duplicate(true)

	var item_data: Dictionary = item_dict_to_craft[item]
	var modifiers: Dictionary = item_data["modifiers"]
	var bonuses: Dictionary = modifiers["bonuses"]
	var attributes: Dictionary = modifiers["attributes"]

	var possible_attributes: Array = attr_cards_stock.keys()
	var roll_interval_max: int = 3 + 2 * item_data["level"]

	# ============================
	# == TOME OF CHAOS (Luck) ==
	# ============================
	if craft_mat == "scroll_of_luck":
		item_dict_to_craft = stock_item.duplicate(true)
		item_data = item_dict_to_craft[item]
		modifiers = item_data["modifiers"]

		# Roll bonuses
		var bonus_pool := [0,0,1,1,2,2,3]
		var bonus_roll = bonus_pool[randi() % bonus_pool.size()]
		var random_bonuses = get_bonuses_rolls(id, slot, bonus_roll)
		modifiers["bonuses"] = random_bonuses.duplicate(true)

		# Roll attributes
		var attr_pool := [1,1,1,1,2,2,3]
		var attr_roll = attr_pool[randi() % attr_pool.size()]
		var random_attributes := get_attribute_rolls(possible_attributes, attr_roll, roll_interval_max)
		modifiers["attributes"] = random_attributes.duplicate(true)

	# ================================
	# == TOME OF INJECTION (Add 1) ==
	# ================================
	elif craft_mat == "scroll_of_injection":
		var existing_attr_count := attributes.keys().size()
		var existing_bonus_count := bonuses.keys().size()

		var random_bonus = get_scroll_of_injection_bonus_roll(id, item, slot)
		var random_attr := get_scroll_of_injection_attribute_roll(attributes, possible_attributes, roll_interval_max)

		if existing_attr_count >= 3 and existing_bonus_count < 3:
			if random_bonus.is_empty():
				add_to_peer_log(id, "[INFO] No more bonuses exist for this item!")
				return
			var bname = random_bonus.keys()[0]
			bonuses[bname] = random_bonus[bname]

		elif existing_attr_count < 3 and existing_bonus_count >= 3:
			var aname = random_attr.keys()[0]
			attributes[aname] = random_attr[aname]

		elif existing_attr_count < 3 and existing_bonus_count < 3:
			var coin := randi() % 2
			if random_bonus.is_empty():
				coin = 1

			if coin == 0:
				var bname = random_bonus.keys()[0]
				bonuses[bname] = random_bonus[bname]
			else:
				var aname = random_attr.keys()[0]
				attributes[aname] = random_attr[aname]

		else:
			add_to_peer_log(id, "[INFO] Item is full on modifiers!")
			return

	# ================================
	# == TOME OF LIBERTY (Remove) ==
	# ================================
	elif craft_mat == "scroll_of_liberty":
		print("")  # Placeholder

	# ================================
	# == APPLY LOCAL BONUS EFFECTS ==
	# ================================
	var bonuses_after = modifiers["bonuses"]

	if bonuses_after.has("local_increased_attack_speed"):
		var base_speed = stock_item[item].get("speed", -1)
		item_data["speed"] = base_speed * (1 + float(bonuses_after["local_increased_attack_speed"]) / 100.0)

	if bonuses_after.has("local_increased_crit_multi"):
		var base_multi = stock_item[item].get("crit_multi", -1)
		item_data["crit_multi"] = base_multi * (1 + float(bonuses_after["local_increased_crit_multi"]) / 100.0)

	if bonuses_after.has("local_increased_crit_chance"):
		var base_chance = stock_item[item].get("crit_chance", -1)
		item_data["crit_chance"] = base_chance * (1 + float(bonuses_after["local_increased_crit_chance"]) / 100.0)

	if bonuses_after.has("local_added_abs"):
		var base_abs = stock_item[item].get("absorb", -1)
		item_data["absorb"] = base_abs + float(bonuses_after["local_added_abs"])

	if bonuses_after.has("local_added_durability") or bonuses_after.has("local_increased_durability"):
		var base_dur = stock_item[item].get("durability", -1)
		var added := float(bonuses_after.get("local_added_durability", 0))
		var inc := float(bonuses_after.get("local_increased_durability", 0))
		item_data["durability"] = (base_dur + added) * (1 + inc / 100.0)

	# ================================
	# == FINALIZE CRAFTING ==
	# ================================
	g["crafting_mats"][craft_mat] -= 1
	inventory[slot] = item_dict_to_craft.duplicate(true)
	all_gladiators[id] = g

	rpc_id(id, "update_equipment_card", id, inventory[slot], slot, item)
	rpc("send_gladiator_data_to_peer", id, all_gladiators)

	
	#pretty_print_dict(all_gladiators[id])





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
	
	var tier = item_dict[item]["tier"]
	var item_level = tier #item_dict[item]["level"]
	
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
				"added_dmg": str(randi_range(1, item_dict[item]["min_dmg"]/2)) + "-" + 
							str(randi_range(item_dict[item]["min_dmg"]/2, item_dict[item]["max_dmg"]/2)),
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
			
			"blood_rage": [randf_range(0.25, 0.75), randi_range(item_level, 3*item_level)],
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
	
func pretty_print_dict(data: Dictionary, indent: int = 0) -> String:
	var out := ""
	var pad := "    ".repeat(indent)

	for key in data.keys():
		var value = data[key]

		if typeof(value) == TYPE_DICTIONARY:
			out += "%s%s:\n" % [pad, str(key)]
			out += pretty_print_dict(value, indent + 1)

		elif typeof(value) == TYPE_ARRAY:
			out += "%s%s: [\n" % [pad, str(key)]
			for item in value:
				if typeof(item) in [TYPE_DICTIONARY, TYPE_ARRAY]:
					out += pretty_print_dict(item, indent + 1)
				else:
					out += "%s    %s,\n" % [pad, str(item)]
			out += "%s]\n" % pad

		else:
			out += "%s%s: %s\n" % [pad, str(key), str(value)]

	#print(out)
	return out

@rpc("any_peer", "call_local")
func set_spawn_point(peer, point):
	all_gladiators[peer]["spawn_point"] = point
	rpc("send_gladiator_data_to_peer", peer, all_gladiators)
	
