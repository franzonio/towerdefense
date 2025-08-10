extends CanvasLayer

@onready var strength_card = preload("res://ShopCards/AttributeCards/StrengthCard.tscn")
@onready var health_card = preload("res://ShopCards/AttributeCards/HealthCard.tscn")
@onready var avoidance_card = preload("res://ShopCards/AttributeCards/AvoidanceCard.tscn")
@onready var criticality_card = preload("res://ShopCards/AttributeCards/CriticalityCard.tscn")
@onready var endurance_card = preload("res://ShopCards/AttributeCards/EnduranceCard.tscn")
@onready var quickness_card = preload("res://ShopCards/AttributeCards/QuicknessCard.tscn")
@onready var resilience_card = preload("res://ShopCards/AttributeCards/ResilienceCard.tscn")
@onready var weapon_mastery_card = preload("res://ShopCards/AttributeCards/WeaponMasteryCard.tscn")

@onready var simple_sword_card = preload("res://ShopCards/EquipmentCards/Sword/SimpleSword.tscn")

var equipment_card_scenes = {
	"simple_sword": simple_sword_card
}

@onready var inventory_popup := $InventoryPopup
@onready var equipment_popup := $EquipmentPopup
@onready var label_round = $MarginContainer/HBoxContainer/Label_Round
@onready var label_gold = $MarginContainer/HBoxContainer/Label_Gold
@onready var label_xp = $MarginContainer/HBoxContainer/Label_Experience

const MAX_MESSAGES = 50
const MAX_LENGTH = 255

@onready var chat_log = $Panel/ChatScroll/ChatLog
@onready var chat_input = $HBoxContainer/ChatInput
@onready var send_button = $HBoxContainer/SendButton
@onready var chat_scroll = $Panel/ChatScroll

@export var round_now = 0
@export var time_passed: float = 0.0
@export var gold: int = 0
@export var experience: int = 0

@export var name_label: Node
@export var race_label: Node
@export var life_label: Node

var player_gladiator_data
var all_gladiators
#var countdown_label 
#var shop
var intermission := true
var shop_pressed := false
var equipment_pressed := false
var chat_input_pressed := false
var msg_just_sent := false
#var shop_grid
#var inventory_grid
#var equipment_panel
#var refresh_button
@export var all_cards: Array
#var _all_cards
var reroll_start_of_intermission
var is_refreshing := false
@export var card_stock: Dictionary

var selected_item_name := ""
var selected_slot := ""
var equipment_button_parent_name

@onready var shop_grid = $Shop/VBoxContainer/ShopGridContainer
@onready var refresh_button = $Shop/VBoxContainer/HBoxContainer/RefreshButton
@onready var equipment_panel = $EquipmentPanel
@onready var inventory_grid = $Inventory/InventoryGridContainer
@onready var countdown_label = $IntermissionTimerLabel
@onready var shop = $Shop
@onready var concede_threshold_menu = $ConcedePanel/ConcedeThresholdMenu
@onready var exp_button = $ExpButton

@onready var head_slot = $EquipmentPanel/HeadSlot
@onready var chest_slot = $EquipmentPanel/ChestSlot
@onready var weapon1_slot = $EquipmentPanel/Weapon1Slot
@onready var weapon2_slot = $EquipmentPanel/Weapon2Slot
@onready var ring1_slot = $EquipmentPanel/Ring1Slot
@onready var ring2_slot = $EquipmentPanel/Ring2Slot

@onready var attribute_panel = $AttributePanel
@onready var health_panel = $AttributePanel/GridContainer/Health
@onready var strength_panel = $AttributePanel/GridContainer/Strength
@onready var weapon_skill_panel = $AttributePanel/GridContainer/WeaponSkill
@onready var endurance_panel = $AttributePanel/GridContainer/Endurance
@onready var criticality_panel = $AttributePanel/GridContainer/Criticality
@onready var avoidance_panel = $AttributePanel/GridContainer/Avoidance
@onready var quickness_panel = $AttributePanel/GridContainer/Quickness
@onready var resilience_panel = $AttributePanel/GridContainer/Resilience

var exp_for_level = {"1": 0, "2": 10, "3": 12, "4": 14, "5": 18, "6": 22, "7": 26, "8": 30, "9": 34, "10": 36}
var max_lvl

var equipment_script 
var equipment_instance
var equipment_data 
#@onready var all_equipment_slots = [head_slot, chest_slot, weapon1_slot, weapon2_slot, ring1_slot, ring2_slot]
signal concede_threshold_changed(value: int)

func _ready():
	equipment_script = load("res://Equipment.gd")
	equipment_instance = equipment_script.new()
	equipment_data = equipment_instance.all_equipment
	#print(equipment_data)
	
	GameState_.connect("gladiator_life_changed", Callable(self, "_on_life_changed"))
	GameState_.connect("countdown_updated", Callable(self, "_on_countdown_updated"))
	GameState_.connect("card_stock_changed", Callable(self, "_on_card_stock_changed"))
	GameState_.connect("send_gladiator_data_to_peer_signal", Callable(self, "_on_send_gladiator_data_to_peer_signal"))
	GameState_.connect("broadcast_log_signal", Callable(self, "_on_log_received"))
	

	send_button.pressed.connect(_on_send_pressed)
	chat_input.text_submitted.connect(_on_send_pressed)

	#populate_hud()  # Initial draw
	
	inventory_popup.clear()
	inventory_popup.add_item("Equip", 0)
	inventory_popup.add_item("Sell", 1)
	inventory_popup.id_pressed.connect(_on_inventory_popup_pressed)
	
	equipment_popup.clear()
	equipment_popup.add_item("Unequip", 0)
	equipment_popup.add_item("Sell", 1)
	equipment_popup.id_pressed.connect(_on_equipment_popup_pressed)

	shop.visible = false
	equipment_panel.visible = false
	attribute_panel.visible = false
	
	if multiplayer.is_server(): GameState_.initialize_card_stock()
	else: GameState_.rpc_id(1, "initialize_card_stock")
	await get_tree().create_timer(1).timeout
	all_cards = get_all_cards()

	if multiplayer.is_server():
		GameState_.refresh_gladiator_data(multiplayer.get_unique_id())
	else:
		GameState_.rpc_id(1, "refresh_gladiator_data", multiplayer.get_unique_id())
	
	await get_tree().create_timer(0.8).timeout
	roll_cards()
	
	concede_threshold_menu.connect("item_selected", Callable(self, "_on_threshold_selected"))
	
	var keys = exp_for_level.keys()
	var int_keys = []
	for k in keys:
		int_keys.append(int(k))

	int_keys.sort()  # Sorts in place
	max_lvl = str(int_keys[-1])  # "10"
	
func _process(delta: float) -> void:
	time_passed += delta
	#print("mouse position: " + str(get_viewport().get_mouse_position()))
	if !intermission: label_round.text = "Day " + str(round_now) + " | " + str(int(time_passed))
	if intermission: concede_threshold_menu.disabled = false
	else: concede_threshold_menu.disabled = true
	
	if Input.is_action_just_pressed("toggle_shop") and not chat_input.has_focus():
		if $ShopButton:
			$ShopButton.emit_signal("pressed")
	if Input.is_action_just_pressed("toggle_equipment") and not chat_input.has_focus():
		if $EquipmentButton:
			$EquipmentButton.emit_signal("pressed")
	
func get_equipment_by_name(item_name: String):
	for category in equipment_data.keys():
		var items = equipment_data[category]
		if items.has(item_name):
			var result := {}
			result[item_name] = items[item_name]
			return result
	return {}  # Return empty if not found
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not chat_input.get_global_rect().has_point(event.position):
			chat_input.release_focus()

	
func _on_send_pressed(): #submitted_text = ""):
	var msg = chat_input.text.strip_edges()
	if msg.length() == 0 or msg.length() > MAX_LENGTH:
		return

	var sender_id = get_tree().get_multiplayer().get_unique_id()
	var now = Time.get_datetime_dict_from_system()
	var timestamp = "[%02d:%02d]" % [now.hour, now.minute]

	chat_input.clear()
	rpc("broadcast_message", sender_id, str(player_gladiator_data["name"]), timestamp, msg)


func _on_log_received(message):
	#var now = Time.get_datetime_dict_from_system()
	#var timestamp = "[%02d:%02d]" % [now.hour, now.minute]
	var formatted = "%s" % [message]

	var label = RichTextLabel.new()
	label.bbcode_enabled = true
	label.text = formatted

	# Ensure it expands and wraps
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.fit_content = true
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	label.scroll_active = false

	# Add to chat log
	chat_log.add_child(label)

	# Remove old messages
	if chat_log.get_child_count() > MAX_MESSAGES:
		chat_log.get_child(0).queue_free()

	# Scroll to bottom
	await get_tree().process_frame
	await get_tree().process_frame
	chat_scroll.scroll_vertical = chat_scroll.get_v_scroll_bar().max_value
	
	
@rpc("any_peer", "call_local")
func broadcast_message(sender_id, sender_name: String, timestamp: String, message: String):
	_add_message(sender_id, sender_name, timestamp, message)


func _add_message(sender_id, sender_name: String, timestamp: String, message: String):
	var gladiator = all_gladiators.get(sender_id)
	var color = gladiator.get("color", Color.WHITE)
	var hex_color = color.to_html()

	var formatted = "%s [color=%s]%s[/color]: %s" % [timestamp, hex_color, sender_name, message]

	var label = RichTextLabel.new()
	label.bbcode_enabled = true
	label.text = formatted

	# Ensure it expands and wraps
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.fit_content = true
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	label.scroll_active = false

	# Add to chat log
	chat_log.add_child(label)

	# Debug print
	#print("Added chat message:", formatted)

	# Remove old messages
	if chat_log.get_child_count() > MAX_MESSAGES:
		chat_log.get_child(0).queue_free()

	# Scroll to bottom
	await get_tree().process_frame
	await get_tree().process_frame
	chat_scroll.scroll_vertical = chat_scroll.get_v_scroll_bar().max_value



	
func _on_send_gladiator_data_to_peer_signal(peer_id: int, _player_gladiator_data: Dictionary, _all_gladiators):
	all_gladiators = _all_gladiators
	if peer_id == multiplayer.get_unique_id():
		#print("streak for peer " + str(peer_id) + ": " + str(all_gladiators[peer_id]["streak"]))
		#print("_player_gladiator_data: " + _player_gladiator_data["name"] + ", exp: " + str(_player_gladiator_data["exp"]) + ", lvl: " + _player_gladiator_data["level"])
		player_gladiator_data = _player_gladiator_data
		update_inventory_ui(peer_id)
		update_equipment_ui()
		update_attribute_ui()
		update_concede_ui()
		update_gold(player_gladiator_data["gold"])
		update_experience(player_gladiator_data["exp"])
	#print("_on_send_gladiator_data_to_peer_signal: " + str(multiplayer.get_unique_id()))
	populate_hud()
	
func update_concede_ui():
	var previous_index = concede_threshold_menu.get_selected_id()
	#print(previous_index)
	var attributes = player_gladiator_data.get("attributes", {})
	var options = ["50% (" + str(int(round(0.5*attributes["health"]))) + " hp)", 
					"40% (" + str(int(round(0.4*attributes["health"]))) + " hp)", 
					"30% (" + str(int(round(0.3*attributes["health"]))) + " hp)", 
					"20% (" + str(int(round(0.2*attributes["health"]))) + " hp)", 
					"10% (" + str(int(round(0.1*attributes["health"]))) + " hp)", 
					"0% ("  + str(int(round(0.0*attributes["health"]))) + " hp)"]
					
	concede_threshold_menu.clear()
	for option in options: concede_threshold_menu.add_item(option)
	if previous_index == -1: concede_threshold_menu.select(0)
	else: concede_threshold_menu.select(previous_index)
	
func update_attribute_ui(): 
	var attributes = player_gladiator_data.get("attributes", {})
	health_panel.text = "Health: " + str(int(attributes["health"]))
	strength_panel.text = "Strength: " + str(int(attributes["strength"]))
	weapon_skill_panel.text = "Weapon Mastery " + str(int(attributes["weapon_skill"]))
	endurance_panel.text = "Endurance " + str(int(attributes["endurance"]))
	criticality_panel.text = "Criticality " + str(int(attributes["crit_rating"]))
	avoidance_panel.text = "Avoidance " + str(int(attributes["avoidance"]))
	quickness_panel.text = "Quickness " + str(int(attributes["quickness"]))
	resilience_panel.text = "Resilience " + str(int(attributes["resilience"]))
	
func update_equipment_ui(): 
	for slot in equipment_panel.get_children():
		for i in slot.get_children():
			i.queue_free()
			
	var head_name
	var chest_name 
	var weapon1_name
	var weapon2_name
	var ring1_name 
	var ring2_name 
			
	var all_equipment_slots = [head_slot, chest_slot, weapon1_slot, weapon2_slot, ring1_slot, ring2_slot]
	if player_gladiator_data["head"] != {}:
		head_name = player_gladiator_data["head"].keys()[0]
	else:
		head_name = "empty"
	
	if player_gladiator_data["chest"] != {}:
		chest_name = player_gladiator_data["chest"].keys()[0]
	else:
		chest_name = "empty"
	
	if player_gladiator_data["weapon1"] != {}:
		weapon1_name = player_gladiator_data["weapon1"].keys()[0]
	else:
		weapon1_name = "empty"
		
	if player_gladiator_data["weapon1"] != {}:
		weapon1_name = player_gladiator_data["weapon1"].keys()[0]
	else:
		weapon1_name = "empty"
		
	if player_gladiator_data["weapon2"] != {}:
		weapon2_name = player_gladiator_data["weapon2"].keys()[0]
	else:
		weapon2_name = "empty"
		
	if player_gladiator_data["ring1"] != {}:
		ring1_name = player_gladiator_data["ring1"].keys()[0]
	else:
		ring1_name = "empty"
	
	if player_gladiator_data["ring2"] != {}:
		ring2_name = player_gladiator_data["ring2"].keys()[0]
	else:
		ring2_name = "empty"
	
	
	var all_equipped_items_name = [head_name, chest_name, weapon1_name, weapon2_name, ring1_name, ring2_name]
	
	for i in all_equipped_items_name.size()-1: 
		var item_slot = all_equipment_slots[i]
		var item_name = all_equipped_items_name[i]
		var card_found = 0
		
		for card_map in all_cards:
			if card_map[1] == item_name:
				var item_instance = card_map[0].instantiate()
				item_instance.button_parent.connect(_on_equipment_pressed)
				item_instance.pressed.connect(_on_equipment_item_pressed.bind(item_name))
				item_instance.set_multiplayer_authority(multiplayer.get_unique_id())
				item_slot.add_child(item_instance)
				item_instance.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
				item_instance.custom_minimum_size = item_slot.size
				card_found = 1
				continue
			elif item_name == "empty" or item_name == "unarmed":
				card_found = 1
				continue
				
		if card_found == 0: 
			if multiplayer.is_server():
				GameState_.add_to_peer_log(multiplayer.get_unique_id(), "No card defined for item " + str(item_name) + ". Please report this as a bug.")
			else:
				GameState_.rpc_id(1, "add_to_peer_log", multiplayer.get_unique_id(), "No card defined for item " + str(item_name) + ". Please report this as a bug.")
			#print("No card defined for item " + str(item_name))
			
func _on_equipment_pressed(parent_name: String):
	equipment_button_parent_name = parent_name
	#print("_on_equipment_pressed: " + str(parent_name))
	
func update_inventory_ui(glad_id: int):
	var gladiator_inventory = player_gladiator_data["inventory"]
	#print("peer " + str(glad_id) + " inventory: " + str(gladiator_inventory))
	
	# Clear existing grid
	for child in inventory_grid.get_children():
		child.queue_free()

	# Build a lookup from all_cards
	var card_scene_map := {}
	for card in all_cards:
		card_scene_map[card[1]] = card[0]  # card[1] is name, card[0] is scene

	for slot_name in gladiator_inventory.keys():
		var slot_data = gladiator_inventory[slot_name]

		if typeof(slot_data) == TYPE_DICTIONARY and slot_data.size() > 0:
			var item_name = slot_data.keys()[0]

			# Find corresponding scene
			if card_scene_map.has(item_name):
				var card_instance = card_scene_map[item_name].instantiate()
				card_instance.pressed.connect(_on_inventory_item_pressed.bind(item_name, slot_name))
				card_instance.set_multiplayer_authority(multiplayer.get_unique_id())  # Optional, for sync
				inventory_grid.add_child(card_instance)
			else:
				print("⚠️ No matching scene for item:", item_name)

func _on_threshold_selected(index: int):
	var selected_text = concede_threshold_menu.get_item_text(index)
	var regex = RegEx.new()
	regex.compile("^\\d+")
	var result = regex.search(selected_text)
	var threshold = result.get_string() if result != null else "0"
	threshold = float(threshold)/100

	if multiplayer.is_server():
		GameState_.peer_concede(multiplayer.get_unique_id(), threshold)
	else:
		GameState_.rpc_id(1, "peer_concede", multiplayer.get_unique_id(), threshold)

	emit_signal("concede_threshold_changed", threshold)
	#print("📉 Threshold selected:", threshold)


func _on_equipment_popup_pressed(id: int):
	match id:
		0:
			if !intermission: 
				if multiplayer.is_server():
					GameState_.add_to_peer_log(multiplayer.get_unique_id(), "[INFO] ❌Cannot unequip item during duel!")
				else:
					GameState_.rpc_id(1, "add_to_peer_log", multiplayer.get_unique_id(), "[INFO] ❌Cannot unequip item during duel!")
				
				#GameState_.rpc("add_to_peer_log", "Cannot unequip item during duel!")
				return
			
			if multiplayer.is_server():
				GameState_.unequip_item(multiplayer.get_unique_id(), selected_item_name, equipment_button_parent_name)
			else:
				GameState_.rpc_id(1, "unequip_item", multiplayer.get_unique_id(), selected_item_name, equipment_button_parent_name)
			
			
			await get_tree().create_timer(0.2).timeout
			
		1:
			if !intermission: 
				if multiplayer.is_server():
					GameState_.add_to_peer_log(multiplayer.get_unique_id(), "[INFO] ❌Cannot sell equipped item during duel!")
				else:
					GameState_.rpc_id(1, "add_to_peer_log", multiplayer.get_unique_id(), "[INFO] ❌Cannot sell equipped item during duel!")
				return
				
			#print("Sell from equipment not implemented yet")
			if multiplayer.is_server():
				GameState_.sell_from_equipment(multiplayer.get_unique_id(), selected_item_name, equipment_button_parent_name)
			else:
				GameState_.rpc_id(1, "sell_from_equipment", multiplayer.get_unique_id(), selected_item_name, equipment_button_parent_name)

func _on_inventory_popup_pressed(id: int):
	match id:
		0:
			#print("Equip requested for ", selected_item_name, " from ", selected_slot)
			
			if !intermission: 
				if multiplayer.is_server():
					GameState_.add_to_peer_log(multiplayer.get_unique_id(), "[INFO] ❌Cannot equip item during duel!")
				else:
					GameState_.rpc_id(1, "add_to_peer_log", multiplayer.get_unique_id(), "[INFO] ❌Cannot equip item during duel!")
				return
			
			if multiplayer.is_server():
				GameState_.equip_item(multiplayer.get_unique_id(), selected_item_name)
			else:
				GameState_.rpc_id(1, "equip_item", multiplayer.get_unique_id(), selected_item_name)
			
			await get_tree().create_timer(0.2).timeout
			
		1:
			#print("Sell requested for ", selected_item_name, " from ", selected_slot)
			if multiplayer.is_server():
				GameState_.sell_from_inventory(multiplayer.get_unique_id(), selected_item_name)
			else:
				GameState_.rpc_id(1, "sell_from_inventory", multiplayer.get_unique_id(), selected_item_name)


func _on_equipment_item_pressed(item_name: String):
	# Store selected item info (you can make these class vars if needed)
	selected_item_name = item_name

	# Show popup near mouse
	equipment_popup.set_position(get_viewport().get_mouse_position())
	equipment_popup.popup()

func _on_inventory_item_pressed(item_name: String, slot_name: String):
	# Store selected item info (you can make these class vars if needed)
	selected_item_name = item_name
	selected_slot = slot_name

	# Show popup near mouse
	inventory_popup.set_position(get_viewport().get_mouse_position())
	inventory_popup.popup()

	
func clear_shop_grid():
	var tweens = []

	for child in shop_grid.get_children():
		# Skip cards that are already faded out (invisible)
		if child.modulate.a <= 0.05:
			child.queue_free()
			continue

		var tween := get_tree().create_tween()
		tween.tween_property(child, "modulate:a", 0.0, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween.tween_callback(func(): child.queue_free())
		tweens.append(tween)

	if tweens.size() > 0:
		await tweens[-1].finished

func get_all_cards():
	all_cards = [[strength_card, "strength", card_stock["strength"]], [health_card, "health", card_stock["health"]], 
		[criticality_card, "crit_rating", card_stock["crit_rating"]], [endurance_card, "endurance", card_stock["endurance"]], 
		[quickness_card, "quickness", card_stock["quickness"]], [resilience_card, "resilience", card_stock["resilience"]], 
		[avoidance_card, "avoidance", card_stock["avoidance"]], [weapon_mastery_card, "weapon_skill", card_stock["weapon_skill"]], 
		
		[simple_sword_card, "simple_sword", card_stock["simple_sword"]]]
	return all_cards

func roll_cards():
	#print("\n" + str(multiplayer.get_unique_id()) + "🃏reroll_cards: " + str(card_stock))
	
	all_cards = get_all_cards()
			
	var weighted_random_cards = weighted_random_selection(all_cards, 5)
	var i = 1
	for card in weighted_random_cards:
		var card_instance = card.instantiate()
		card_instance.set_multiplayer_authority(multiplayer.get_unique_id())
		card_instance.modulate.a = 0
		card_instance.scale = Vector2(0.8, 0.8)
		shop_grid.add_child(card_instance)

		var tween := get_tree().create_tween()
		tween.tween_property(card_instance, "modulate:a", 1.0, 0.3).set_delay(i * 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(card_instance, "scale", Vector2.ONE, 0.3).set_delay(i * 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)		
		i += 1

func reroll_cards():
	await clear_shop_grid()
	roll_cards()
	
	
func weighted_random_selection(_all_cards: Array, count: int = 5):
	var selected := []
	var pool := []

	# Step 1: Build a pool based on weights
	#print("\n" + str(multiplayer.get_unique_id()) + "🃏weighted_random_selection: " + str(_all_cards))
	for pair in _all_cards:
		var item = pair[0]
		var item_name = pair[1]
		var stock = int(pair[2])
		
		var item_dict = get_equipment_by_name(item_name)
		if item_dict != {}:
			# Only add cards that are below player level + 1
			if item_dict[item_name]["level"] > int(all_gladiators[multiplayer.get_unique_id()]["level"]) + 1: 
				continue
			
		for i in stock:
			pool.append(item)  # Add item 'stock' times

	# Step 2: Randomly pick items from the pool
	for i in count:
		if pool.is_empty():
			break
		var index := randi() % pool.size()
		selected.append(pool[index])
	
	return selected


func _on_refresh_button_pressed():
	#update_inventory_ui(multiplayer.get_unique_id())
	if is_refreshing:
		return
	is_refreshing = true
	refresh_button.disabled = true
	await reroll_cards()
	await get_tree().create_timer(0.8).timeout
	refresh_button.disabled = false
	is_refreshing = false

func _on_equipment_button_pressed():
	equipment_pressed = !equipment_pressed
	if equipment_pressed: 
		equipment_panel.visible = true
		attribute_panel.visible = true
	else: 
		equipment_panel.visible = false
		attribute_panel.visible = false

func _on_shop_button_pressed():
	shop_pressed = !shop_pressed
	if shop_pressed: shop.visible = true
	else: shop.visible = false
	#else: countdown_label.visible = true
	#pass # Replace with function body.

func _on_card_stock_initialized(new_attr_cards_stock: Dictionary): 
	card_stock = new_attr_cards_stock
	#print("\n" + str(multiplayer.get_unique_id()) + "🃏Start card stock: " + str(card_stock))

func _on_card_stock_changed(new_all_cards_stock: Dictionary): 
	card_stock = new_all_cards_stock
	#print("\n" + str(multiplayer.get_unique_id()) + "🃏_on_card_stock_changed: " + str(card_stock))
	
func _on_countdown_updated(time_left: int):
	if time_left > 0: intermission = true
	if intermission: 
		label_round.text = "Day " + str(round_now)
		if reroll_start_of_intermission:
			#print("New round!")
			#print("time_passed: " + str(time_passed))
			round_now += 1
			if time_passed > 5: reroll_cards()
			reroll_start_of_intermission = 0
		#update_countdown_labels(time_left)
		if countdown_label: countdown_label.text = "⏳ %d" % time_left
		
		if time_left == 0:
			reroll_start_of_intermission = 1
			intermission = false
			time_passed = 0
			await get_tree().create_timer(1.0).timeout
			countdown_label.text = ""
	
	
	
func get_visual_slot(peer_id: int) -> int:
	var peer_ids = GameState_.all_gladiators.keys()
	peer_ids.sort()  # Optional: ensures consistent display order

	var index = peer_ids.find(peer_id)
	if index == -1:
		return 1  # Fallback to Player1 if not found
	return index + 1  # HUD containers are named Player1–8

func _on_life_changed(peer_id: int, new_life: int):
	var container_name = "Player%d" % get_visual_slot(peer_id)
	var container = $GridContainer/VBoxContainer.get_node_or_null(container_name)
	if container == null:
		return

	life_label = container.get_node("PlayerLife")
	life_label.text = "❤️ %d" % new_life
	
func populate_hud():
	var peer_ids = all_gladiators.keys()
	peer_ids.sort()  # Optional but stable

	#print(str(multiplayer.get_unique_id()) + " is populating HUD")
	#print("Peers: " + str(peer_ids))

	for i in range(min(peer_ids.size(), 8)):  # Clamp to available HUD slots
		var peer_id = peer_ids[i]
		var gladiator_data = all_gladiators[peer_id]
		var container_name = "Player%d" % (i + 1)

		var player_container = $GridContainer/VBoxContainer.get_node_or_null(container_name)
		if player_container == null:
			push_warning("Missing container: %s" % container_name)
			continue

		name_label = player_container.get_node("PlayerInfo/PlayerName")
		race_label = player_container.get_node("PlayerInfo/PlayerRace")
		life_label = player_container.get_node("PlayerLife")

		#print(str(peer_id) + " gladiator_data[level]: " + all_gladiators[peer_id]["level"])
		
		name_label.text = str(gladiator_data.get("name", "Unknown"))
		race_label.text = str(gladiator_data.get("race", "???")) + "       Lvl " + all_gladiators[peer_id]["level"]
		life_label.text = "❤️ %d" % int(gladiator_data.get("player_life", 0))

func update_gold(amount: int):
	label_gold.text = "💰" + str(amount)

func update_experience(amount: int):
	if player_gladiator_data["level"] == max_lvl:
		label_xp.text = "       🔹" + "-"
	else: 
		label_xp.text = "       🔹" + str(amount) + "/" + str(exp_for_level[str(int(player_gladiator_data["level"])+1)]) + " Lv." + player_gladiator_data["level"]
