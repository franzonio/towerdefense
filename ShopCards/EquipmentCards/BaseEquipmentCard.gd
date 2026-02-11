# BaseCard.gd
extends Button

@export var equipment_name: String = ""
#@export var cost: int
var cost

var name_label
var self_name
var parent_name
var item_dict
var original_item_dict
var all_gladiators
var initial_tooltip_received = 0

#@export var unique_id : String

var mouse_inside_button := false
var added := false
signal button_parent(parent_name: String)
signal mouse_inside_equipment_card_signal(mouse_inside_equipment_card: bool)

var name_color := "ab9b8e"#"ef692f"
var base_text_color := "ab9b8e"#"927e6a"
var base_value_color := "d2c9a5"#"efd8a1"
var req_ok_color := "d2c9a5"#"efd8a1"
var req_nok_color := "79444a"#"ef3a0c"
var mod_color := "3c9f9c"#"8caba1"

var weapon_color := "d2c9a5"#Color.DARK_GRAY.to_html(false)
var armor_color := "ba9158"#Color.BURLYWOOD.to_html(false)
var jewellery_color := "b3a555"#Color.GOLDENROD.to_html(false)

var label_display

var orig_min_dmg
var orig_durability
var orig_weight
var orig_speed
var orig_crit_chance
var orig_crit_multi
var orig_absorb

var equipment_script 
var equipment_instance
var equipment_data 

func _ready():
	equipment_script = load("res://Equipment.gd")
	equipment_instance = equipment_script.new()
	equipment_data = equipment_instance.all_equipment
	var item = find_value_recursive(equipment_data, equipment_name)
	cost = item["price"]
	
	set_texture_filter(CanvasItem.TEXTURE_FILTER_NEAREST)
	#ProjectSettings.set_setting("gui/timers/tooltip_delay_sec", 5.0)
	#print("_ready()")
	initial_tooltip_received = 0
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	GameState_.connect("card_buy_result", Callable(self, "_on_card_buy_result"))
	GameState_.connect("send_equipment_dict_to_peer_signal", Callable(self, "_on_send_equipment_dict_to_peer"))
	GameState_.connect("send_gladiator_data_to_peer_card_signal", Callable(self, "_on_send_gladiator_data_to_peer_card_signal"))
	GameState_.connect("update_equipment_card_signal", Callable(self, "_on_equipment_card_updated"))
	GameState_.connect("signal_update_gold_req_in_shop_for_peer", Callable(self, "_on_update_gold_req_shop"))
	
	if multiplayer.is_server():
		GameState_.refresh_gladiator_data_card(multiplayer.get_unique_id())
		GameState_.get_equipment_by_name(multiplayer.get_unique_id(), equipment_name)
	else:
		GameState_.rpc_id(1, "refresh_gladiator_data_card", multiplayer.get_unique_id())
		GameState_.rpc_id(1, "get_equipment_by_name", multiplayer.get_unique_id(), equipment_name)
	
	#await get_tree().create_timer(0.3).timeout
	
	parent_name = get_parent().name
	if parent_name == "ShopGridContainer":
		label_display = format_name(equipment_name)
		name_label = RichTextLabel.new()
		name_label.add_theme_font_size_override("normal_font_size", 22)
		name_label.add_theme_font_size_override("bold_font_size", 22)
		name_label.bbcode_enabled = true
		name_label.fit_content = false
		name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		name_label.scroll_active = false
		name_label.position.y = -100
		name_label.position.x = 30
		
		name_label.size = Vector2(128,128)
		
		#name_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
		name_label.add_theme_color_override("font_outline_color", Color.BLACK)
		name_label.add_theme_constant_override("outline_size", 5)
		"theme_override_constants/outline_size"
		add_child(name_label)
		if all_gladiators != null:
			_on_update_gold_req_shop(multiplayer.get_unique_id(), all_gladiators[multiplayer.get_unique_id()]["gold"])
			
	
func find_value_recursive(target_dict: Dictionary, target_key: String):
	# 1. Check if the key exists at the current level
	if target_dict.has(target_key):
		return target_dict[target_key]
	
	# 2. If not, look inside any nested dictionaries
	for key in target_dict:
		if target_dict[key] is Dictionary:
			var result = find_value_recursive(target_dict[key], target_key)
			if result != null:
				return result
				
	# 3. Return null if nothing is found in this branch
	return null

func _make_custom_tooltip(for_text):
	
	var label = RichTextLabel.new()
	label.set_texture_filter(CanvasItem.TEXTURE_FILTER_NEAREST)
	label.add_theme_font_size_override("normal_font_size", 20)
	label.add_theme_font_size_override("bold_font_size", 20)
	label.bbcode_text = for_text
	label.bbcode_enabled = true
	label.fit_content = true
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.scroll_active = false
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 5)
	
	
	return label

func _on_send_gladiator_data_to_peer_card_signal(_peer_id: int, _player_gladiator_data: Dictionary, _all_gladiators):
	all_gladiators = _all_gladiators
	_on_update_gold_req_shop(multiplayer.get_unique_id(), all_gladiators[multiplayer.get_unique_id()]["gold"])

func _on_update_gold_req_shop(_id, gold):
	#print("_on_update_gold_req_shop: " + str(_id))
	
	if multiplayer.get_unique_id() != _id: return
	
	#print(equipment_name + " | cost: " + str(cost) + " | gold after buy eq: " + str(gold) + " item dict: " + str(item_dict) + "\n")
	#print("item dict: " + str(item_dict))
	
	if item_dict:
		if parent_name == "ShopGridContainer" and item_dict.has(equipment_name):
			var item_type = item_dict[equipment_name]["type"]
			var color = Color.WHITE.to_html(false)
			
			if item_type == "weapon": color = weapon_color
			elif item_type == "armor": color = armor_color
			elif item_type == "jewellery": color = jewellery_color
			
			
			
			if gold < cost:
				name_label.bbcode_text = "[color=%s]%s[/color] \n💰[color=%s]%d[/color] " % [color, label_display, req_nok_color, cost] 
			else:
				name_label.bbcode_text = "[color=%s]%s[/color] \n💰%d " % [color, label_display, cost] 
				
			''' JUST ADDED THIS LINE, DOES IT WORK PROPERLY?'''
			tooltip_text = get_item_tooltip(item_dict[equipment_name])
			
	#else: 1#print("no item dict!")

func _on_equipment_card_updated(id, updated_item_dict, slot, item):
	
	if id != multiplayer.get_unique_id(): return

	#print("updating equipment card for " + item)

	if parent_name == "Weapon1Slot":
		print("slot.capitalize(): " + slot.capitalize() + " | parent_name: " + str(parent_name) + " | " + str(slot.capitalize() in parent_name))
		
	if "slot" in slot: 
		if parent_name != slot: return
		tooltip_text = ""
		tooltip_text = get_item_tooltip(updated_item_dict[item])
	elif ucfirst(slot) in parent_name:
		tooltip_text = ""
		tooltip_text = get_item_tooltip(updated_item_dict[item])
		

	
func ucfirst(_text: String) -> String:
	if _text.length() == 0:
		return _text
	return _text[0].to_upper() + _text.substr(1)


func _on_send_equipment_dict_to_peer(id, _item_dict):
	if id != multiplayer.get_unique_id(): return
	if initial_tooltip_received == 1: 
		return
	
	
	
	if _item_dict.has(equipment_name):
		
		item_dict = _item_dict.duplicate(true)
	
		_on_update_gold_req_shop(multiplayer.get_unique_id(), all_gladiators[multiplayer.get_unique_id()]["gold"])
		
		var item = item_dict[equipment_name].duplicate(true)
		orig_min_dmg = item.get("min_dmg", 0)
		orig_durability = item.get("durability", 0)
		orig_weight = item.get("weight", 0)
		orig_speed = item.get("speed", 0)
		orig_crit_chance = item.get("crit_chance", 0)
		orig_crit_multi = item.get("crit_multi", 0)
		orig_absorb = item.get("absorb", 0)
		original_item_dict = item_dict.duplicate(true)
		
		if tooltip_text == "": 
			tooltip_text = get_item_tooltip(item)
	


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
	#var my_id = multiplayer.get_unique_id()
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
	# Color definitions
	#var custom_theme = preload("res://ShopCards/card_tooltip_theme.tres")
	#theme.clear_color("bg_color", "Panel")
	#theme.set_color("bg_color", "PopupPanel/styles/panel", Color(0, 1, 1))
	

	
	var display_name = format_name(equipment_name)
	var level = item_data.get("level", -1)
	var hands = item_data.get("hands", -1)
	var hand_text = "One-Handed" if hands == 1 else "Two-Handed"
	
	var added_min_dmg = 0
	var added_max_dmg = 0
	var min_base_dmg = item_data.get("min_dmg", -1)
	var max_base_dmg = item_data.get("max_dmg", -1)
	var added_dmg = item_data["modifiers"]["bonuses"].get("added_dmg", "0").split("-")
	if added_dmg.size() > 1:
		added_min_dmg = int(added_dmg[0])
		added_max_dmg = int(added_dmg[1])
		
	var increased_dmg = 1.0 + float(item_data["modifiers"]["bonuses"].get("increased_dmg", "0"))/100.0
	var min_dmg = int(round((min_base_dmg+added_min_dmg)*increased_dmg))
	var max_dmg = int(round((max_base_dmg+added_max_dmg)*increased_dmg))
	
	var crit_chance = item_data.get("crit_chance", -1)
	var crit_multi = item_data.get("crit_multi", -1)
	var speed = item_data.get("speed", -1)
	
	var str_req = item_data.get("str_req", 0)
	var skill_req = item_data.get("skill_req", 0)
	var durability = item_data.get("durability", -1)

	var weight = item_data.get("weight", -1)
	var category = item_data.get("category", "None")
	var type = item_data.get("type", "None")
	var absorb = item_data.get("absorb", -1)
	
	if type == "jewellery": name_color = jewellery_color
	elif type == "armor": name_color = armor_color
	elif type == "weapon": name_color = weapon_color

	var tooltip = "[color=%s]%s[/color]\n" % [name_color, display_name]
	#tooltip += "%Level %d\n" % [level]
	if category == "shield": 
		tooltip += "[color=%s]%s[/color]\n\n" % [base_text_color, category.capitalize()]
	elif hands != -1: 
		tooltip += "[color=%s]%s %s[/color]\n\n" % [base_text_color, hand_text, category.capitalize()]
	elif hands == -1:
		tooltip += "[color=%s]%s[/color]\n\n" % [base_text_color, category.capitalize()]
		
	if min_dmg != -1 and category != "shield": 
		if min_dmg == orig_min_dmg: 
			tooltip += "[color=%s]Damage:[/color] [color=%s]%d–%d[/color]\n" % [base_text_color, base_value_color, min_dmg, max_dmg]
		else:
			tooltip += "[color=%s]Damage:[/color] [color=%s]%d–%d[/color]\n" % [base_text_color, mod_color, min_dmg, max_dmg]
			
	if speed > 0: 
		if speed == orig_speed:
			tooltip += "[color=%s]Attacks Per Second:[/color] [color=%s] %.2f [/color]\n" % [base_text_color, base_value_color, speed]#tooltip += "\nSpeed: %.2f Attacks Per Second\n" % speed
		else:
			tooltip += "[color=%s]Attacks Per Second:[/color] [color=%s] %.2f [/color]\n" % [base_text_color, mod_color, speed]
	
	if crit_multi > 0: 
		if crit_multi == orig_crit_multi:
			tooltip += "[color=%s]Critical Multiplier:[/color] [color=%s]×%.2f[/color]\n" % [base_text_color, base_value_color, crit_multi]
		else:
			tooltip += "[color=%s]Critical Multiplier:[/color] [color=%s]×%.2f[/color]\n" % [base_text_color, mod_color, crit_multi]	
		
	if crit_chance > 0: 
		if crit_chance == orig_crit_chance:
			tooltip += "[color=%s]Critical Chance:[/color] [color=%s]%.1f%%[/color]\n" % [base_text_color, base_value_color, (crit_chance * 100)]
		else:
			tooltip += "[color=%s]Critical Chance:[/color] [color=%s]%.1f%%[/color]\n" % [base_text_color, mod_color, (crit_chance * 100)]
			
			
	if durability != -1: 
		if durability == orig_durability:
			tooltip += "[color=%s]Durability:[/color] [color=%s]%d[/color]\n" % [base_text_color, base_value_color, durability]
		else:
			tooltip += "[color=%s]Durability:[/color] [color=%s]%d[/color]\n" % [base_text_color, mod_color, durability]
			
	if absorb != -1 and category == "shield": 
		if absorb == orig_absorb:
			tooltip += "[color=%s]Block Absorb:[/color] [color=%s]%d[/color]\n" % [base_text_color, base_value_color, absorb]
		else:
			tooltip += "[color=%s]Block Absorb:[/color] [color=%s]%d[/color]\n" % [base_text_color, mod_color, absorb]
			
	elif absorb != -1 and type == "armor": 
		if absorb == orig_absorb:
			tooltip += "[color=%s]Absorb:[/color] [color=%s]%d[/color]\n" % [base_text_color, base_value_color, absorb]
		else:
			tooltip += "[color=%s]Absorb:[/color] [color=%s]%d[/color]\n" % [base_text_color, mod_color, absorb]
	
	if weight != -1: 
		if weight == orig_weight:
			tooltip += "[color=%s]Weight:[/color] [color=%s]%d[/color]\n" % [base_text_color, base_value_color, weight]
		else:
			tooltip += "[color=%s]Weight:[/color] [color=%s]%d[/color]\n" % [base_text_color, mod_color, weight]
	
	var lvl_req_color
	if int(all_gladiators[multiplayer.get_unique_id()]["level"]) >= int(level): lvl_req_color = req_ok_color
	else: lvl_req_color = req_nok_color
	
	var str_req_color
	if all_gladiators[multiplayer.get_unique_id()]["attributes"]["strength"] >= str_req: str_req_color = req_ok_color
	else: str_req_color = req_nok_color
	
	var skill_req_color = req_ok_color
	#if all_gladiators[multiplayer.get_unique_id()][level] >= level: skill_req_color = req_ok_color
	#else: skill_req_color = req_nok_color
	
	if skill_req != 0 and str_req != 0: # SKILL REQ | LVL REQ
		tooltip += "[color=%s]Requires: Lvl[/color] [color=%s]%d[/color][color=%s],[/color] [color=%s]Str[/color] [color=%s]%d[/color][color=%s],[/color] [color=%s]%s[/color] [color=%s]%d[/color]" % [base_text_color, lvl_req_color, level, base_text_color, 
																base_text_color, str_req_color, str_req, base_text_color,
																base_text_color, category.capitalize(), skill_req_color, skill_req]
	elif skill_req != 0 and str_req == 0: # SKILL REQ | NO STR REQ
		#print("no_str_req")
		tooltip += "[color=%s]Requires: Lvl[/color] [color=%s]%d[/color][color=%s]%s[/color] [color=%s]%d[/color]" % [base_text_color, lvl_req_color, level,
																base_text_color, category.capitalize(), skill_req_color, skill_req]
	elif skill_req == 0 and str_req != 0: # NO SKILL REQ | STR REQ
		tooltip += "[color=%s]Requires: Lvl[/color] [color=%s]%d[/color][color=%s],[/color] [color=%s]Str[/color] [color=%s]%d[/color]" % [base_text_color, lvl_req_color, level, base_text_color, 
																base_text_color, str_req_color, str_req]
	elif skill_req == 0 and str_req == 0: # NO SKILL REQ | NO STR REQ
		tooltip += "[color=%s]Requires: Lvl [color=%s]%d" % [base_text_color, lvl_req_color, level]
	else: "Requires: ???"
	#if str_req != -1: tooltip += "\nStrength Requirement: %d\n" % str_req
	#if skill_req != -1: tooltip += "Weapon Mastery Requirement: %d\n" % skill_req



	# Modifications
	var mod_labels := {
		"strength": "Strength",
		"quickness": "Quickness",
		"crit_rating": "Criticality",
		"avoidance": "Avoidance",
		"health": "Health",
		"resilience": "Resilience",
		"endurance": "Endurance",
		
		"increased_health": "% increased health attribute",
		"increased_strength": "% increased strength attribute",
		"increased_quickness": "% increased quickness attribute",
		"increased_crit_rating": "% increased criticalty attribute",
		"increased_avoidance": "% increased avoidance attribute",
		"increased_resilience": "% increased resilience attribute",
		"increased_endurance": "% increased endurance attribute",

		"increased_sword_mastery": "% increased sword mastery",
		"increased_axe_mastery": "% increased axe mastery",
		"increased_stabbing_mastery": "% increased stabbing mastery",
		"increased_mace_mastery": "% increased mace mastery",
		"increased_flagellation_mastery": "% increased flagellation mastery",
		"increased_shield_mastery": "% increased shield mastery",
		
		"sword_mastery": "Sword Mastery",
		"axe_mastery": "Axe Mastery",
		"mace_mastery": "Mace Mastery",
		"stabbing_mastery": "Stabbing Mastery",
		"flagellation_mastery": "flagellation Mastery",
		"shield_mastery": "Shield Mastery",
		"unarmed_mastery": "Unarmed Mastery",
		
		"local_increased_attack_speed": "% increased local attack speed",
		"local_increased_crit_multi": "% increased local critical multiplier",
		"local_increased_crit_chance": "% increased local critical strike chance",
		"local_added_abs": " additional absorb",
		"local_added_durability": " to durability",
		"local_increased_durability": "% increased durability",
		
		"global_increased_crit_chance": "% increased global critical strike chance",
		"global_increased_crit_multi": "% increased global critical multiplier",
		"global_increased_attack_speed": "% increased global attack speed",
		
		"added_dmg": " additional weapon damage",
		"increased_dmg": "% increased weapon damage",
		"added_hit_chance": "% additional hit chance",
		"added_block_chance": "% increased block chance",
		"life_on_block": " life on block",
		"life_on_hit": " life on hit",
		"thorns": " to thorns",
		
		}
		
	
	# Modifications
	if item_data.has("modifiers"):
		var mods_attributes = item_data["modifiers"].get("attributes", {})
		var mod_lines = []
		for key in mods_attributes.keys():
			var value = mods_attributes[key]
			if value != 0 or value != "0":
				var label = mod_labels.get(key, key.capitalize())
				mod_lines.append("[color=%s]+%d %s [/color]" % [mod_color, value, label])
		if mod_lines.size() > 0:
			tooltip += "\n\n" + "\n".join(mod_lines)

			
		var mods_bonuses = item_data["modifiers"].get("bonuses", {})
		mod_lines = []
		for key in mods_bonuses.keys():
			if key == "blood_rage":
				var value1 = mods_bonuses[key][0]
				var value2 = mods_bonuses[key][1]
				mod_lines.append("[color=%s]%.2f%% life drained per second\n %.0f%% increased damage[/color]" % [mod_color, value1, value2])
			if key == "to_gold_income":
				var value = mods_bonuses[key]
				var label = mod_labels.get(key, key.capitalize())
				mod_lines.append("[color=%s]Gain %s extra gold per round[/color]" % [mod_color, value])
				
			else:
				var value = mods_bonuses[key]
				var label = mod_labels.get(key, key.capitalize())
				mod_lines.append("[color=%s]%s%s[/color]" % [mod_color, value, label])
		if mod_lines.size() > 0:
			tooltip += "\n\n" + "\n".join(mod_lines)


	return tooltip
