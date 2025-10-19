extends CanvasLayer

@onready var esc_menu = $EscMenu
@onready var resume_button = $EscMenu/Resume
@onready var options_button = $EscMenu/Options
@onready var disconnect_button = $EscMenu/Disconnect
@onready var confirm_disconnect = $EscMenu/ConfirmDisconnect

@onready var inventory_popup := $InventoryPopup
@onready var equipment_popup := $EquipmentPopup
@onready var craft_bench_popup := $CraftbenchPopup
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
@export var inspect_label: Node

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
@onready var stance_menu = $StancePanel/StanceMenu
@onready var attack_menu = $AttackPanel/AttackMenu
@onready var exp_button = $ExpButton

@onready var head_slot = $EquipmentPanel/HeadSlot
@onready var chest_slot = $EquipmentPanel/ChestSlot
@onready var shoulders_slot = $EquipmentPanel/ShouldersSlot
@onready var weapon1_slot = $EquipmentPanel/Weapon1Slot
@onready var weapon2_slot = $EquipmentPanel/Weapon2Slot
@onready var ring1_slot = $EquipmentPanel/Ring1Slot
@onready var ring2_slot = $EquipmentPanel/Ring2Slot

@onready var attribute_panel = $AttributePanel
@onready var health_panel = $AttributePanel/VBoxContainer/Health
@onready var strength_panel = $AttributePanel/VBoxContainer/Strength
@onready var endurance_panel = $AttributePanel/VBoxContainer/Endurance
@onready var criticality_panel = $AttributePanel/VBoxContainer/Criticality
@onready var avoidance_panel = $AttributePanel/VBoxContainer/Avoidance
@onready var quickness_panel = $AttributePanel/VBoxContainer/Quickness
@onready var resilience_panel = $AttributePanel/VBoxContainer/Resilience
@onready var sword_mastery_panel = $AttributePanel/VBoxContainer/SwordMastery
@onready var axe_mastery_panel = $AttributePanel/VBoxContainer/AxeMastery
@onready var dagger_mastery_panel = $AttributePanel/VBoxContainer/DaggerMastery
@onready var hammer_mastery_panel = $AttributePanel/VBoxContainer/HammerMastery
@onready var chain_mastery_panel = $AttributePanel/VBoxContainer/ChainMastery
@onready var shield_mastery_panel = $AttributePanel/VBoxContainer/ShieldMastery
@onready var unarmed_mastery_panel = $AttributePanel/VBoxContainer/UnarmedMastery

@onready var tome_of_chaos = $CraftingContainer/CraftingMats/TomeOfChaos
@onready var tome_of_injection = $CraftingContainer/CraftingMats/TomeOfInjection
@onready var crafting_bench = $CraftingContainer/CraftingBench
@onready var crafting_container = $CraftingContainer

var physique_limits = {"Low": 70, "Good": 140, "Excellent": 210, "Outstanding": 280, "Legendary": 350}
var agility_limits = {"Low": 60, "Good": 120, "Excellent": 180, "Outstanding": 240, "Legendary": 300}
var weight_limits = {"Weightless": 10, "Lightweight": 18, "Midweight": 28, "Heavyweight": 36, "Massive": 48}

var exp_for_level = {"1": 0, "2": 10, "3": 12, "4": 14, "5": 18, "6": 22, "7": 26, "8": 30, "9": 34, "10": 36}
var max_lvl

var equipment_script 
var equipment_instance
var equipment_data 
#@onready var all_equipment_slots = [head_slot, chest_slot, weapon1_slot, weapon2_slot, ring1_slot, ring2_slot]
signal concede_threshold_changed(value: int)
signal stance_changed(value: int)
signal attack_changed(value: int)
var craft_active = ""

@onready var strength_card = preload("res://ShopCards/AttributeCards/StrengthCard.tscn")
@onready var health_card = preload("res://ShopCards/AttributeCards/HealthCard.tscn")
@onready var avoidance_card = preload("res://ShopCards/AttributeCards/AvoidanceCard.tscn")
@onready var criticality_card = preload("res://ShopCards/AttributeCards/CriticalityCard.tscn")
@onready var endurance_card = preload("res://ShopCards/AttributeCards/EnduranceCard.tscn")
@onready var quickness_card = preload("res://ShopCards/AttributeCards/QuicknessCard.tscn")
@onready var resilience_card = preload("res://ShopCards/AttributeCards/ResilienceCard.tscn")
@onready var sword_mastery_card = preload("res://ShopCards/AttributeCards/SwordMasteryCard.tscn")
@onready var axe_mastery_card = preload("res://ShopCards/AttributeCards/AxeMasteryCard.tscn")
@onready var shield_mastery_card = preload("res://ShopCards/AttributeCards/ShieldMasteryCard.tscn")
@onready var hammer_mastery_card = preload("res://ShopCards/AttributeCards/HammerMasteryCard.tscn")
@onready var dagger_mastery_card = preload("res://ShopCards/AttributeCards/DaggerMasteryCard.tscn")
@onready var chain_mastery_card = preload("res://ShopCards/AttributeCards/ChainMasteryCard.tscn")

@onready var tome_of_chaos_card = preload("res://ShopCards/CraftCards/TomeOfChaosCard.tscn")
@onready var tome_of_injection_card = preload("res://ShopCards/CraftCards/TomeOfInjectionCard.tscn")

@onready var simple_sword_card = preload("res://ShopCards/EquipmentCards/Sword/1h/SimpleSword.tscn")
@onready var light_axe_card = preload("res://ShopCards/EquipmentCards/Axe/1h/LightAxe.tscn")
@onready var wooden_buckler_card = preload("res://ShopCards/EquipmentCards/Shield/WoodenBuckler.tscn")
@onready var sturdy_blade_card = preload("res://ShopCards/EquipmentCards/Sword/2h/SturdyBlade.tscn")

@onready var padded_tunic_card = preload("res://ShopCards/EquipmentCards/Chest/PaddedTunic.tscn")
@onready var chain_mail_shirt_card = preload("res://ShopCards/EquipmentCards/Chest/ChainMailShirt.tscn")
@onready var iron_plate_card = preload("res://ShopCards/EquipmentCards/Chest/IronPlate.tscn")
@onready var leather_vest_card = preload("res://ShopCards/EquipmentCards/Chest/LeatherVest.tscn")
@onready var obsidian_bulwark_card = preload("res://ShopCards/EquipmentCards/Chest/ObsidianBulwark.tscn")
@onready var reinforced_leather_vest_card = preload("res://ShopCards/EquipmentCards/Chest/ReinforcedLeatherVest.tscn")

@onready var padded_hood_card = preload("res://ShopCards/EquipmentCards/Head/PaddedHood.tscn")
@onready var chain_mail_coif_card = preload("res://ShopCards/EquipmentCards/Head/ChainMailCoif.tscn")
@onready var iron_helm_card = preload("res://ShopCards/EquipmentCards/Head/IronHelm.tscn")
@onready var leather_cap_card = preload("res://ShopCards/EquipmentCards/Head/LeatherCap.tscn")
@onready var obsidian_mask_card = preload("res://ShopCards/EquipmentCards/Head/ObsidianMask.tscn")
@onready var reinforced_leather_cap_card = preload("res://ShopCards/EquipmentCards/Head/ReinforcedLeatherCap.tscn")

@onready var padded_wraps_card = preload("res://ShopCards/EquipmentCards/Shoulders/PaddedWraps.tscn")
@onready var chain_mail_shoulderguards_card = preload("res://ShopCards/EquipmentCards/Shoulders/ChainMailShoulderguards.tscn")
@onready var iron_shoulders_card = preload("res://ShopCards/EquipmentCards/Shoulders/IronShoulders.tscn")
@onready var leather_pads_card = preload("res://ShopCards/EquipmentCards/Shoulders/LeatherPads.tscn")
@onready var obsidian_spikes_card = preload("res://ShopCards/EquipmentCards/Shoulders/ObsidianSpikes.tscn")
@onready var reinforced_leather_pads_card = preload("res://ShopCards/EquipmentCards/Shoulders/ReinforcedLeatherPads.tscn")

@onready var thin_ring_card = preload("res://ShopCards/EquipmentCards/Ring/ThinRing.tscn")

func _ready():
	esc_menu.visible = false
	confirm_disconnect.visible = false
	#refresh_button.visible = false
	equipment_script = load("res://Equipment.gd")
	equipment_instance = equipment_script.new()
	equipment_data = equipment_instance.all_equipment
	#print(equipment_data)
	
	GameState_.connect("gladiator_life_changed", Callable(self, "_on_life_changed"))
	GameState_.connect("countdown_updated", Callable(self, "_on_countdown_updated"))
	GameState_.connect("card_stock_changed", Callable(self, "_on_card_stock_changed"))
	GameState_.connect("send_gladiator_data_to_peer_signal", Callable(self, "_on_send_gladiator_data_to_peer_signal"))
	GameState_.connect("broadcast_log_signal", Callable(self, "_on_log_received"))	
	GameState_.connect("reroll_cards_new_round_signal", Callable(self, "_on_reroll_cards_new_round_signal"))	
	
	GameState_.connect("add_item_to_inventory_signal", Callable(self, "_on_add_item_to_inventory"))
	GameState_.connect("remove_item_from_inventory_signal", Callable(self, "_on_remove_item_from_inventory"))
	GameState_.connect("add_item_to_equipment_signal", Callable(self, "_on_add_item_to_equipment"))
	GameState_.connect("remove_item_from_equipment_signal", Callable(self, "_on_remove_item_from_equipment"))
	

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
	
	craft_bench_popup.clear()
	craft_bench_popup.add_item("Move to inventory", 0)
	craft_bench_popup.id_pressed.connect(_on_craft_bench_popup_pressed)

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
	refresh_button.disabled = false
	
	concede_threshold_menu.connect("item_selected", Callable(self, "_on_threshold_selected"))
	stance_menu.connect("item_selected", Callable(self, "_on_stance_selected"))
	attack_menu.connect("item_selected", Callable(self, "_on_attack_type_selected"))
	
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
	if intermission: 
		concede_threshold_menu.disabled = false
		stance_menu.disabled = false
		attack_menu.disabled = false
	else: 
		concede_threshold_menu.disabled = true
		stance_menu.disabled = true
		attack_menu.disabled = true
	
	if Input.is_action_just_pressed("focus_chat"):# and not chat_input.has_focus():
		chat_input.grab_focus()
	if Input.is_action_just_pressed("toggle_shop") and not chat_input.has_focus():
		if $ShopButton:
			$ShopButton.emit_signal("pressed")
	if Input.is_action_just_pressed("toggle_equipment") and not chat_input.has_focus():
		if $EquipmentButton:
			$EquipmentButton.emit_signal("pressed")
	if Input.is_action_just_pressed("refresh_cards") and not chat_input.has_focus():
		if $EquipmentButton:
			$Shop/VBoxContainer/HBoxContainer/RefreshButton.emit_signal("pressed")
	if Input.is_action_just_pressed("buy_exp") and not chat_input.has_focus():
		if $ExpButton:
			$ExpButton.emit_signal("button_up")
	
func _unhandled_input(event):
	
	if event.is_action_pressed("ui_cancel"):  # ESC by default
		if esc_menu.visible:
			esc_menu.visible = false
		else:
			esc_menu.visible = true
	
func get_all_cards():
	all_cards = [
		### ATTRIBUTES ###
		[strength_card, "strength", card_stock["strength"]], [health_card, "health", card_stock["health"]], 
		[criticality_card, "crit_rating", card_stock["crit_rating"]], [endurance_card, "endurance", card_stock["endurance"]], 
		[quickness_card, "quickness", card_stock["quickness"]], [resilience_card, "resilience", card_stock["resilience"]], 
		[avoidance_card, "avoidance", card_stock["avoidance"]], 
		
		### CRAFTING MATERIALS ###
		[tome_of_chaos_card, "tome_of_chaos", card_stock["tome_of_chaos"]], [tome_of_injection_card, "tome_of_injection", card_stock["tome_of_injection"]],
		
		### WEAPON MASTERY ###
		[sword_mastery_card, "sword_mastery", card_stock["sword_mastery"]], [axe_mastery_card, "axe_mastery", card_stock["axe_mastery"]],
		[shield_mastery_card, "shield_mastery", card_stock["shield_mastery"]], [dagger_mastery_card, "dagger_mastery", card_stock["dagger_mastery"]],
		[chain_mastery_card, "chain_mastery", card_stock["chain_mastery"]], [hammer_mastery_card, "hammer_mastery", card_stock["hammer_mastery"]],
		
		### CHESTS ###
		[padded_tunic_card, "padded_tunic", card_stock["padded_tunic"]], [chain_mail_shirt_card, "chain_mail_shirt", card_stock["chain_mail_shirt"]],
		[iron_plate_card, "iron_plate", card_stock["iron_plate"]], [leather_vest_card, "leather_vest", card_stock["leather_vest"]],
		[obsidian_bulwark_card, "obsidian_bulwark", card_stock["obsidian_bulwark"]], [reinforced_leather_vest_card, "reinforced_leather_vest", card_stock["reinforced_leather_vest"]],
		
		### HEADS ###
		[padded_hood_card, "padded_hood", card_stock["padded_hood"]], [chain_mail_coif_card, "chain_mail_coif", card_stock["chain_mail_coif"]],
		[iron_helm_card, "iron_helm", card_stock["iron_helm"]], [leather_cap_card, "leather_cap", card_stock["leather_cap"]],
		[obsidian_mask_card, "obsidian_mask", card_stock["obsidian_mask"]], [reinforced_leather_cap_card, "reinforced_leather_cap", card_stock["reinforced_leather_cap"]],
		
		### SHOULDER ###
		[padded_wraps_card, "padded_wraps", card_stock["padded_wraps"]], [chain_mail_shoulderguards_card, "chain_mail_shoulderguards", card_stock["chain_mail_shoulderguards"]],
		[iron_shoulders_card, "iron_shoulders", card_stock["iron_shoulders"]], [leather_pads_card, "leather_pads", card_stock["leather_pads"]],
		[obsidian_spikes_card, "obsidian_spikes", card_stock["obsidian_spikes"]], [reinforced_leather_pads_card, "reinforced_leather_pads", card_stock["reinforced_leather_pads"]],

		### WEAPONS ###
		[simple_sword_card, "simple_sword", card_stock["simple_sword"]], [light_axe_card, "light_axe", card_stock["light_axe"]],
		[wooden_buckler_card, "wooden_buckler", card_stock["wooden_buckler"]], [sturdy_blade_card, "sturdy_blade", card_stock["sturdy_blade"]],
		
		### RINGS ###
		[thin_ring_card, "thin_ring", card_stock["thin_ring"]],
		]
	return all_cards
	
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

	if event is InputEventMouseButton and craft_active != "":
		await get_tree().create_timer(0.1).timeout
		tome_of_chaos.button_pressed = false
		tome_of_chaos.release_focus()
		tome_of_injection.button_pressed = false
		tome_of_injection.release_focus()
	
func _on_send_pressed(submitted_text = ""):
	var msg = chat_input.text.strip_edges()
	if msg.length() == 0 or msg.length() > MAX_LENGTH:
		return

	var sender_id = get_tree().get_multiplayer().get_unique_id()
	var now = Time.get_datetime_dict_from_system()
	var timestamp = "[%02d:%02d]" % [now.hour, now.minute]
	var name = all_gladiators[multiplayer.get_unique_id()]["name"]

	chat_input.clear()
	rpc("broadcast_message", sender_id, name, timestamp, msg)


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

func _on_add_item_to_equipment(id, item_dict, category):
	if multiplayer.get_unique_id() != id: return
	
	var item_slot
	var card_scene_map := {}
	for card in all_cards:
		card_scene_map[card[1]] = card[0]  # card[1] is name, card[0] is scene
	
	var item_name = item_dict.keys()[0]
	var hands = item_dict[item_name].get("hands", -1)

	# Find corresponding scene
	if card_scene_map.has(item_name):
		var card_instance = card_scene_map[item_name].instantiate()
		
		if hands == 2 and get_node("EquipmentPanel/Weapon1Slot").get_children() == [] and get_node("EquipmentPanel/Weapon2Slot").get_children() == []:
			item_slot = get_node("EquipmentPanel/Weapon1Slot")
			$EquipmentPanel/Weapon2Slot.visible = false
		
		elif hands == 1 and category in ["weapon1", "weapon2"]:
			item_slot = get_node("EquipmentPanel/Weapon" + category[-1] + "Slot")
			
		elif category in ["ring1", "ring2"]:
			item_slot = get_node("EquipmentPanel/Ring" + category[-1] + "Slot")
			
		else: 
			item_slot = $EquipmentPanel.find_child(category.capitalize()+"Slot", true, false)
		
		card_instance.button_parent.connect(_on_equipment_pressed)
		card_instance.pressed.connect(_on_equipment_item_pressed.bind(item_name, category))
		card_instance.set_multiplayer_authority(multiplayer.get_unique_id())
		item_slot.add_child(card_instance)
		card_instance.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		card_instance.custom_minimum_size = item_slot.size
		
	else:
		print("⚠️ No matching scene for item:", item_name)

func _on_add_item_to_inventory(id, item_dict, slot_name):
	if id != multiplayer.get_unique_id():
		return
	#print("_on_add_item_to_inventory")
	var card_scene_map := {}
	for card in all_cards:
		card_scene_map[card[1]] = card[0]  # card[1] is name, card[0] is scene
	
	var item_name = item_dict.keys()[0]

	# Find corresponding scene
	if card_scene_map.has(item_name):
		var card_instance = card_scene_map[item_name].instantiate()
		card_instance.button_down.connect(_on_inventory_item_pressed.bind(item_name, slot_name))
		card_instance.set_multiplayer_authority(multiplayer.get_unique_id())  # Optional, for sync
		$Inventory/InventoryGridContainer.find_child(slot_name, true, false).add_child(card_instance)
	else:
		print("⚠️ No matching scene for item:", item_name)


func _on_remove_item_from_equipment(id, item_dict, category):
	if multiplayer.get_unique_id() != id: return
	var item_slot
	
	var item_name = item_dict.keys()[0]
	var hands = item_dict[item_name].get("hands", -1)
	
	if hands == 2:
		item_slot = get_node("EquipmentPanel/Weapon1Slot")
		$EquipmentPanel/Weapon2Slot.visible = true
	
	elif hands == 1 and category in ["weapon1", "weapon2"]:
		item_slot = get_node("EquipmentPanel/Weapon" + category[-1] + "Slot")
		
	elif category in ["ring1", "ring2"]:
		item_slot = get_node("EquipmentPanel/Ring" + category[-1] + "Slot")
		
	else: 
		item_slot = $EquipmentPanel.find_child(category.capitalize()+"Slot", true, false)
	
	item_slot.get_child(0).queue_free()

func _on_remove_item_from_inventory(id, _item_dict, slot_name):
	if multiplayer.get_unique_id() != id: return
	$Inventory/InventoryGridContainer.find_child(slot_name, true, false).get_child(0).queue_free()
	
func _on_send_gladiator_data_to_peer_signal(peer_id: int, _player_gladiator_data: Dictionary, _all_gladiators):
	all_gladiators = _all_gladiators
	if peer_id == multiplayer.get_unique_id():
		player_gladiator_data = all_gladiators[peer_id]
		update_craft_ui()
		#update_inventory_ui(peer_id)
		#update_equipment_ui()
		update_attribute_ui()
		update_concede_ui()
		update_stance_ui()
		update_attack_ui()
		update_gold(all_gladiators[peer_id]["gold"])
		update_experience(all_gladiators[peer_id]["exp"])
	populate_hud()
	
func update_craft_ui():
	var crafting_mats = all_gladiators[multiplayer.get_unique_id()].get("crafting_mats", {})
	
	if crafting_mats["tome_of_chaos"] == 0:
		tome_of_chaos.get_child(0).text = ""
		tome_of_chaos.disabled = true
	else:
		tome_of_chaos.get_child(0).text = str(crafting_mats["tome_of_chaos"])
		tome_of_chaos.disabled = false

	if crafting_mats["tome_of_injection"] == 0:
		tome_of_injection.get_child(0).text = ""
		tome_of_injection.disabled = true
	else:
		tome_of_injection.get_child(0).text = str(crafting_mats["tome_of_injection"])
		tome_of_injection.disabled = false
	
func update_stance_ui():
	var previous_index = stance_menu.get_selected_id()
	var options = ["Normal", 
					"Defensive", 
					"Offensive", 
					"Jester"]
	stance_menu.clear()
	for option in options: stance_menu.add_item(option)
	if previous_index == -1: stance_menu.select(0)
	else: stance_menu.select(previous_index)
	
func update_attack_ui():
	var previous_index = attack_menu.get_selected_id()
	var options = ["Normal", 
					"Light", 
					"Heavy"]
	attack_menu.clear()
	for option in options: attack_menu.add_item(option)
	if previous_index == -1: attack_menu.select(0)
	else: attack_menu.select(previous_index)
	
func update_concede_ui():
	var previous_index = concede_threshold_menu.get_selected_id()
	#print(previous_index)
	var attributes = all_gladiators[multiplayer.get_unique_id()].get("attributes", {})
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
	var attributes = all_gladiators[multiplayer.get_unique_id()].get("attributes", {})
	health_panel.text = "Health: " + str(int(attributes["health"]))
	strength_panel.text = "Strength: " + str(int(attributes["strength"]))
	endurance_panel.text = "Endurance: " + str(int(attributes["endurance"]))
	criticality_panel.text = "Criticality: " + str(int(attributes["crit_rating"]))
	avoidance_panel.text = "Avoidance: " + str(int(attributes["avoidance"]))
	quickness_panel.text = "Quickness: " + str(int(attributes["quickness"]))
	resilience_panel.text = "Resilience: " + str(int(attributes["resilience"]))
	sword_mastery_panel.text = "Sword Mastery: " + str(int(attributes["sword_mastery"]))
	axe_mastery_panel.text = "Axe Mastery: " + str(int(attributes["axe_mastery"]))
	dagger_mastery_panel.text = "Dagger Mastery: " + str(int(attributes["dagger_mastery"]))
	hammer_mastery_panel.text = "Hammer Mastery: " + str(int(attributes["hammer_mastery"]))
	chain_mastery_panel.text = "Chain Mastery: " + str(int(attributes["chain_mastery"]))
	shield_mastery_panel.text = "Shield Mastery: " + str(int(attributes["shield_mastery"]))
	unarmed_mastery_panel.text = "Unarmed: " + str(int(attributes["unarmed_mastery"]))
	
func update_equipment_ui(): 
	for slot in equipment_panel.get_children():
		for i in slot.get_children():
			i.queue_free()
			
	var head_name
	var chest_name 
	var shoulders_name
	var weapon1_name
	var weapon2_name
	var ring1_name 
	var ring2_name 
	
	if all_gladiators[multiplayer.get_unique_id()]["head"] != {}:
		head_name = all_gladiators[multiplayer.get_unique_id()]["head"].keys()[0]
	else:
		head_name = "empty"
	
	if all_gladiators[multiplayer.get_unique_id()]["shoulders"] != {}:
		shoulders_name = all_gladiators[multiplayer.get_unique_id()]["shoulders"].keys()[0]
	else:
		shoulders_name = "empty"
	
	if all_gladiators[multiplayer.get_unique_id()]["chest"] != {}:
		chest_name = all_gladiators[multiplayer.get_unique_id()]["chest"].keys()[0]
	else:
		chest_name = "empty"
	
	if all_gladiators[multiplayer.get_unique_id()]["weapon1"] != {}:
		weapon1_name = all_gladiators[multiplayer.get_unique_id()]["weapon1"].keys()[0]
	else:
		weapon1_name = "empty"
		
	if all_gladiators[multiplayer.get_unique_id()]["weapon1"] != {}:
		weapon1_name = all_gladiators[multiplayer.get_unique_id()]["weapon1"].keys()[0]
	else:
		weapon1_name = "empty"
		
	if all_gladiators[multiplayer.get_unique_id()]["weapon2"] != {}:
		weapon2_name = all_gladiators[multiplayer.get_unique_id()]["weapon2"].keys()[0]
	else:
		weapon2_name = "empty"
		
	if all_gladiators[multiplayer.get_unique_id()]["ring1"] != {}:
		ring1_name = all_gladiators[multiplayer.get_unique_id()]["ring1"].keys()[0]
	else:
		ring1_name = "empty"
	
	if all_gladiators[multiplayer.get_unique_id()]["ring2"] != {}:
		ring2_name = all_gladiators[multiplayer.get_unique_id()]["ring2"].keys()[0]
	else:
		ring2_name = "empty"
	
	var all_equipment_slots = [head_slot, chest_slot, shoulders_slot, weapon1_slot, weapon2_slot, ring1_slot, ring2_slot]
	var all_equipped_items_name = [head_name, chest_name, shoulders_name, weapon1_name, weapon2_name, ring1_name, ring2_name]
	
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
	var gladiator_inventory = all_gladiators[glad_id]["inventory"]
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

func _on_attack_type_selected(index: int):
	var selected_text = attack_menu.get_item_text(index)
	var type = ""
	
	if selected_text == "Normal": type = "normal"
	elif selected_text == "Light": type = "light"
	elif selected_text == "Heavy": type = "heavy"
	
	if multiplayer.is_server():
		GameState_.peer_attack_type(multiplayer.get_unique_id(), type)
	else:
		GameState_.rpc_id(1, "peer_attack_type", multiplayer.get_unique_id(), type)


func _on_stance_selected(index: int): 
	var selected_text = stance_menu.get_item_text(index)
	var stance = ""
	
	if selected_text == "Normal": stance = "normal"
	elif selected_text == "Defensive": stance = "defensive"
	elif selected_text == "Offensive": stance = "offensive"
	elif selected_text == "Jester": stance = "jester"
	
	if multiplayer.is_server():
		GameState_.peer_stance(multiplayer.get_unique_id(), stance)
	else:
		GameState_.rpc_id(1, "peer_stance", multiplayer.get_unique_id(), stance)

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
				GameState_.unequip_item(multiplayer.get_unique_id(), selected_item_name, equipment_button_parent_name, selected_slot)
			else:
				GameState_.rpc_id(1, "unequip_item", multiplayer.get_unique_id(), selected_item_name, equipment_button_parent_name, selected_slot)
			
			
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
				GameState_.sell_from_equipment(multiplayer.get_unique_id(), selected_item_name, equipment_button_parent_name, selected_slot)
			else:
				GameState_.rpc_id(1, "sell_from_equipment", multiplayer.get_unique_id(), selected_item_name, equipment_button_parent_name, selected_slot)

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
				GameState_.equip_item(multiplayer.get_unique_id(), selected_item_name, selected_slot)
			else:
				GameState_.rpc_id(1, "equip_item", multiplayer.get_unique_id(), selected_item_name, selected_slot)
			
			await get_tree().create_timer(0.2).timeout
			
		1:
			#print("Sell requested for ", selected_item_name, " from ", selected_slot)
			if multiplayer.is_server():
				GameState_.sell_from_inventory(multiplayer.get_unique_id(), selected_item_name, selected_slot)
			else:
				GameState_.rpc_id(1, "sell_from_inventory", multiplayer.get_unique_id(), selected_item_name, selected_slot)


func _on_craft_bench_popup_pressed(id: int):
	match id:
		0: 1
			
	

func _on_equipment_item_pressed(item_name: String, category):
	# Store selected item info (you can make these class vars if needed)
	selected_slot = category
	selected_item_name = item_name

	# Show popup near mouse
	equipment_popup.set_position(get_viewport().get_mouse_position())
	equipment_popup.popup()

func _on_inventory_item_pressed(item_name: String, slot_name: String):
	#print(card_instance)
	selected_item_name = item_name
	selected_slot = slot_name
	#print("\nslot1: " + str(all_gladiators[multiplayer.get_unique_id()]["inventory"]["slot1"]))
	#print("slot2: " + str(all_gladiators[multiplayer.get_unique_id()]["inventory"]["slot2"]))
	#print("slot3: " + str(all_gladiators[multiplayer.get_unique_id()]["inventory"]["slot3"]))
	#print("slot4: " + str(all_gladiators[multiplayer.get_unique_id()]["inventory"]["slot4"]))
	#print("Pressed " + str(selected_slot))

	# Show popup near mouse

	
	if craft_active:
		print("Requesting to use " + craft_active + " on " + selected_item_name)
		
		if multiplayer.is_server():
			GameState_.use_craft_mat_on_item(multiplayer.get_unique_id(), craft_active, selected_item_name, selected_slot)
		else:
			GameState_.rpc_id(1, "use_craft_mat_on_item", multiplayer.get_unique_id(), craft_active, selected_item_name, selected_slot)
			
		tome_of_chaos.button_pressed = false
		tome_of_injection.button_pressed = false
		craft_active = ""
	else:
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


func roll_cards():
	#if multiplayer.is_server(): return
	#print("\n" + str(multiplayer.get_unique_id()) + "🃏reroll_cards: " + str(card_stock))
	
	all_cards = get_all_cards()
			
	var weighted_random_cards = weighted_random_selection(all_cards, 5)
	var i = 1
	for card in weighted_random_cards:
		var card_instance = card.instantiate()
		card_instance.set_multiplayer_authority(multiplayer.get_unique_id())
		card_instance.modulate.a = 0
		card_instance.scale = Vector2(0.8, 0.8)
		#card_instance.unique_id = str(card_instance)
		shop_grid.add_child(card_instance)
		var tween := get_tree().create_tween()
		tween.tween_property(card_instance, "modulate:a", 1.0, 0.3).set_delay(i * 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(card_instance, "scale", Vector2.ONE, 0.3).set_delay(i * 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)		
		i += 1
		#await get_tree().create_timer(0.5).timeout

func _on_reroll_cards_new_round_signal(active_players: Array):
	#if !multiplayer.is_server():
	#print("Received active players from host: " + str(active_players))
	await get_tree().process_frame 
	for player in active_players:
		if multiplayer.get_unique_id() == player:
			reroll_cards()

func reroll_cards():
	#if multiplayer.is_server(): return
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
		#print("item_dict: " + str(item_dict))
		#print("all_gladiators: " + str(all_gladiators))
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
	if refresh_button.disabled:
		return
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
			round_now += 1
			reroll_start_of_intermission = 0
		#update_countdown_labels(time_left)
		if countdown_label: countdown_label.text = "⏳ %d" % time_left
		
		if time_left == 0:
			reroll_start_of_intermission = 1
			#intermission = false
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
		#if peer_id == 1: continue
		var gladiator_data = all_gladiators[peer_id]
		var container_name = "Player%d" % (i + 1)

		var player_container = $GridContainer/VBoxContainer.get_node_or_null(container_name)
		if player_container == null:
			push_warning("Missing container: %s" % container_name)
			continue

		name_label = player_container.get_node("PlayerInfo/PlayerName")
		race_label = player_container.get_node("PlayerInfo/PlayerRace")
		life_label = player_container.get_node("PlayerLife")
		inspect_label = player_container.get_node("Inspect")
		#print(str(peer_id) + " gladiator_data[level]: " + all_gladiators[peer_id]["level"])
		
		name_label.text = str(gladiator_data.get("name", "Unknown"))
		race_label.text = str(gladiator_data.get("race", "???")) + "       Lvl " + all_gladiators[peer_id]["level"]
		life_label.text = "❤️ %d" % int(gladiator_data.get("player_life", 0))
		inspect_label.text = "🔎"
		
		
		var strength = all_gladiators[peer_id]["attributes"]["strength"]
		var quickness = all_gladiators[peer_id]["attributes"]["quickness"]
		var crit_rating = all_gladiators[peer_id]["attributes"]["crit_rating"]
		var avoidance = all_gladiators[peer_id]["attributes"]["avoidance"]
		var health = all_gladiators[peer_id]["attributes"]["health"]
		var resilience = all_gladiators[peer_id]["attributes"]["resilience"]
		var endurance = all_gladiators[peer_id]["attributes"]["endurance"]
		var sword_mastery = all_gladiators[peer_id]["attributes"]["sword_mastery"]
		var axe_mastery = all_gladiators[peer_id]["attributes"]["axe_mastery"]
		var hammer_mastery = all_gladiators[peer_id]["attributes"]["hammer_mastery"]
		var dagger_mastery = all_gladiators[peer_id]["attributes"]["dagger_mastery"]
		var chain_mastery = all_gladiators[peer_id]["attributes"]["chain_mastery"]
		var shield_mastery = all_gladiators[peer_id]["attributes"]["shield_mastery"]
		var unarmed_mastery = all_gladiators[peer_id]["attributes"]["unarmed_mastery"]
		
		var weapon1_name = all_gladiators[peer_id]["weapon1"].keys()[0]
		var weapon2_name = all_gladiators[peer_id]["weapon2"].keys()[0]
		var hands = all_gladiators[peer_id]["weapon1"][weapon1_name]["hands"]
		
		var weight = all_gladiators[peer_id]["weight"]
		var physique = strength + health + endurance/2
		var agility = [quickness, crit_rating/2, avoidance, sword_mastery/3, axe_mastery/3, hammer_mastery/3, 
						dagger_mastery/3, chain_mastery/3, shield_mastery/3, unarmed_mastery/3].reduce(func(a, b): return a + b)
		
		var gladiator_physique_class
		for physique_class in physique_limits.keys():
			if physique <= physique_limits[physique_class]:
				gladiator_physique_class = physique_class
				break
			else: physique_class = "Legendary"
		
		var gladiator_agility_class
		for agility_class in agility_limits.keys():
			if agility <= agility_limits[agility_class]:
				gladiator_agility_class = agility_class
				break
			else: gladiator_agility_class = "Legendary"
		
		var gladiator_weight_class
		for weight_class in weight_limits.keys():
			if weight <= weight_limits[weight_class]:
				gladiator_weight_class = weight_class
				break
			else: gladiator_weight_class = "Massive"
		
		var inspect_text = ""
		if hands == 2: inspect_text += format_name(weapon1_name)
		else: inspect_text += format_name(weapon1_name) + "  |  " + format_name(weapon2_name)
		inspect_text +=  "\nPhysique: %s \nAgility: %s \nWeight: %s" % [gladiator_physique_class, gladiator_agility_class, gladiator_weight_class]

		inspect_label.tooltip_text = inspect_text
func update_gold(amount: int):
	label_gold.text = "💰" + str(amount)

func update_experience(amount: int):
	if all_gladiators[multiplayer.get_unique_id()]["level"] == max_lvl:
		label_xp.text = "       🔹" + "-"
	else: 
		label_xp.text = "       🔹" + str(amount) + "/" + str(exp_for_level[str(int(all_gladiators[multiplayer.get_unique_id()]["level"])+1)]) + " Lv." + all_gladiators[multiplayer.get_unique_id()]["level"]

func _on_exp_button_button_up():
	var amount = 4
	var cost = 5
	if multiplayer.is_server():
		GameState_.grant_exp_for_peer(multiplayer.get_unique_id(), amount, cost)
	else:
		GameState_.rpc_id(1, "grant_exp_for_peer", multiplayer.get_unique_id(), amount, cost)

func format_name(raw_name: String) -> String:
	var parts = raw_name.split("_")            # → ["simple", "sword"]
	var joined = ""                            
	for i in parts.size():
		joined += parts[i]
		if i < parts.size() - 1:
			joined += " "
	return joined.capitalize()                 # → "Simple Sword"


func _on_resume_pressed() -> void:
	esc_menu.visible = false

func _on_options_pressed() -> void:
	print("Options not implemented yet.")

func _on_disconnect_pressed() -> void:
	resume_button.visible = false
	options_button.visible = false
	disconnect_button.visible = false
	confirm_disconnect.visible = true

func _on_yes_button_up() -> void:
	if !multiplayer.is_server():
		var gladiator = all_gladiators.get(multiplayer.get_unique_id(), {})
		if gladiator == {}:
			var color = gladiator.get("color", Color.WHITE)
			var hex_color = color.to_html()
			var formatted = "[color=%s]%s[/color][color=%s] disconnected![/color]" % [hex_color, GameState_.selected_name, Color.RED.to_html()]
			rpc("broadcast_message", multiplayer.get_unique_id(), formatted)
			
		await get_tree().create_timer(1.0).timeout # 11
		
		NetworkManager_.leave_game()
		multiplayer.multiplayer_peer.close()
		get_tree().set_multiplayer(null)
		get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
	else: 
		var gladiator = all_gladiators.get(multiplayer.get_unique_id(), {})
		if gladiator == {}:
			var color = gladiator.get("color", Color.WHITE)
			var hex_color = color.to_html()
			var formatted = "[color=%s]%s[/color][color=%s] (host) disconnected![/color]" % [hex_color, GameState_.selected_name, Color.RED.to_html()]
			rpc("broadcast_message", multiplayer.get_unique_id(), formatted)
			await get_tree().create_timer(1.0).timeout # 11
			
		GameState_.erase_all_data()
		
		NetworkManager_.leave_game()
		multiplayer.multiplayer_peer.close()
		get_tree().set_multiplayer(null)
		get_tree().change_scene_to_file("res://UI/MainMenu.tscn")

func _on_no_button_up() -> void:
	resume_button.visible = true
	options_button.visible = true
	disconnect_button.visible = true
	confirm_disconnect.visible = false

func enable_craft_with_material(crafting_mat, toggled_on):
	
	if toggled_on: 
		print("Started crafting with " + crafting_mat)
		craft_active = crafting_mat
	else: 
		print("Stopped crafting with " + crafting_mat)
		craft_active = ""
	


func _on_tome_of_chaos_toggled(toggled_on: bool):
	enable_craft_with_material("tome_of_chaos", toggled_on)
	


func _on_tome_of_injection_toggled(toggled_on: bool) -> void:
	enable_craft_with_material("tome_of_injection", toggled_on)
