# BaseCard.gd
extends Button

@export var equipment_name: String = ""
@export var cost: int
var name_label
var self_name
var parent_name
var item_dict
var all_gladiators
@onready var initial_tooltip_received = 0
#@export var unique_id : String

var mouse_inside_button := false
var added := false
signal button_parent(parent_name: String)
signal mouse_inside_equipment_card_signal(mouse_inside_equipment_card: bool)

func _ready():
	#ProjectSettings.set_setting("gui/timers/tooltip_delay_sec", 5.0)
	#print("_ready()")
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	GameState_.connect("card_buy_result", Callable(self, "_on_card_buy_result"))
	GameState_.connect("send_equipment_dict_to_peer_signal", Callable(self, "_on_send_equipment_dict_to_peer"))
	GameState_.connect("send_gladiator_data_to_peer_card_signal", Callable(self, "_on_send_gladiator_data_to_peer_card_signal"))
	GameState_.connect("update_equipment_card", Callable(self, "_on_equipment_card_updated"))
	
	if multiplayer.is_server():
		GameState_.refresh_gladiator_data_card(multiplayer.get_unique_id())
	else:
		GameState_.rpc_id(1, "refresh_gladiator_data_card", multiplayer.get_unique_id())
	
	parent_name = get_parent().name
	if parent_name == "ShopGridContainer":
		var label_display = format_name(equipment_name)
		name_label = $NameLabel
		name_label.text = label_display+"\n💰" + str(cost)
	#await get_tree().create_timer(0.5).timeout
	
	if multiplayer.is_server():
		GameState_.get_equipment_by_name(multiplayer.get_unique_id(), equipment_name)
	else:
		GameState_.rpc_id(1, "get_equipment_by_name", multiplayer.get_unique_id(), equipment_name)
	
	if item_dict.has(equipment_name):
		var item = item_dict[equipment_name].duplicate(true)
		#print("_on_send_equipment_dict_to_peer " + str(item))
		tooltip_text = get_item_tooltip(item)
		#initial_tooltip_received = 1
	else: 1

func _on_equipment_card_updated(id, updated_item_dict, slot, item):
	if id != multiplayer.get_unique_id(): return
	if "slot" in slot: 
		if parent_name != slot: return
		#print("slot: " + str(slot))
		#print("item: " + str(item))
		#print("parent_name: " + str(parent_name))
		#print("updated_item_dict[item][inventory_slot]: " + str(updated_item_dict[item]["inventory_slot"]))
		tooltip_text = ""
		#if parent_name == slot:
			#if item_dict_after_craft[item]["inventory_slot"] == slot:
			#print(get_node())
			#print("parent_name: " + str(parent_name))
				#print("item_dict before update: " + str(item_dict))
		#print("_on_equipment_card_updated " + str(updated_item_dict[item]))
		tooltip_text = get_item_tooltip(updated_item_dict[item])
				#print(tooltip_text)
	else: 
		if slot.capitalize() in parent_name:
			#print("Updating scene after equipping")
			#print("slot: " + str(slot))
			#print("item: " + str(item))
			#print("parent_name: " + str(parent_name))
			#print("updated_item_dict[item][inventory_slot]: " + str(updated_item_dict[item]["inventory_slot"]))
			tooltip_text = ""
			tooltip_text = get_item_tooltip(updated_item_dict[item])
	



func _on_send_equipment_dict_to_peer(id, _item_dict):
	#print(initial_tooltip_received)
	#print("initial_tooltip_received: " + str(initial_tooltip_received))
	if id != multiplayer.get_unique_id(): return
	if initial_tooltip_received == 1: return
	#if id == multiplayer.get_unique_id():
	item_dict = _item_dict.duplicate(true)
	
'''	
if item_dict.has(equipment_name):
		var item = item_dict[equipment_name].duplicate(true)
		print("_on_send_equipment_dict_to_peer " + str(item))
		tooltip_text = get_item_tooltip(item)
		initial_tooltip_received = 1
	else: 1
'''

			#print("⚠️ Equipment name not found: " + equipment_name)

func _on_send_gladiator_data_to_peer_card_signal(peer_id: int, _player_gladiator_data: Dictionary, _all_gladiators):
	all_gladiators = _all_gladiators

func format_name(raw_name: String) -> String:
	var parts = raw_name.split("_")            # → ["simple", "sword"]
	var joined = ""                            
	for i in parts.size():
		joined += parts[i]
		if i < parts.size() - 1:
			joined += " "
	return joined.capitalize()                 # → "Simple Sword"

func _on_mouse_entered():
	#print(unique_id)
	var my_id = multiplayer.get_unique_id()
	mouse_inside_button = true
	emit_signal("mouse_inside_equipment_card_signal", mouse_inside_button)
	if parent_name == "ShopGridContainer":
		var tween := get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		

	

func _on_mouse_exited():
	mouse_inside_button = false
	emit_signal("mouse_inside_equipment_card_signal", mouse_inside_button)
	if parent_name == "ShopGridContainer":
		var tween := get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _on_button_up():
	
	emit_signal("button_parent", parent_name)
	
	if parent_name == "ShopGridContainer": 
		if is_multiplayer_authority(): buy_equipment()
	if parent_name == "InventoryGridContainer": 
		if is_multiplayer_authority(): handle_inventory()
		#print("Pressed inventory slot")

func handle_inventory(): pass

func buy_equipment():
	if not equipment_name:
		push_error("Card attribute_name is not set!")
		return

	if mouse_inside_button:
		added = false
		var id := multiplayer.get_unique_id()
		
		if multiplayer.is_server():
			GameState_.buy_equipment_card(id, equipment_name, cost)
		else:
			GameState_.rpc_id(1, "buy_equipment_card", id, equipment_name, cost)

		await get_tree().create_timer(0.15).timeout
		#print(added)
		if added:
			print("💰Bought " + equipment_name + " card")
			mouse_inside_button = false
			disabled = true
			var tween := get_tree().create_tween()
			tween.tween_property(self, "modulate:a", 0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_card_buy_result(peer_id: int, success: bool, _gladiator_data):
	if peer_id == multiplayer.get_unique_id():
		added = success


func get_item_tooltip(item_data: Dictionary):
	var name = format_name(equipment_name)
	var level = item_data.get("level", -1)
	var hands = item_data.get("hands", -1)
	var hand_text = "One-Handed" if hands == 1 else "Two-Handed"
	var min_dmg = item_data.get("min_dmg", -1)
	var max_dmg = item_data.get("max_dmg", -1)
	var str_req = item_data.get("str_req", -1)
	var skill_req = item_data.get("skill_req", -1)
	var durability = item_data.get("durability", -1)
	var speed = item_data.get("speed", -1)
	var crit_chance = item_data.get("crit_chance", -1)
	var crit_multi = item_data.get("crit_multi", -1)
	var weight = item_data.get("weight", -1)
	var category = item_data.get("category", "None")
	var type = item_data.get("type", "None")
	var absorb = item_data.get("absorb", -1)

	var tooltip = name + "\n\n"
	#tooltip += "%Level %d\n" % [level]
	if hands != -1: tooltip += "%s %s\n" % [hand_text, category.capitalize()]
	if min_dmg != -1 and category != "shield": tooltip += "%d–%d Damage\n" % [min_dmg, max_dmg]
	if durability != -1: tooltip += "Durability: %d\n" % durability
	if absorb != -1 and category == "shield": tooltip += "Block Absorb: %d\n" % absorb
	elif absorb != -1 and type == "armor": tooltip += "Absorb: %d\n" % absorb
	if weight != -1: tooltip += "Weight: %d\n" % weight
	if skill_req != -1 and str_req != -1: tooltip += "Requires: Lvl %d, %d Str, %d %s" % [level, str_req, skill_req, category.capitalize()]
	elif skill_req != -1 and str_req == -1: tooltip += "Requires: Lvl %d, %d %s" % [level, skill_req, category.capitalize()]
	elif skill_req == -1 and str_req != -1: tooltip += "Requires: Lvl %d, %d Str" % [level, str_req]
	elif skill_req == -1 and str_req == -1: tooltip += "Requires: Lvl %d" % [level]
	else: "Requires: ???"
	#if str_req != -1: tooltip += "\nStrength Requirement: %d\n" % str_req
	#if skill_req != -1: tooltip += "Weapon Mastery Requirement: %d\n" % skill_req

	if speed != -1: tooltip += "\nSpeed: %.2f Attacks Per Second\n" % speed
	if crit_chance != -1: tooltip += "Critical Chance: %.0f%%\n" % (crit_chance * 100)
	if crit_multi != -1: tooltip += "Critical Multiplier: ×%.1f" % crit_multi

	# Modifications
	var mod_labels := {
		"strength": "Strength",
		"quickness": "Quickness",
		"crit_rating": "Criticality",
		"avoidance": "Avoidance",
		"health": "Health",
		"resilience": "Resilience",
		"endurance": "Endurance",
		
		"sword_mastery": "Sword Mastery",
		"axe_mastery": "Axe Mastery",
		"hammer_mastery": "Hammer Mastery",
		"dagger_mastery": "Dagger Mastery",
		"chain_mastery": "Chain Mastery",
		"shield_mastery": "Shield Mastery",
		"unarmed_mastery": "Unarmed Mastery",
	# Add more as needed
		}
	
	# Modifications
	if item_data.has("modifiers"):
		var mods_attributes = item_data["modifiers"].get("attributes", {})
		var mods_bonuses = item_data["modifiers"].get("bonuses", {})
		var mod_lines = []
		for key in mods_attributes.keys():
			var value = mods_attributes[key]
			if value != 0:
				var label = mod_labels.get(key, key.capitalize())
				mod_lines.append("+%d %s " % [value, label])
		if mod_lines.size() > 0:
			tooltip += "\n\n" + "\n".join(mod_lines)


	return tooltip


func cool_get_item_tooltip(item_data: Dictionary) -> String:
	var tooltip := ""

	# Color definitions
	var name_color := Color.SKY_BLUE
	var stat_color := Color.GRAY
	var type_color := Color.PALE_GREEN
	var mod_color := Color.SKY_BLUE

	# Item name (if you have one)
	if item_data.has("name"):
		tooltip += "[color=%s][b]%s[/b][/color]\n" % [name_color, item_data["name"]]

	# Category and hand type
	var category = item_data.get("category", "")
	if category != "":
		tooltip += "[color=%s]%s[/color]\n" % [stat_color, category.capitalize()]

	var hands = item_data.get("hands", -1)
	if hands != -1:
		var hand_text = "One-handed" if hands == 1 else "Two-handed"
		tooltip += "[color=%s]%s[/color]\n" % [type_color, hand_text]

	# Damage
	var min_dmg = item_data.get("min_dmg", -1)
	var max_dmg = item_data.get("max_dmg", -1)
	if min_dmg != -1 and max_dmg != -1:
		tooltip += "[color=%s]Physical Damage: %d–%d[/color]\n" % [stat_color, min_dmg, max_dmg]

	# Crit and speed
	var crit_chance = item_data.get("crit_chance", -1.0)
	if crit_chance != -1.0:
		tooltip += "[color=%s]Critical Chance: %.1f%%[/color]\n" % [stat_color, crit_chance * 100]

	var speed = item_data.get("speed", -1.0)
	if speed != -1.0:
		tooltip += "[color=%s]Attacks per Second: %.2f[/color]\n" % [stat_color, speed]

	# Requirements
	var str_req = item_data.get("str_req", -1)
	if str_req != -1:
		tooltip += "[color=%s]Requires Strength %d[/color]\n" % [stat_color, str_req]

	var skill_req = item_data.get("skill_req", -1)
	if skill_req != -1:
		tooltip += "[color=%s]Requires Weapon Mastery %d[/color]\n" % [stat_color, skill_req]

	# Modifications
	var mod_labels := {
		"strength": "Strength",
		"weapon_skill": "Weapon Mastery",
		"quickness": "Quickness",
		"crit_rating": "Criticality",
		"avoidance": "Avoidance",
		"health": "Health",
		"resilience": "Resilience",
		"endurance": "Endurance"
	}

	if item_data.has("modifications"):
		var mods = item_data["modifications"]
		for key in mods.keys():
			var value = mods[key]
			if value != 0:
				var label = mod_labels.get(key, key.capitalize())
				tooltip += "[color=%s][b]+%d %s[/b][/color]\n" % [mod_color, value, label]

	return tooltip.strip_edges()
