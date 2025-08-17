extends Control
class_name AttributeAllocation

signal confirmed(attributes: Dictionary)

@export var max_points := 148
@export var starting_values: Dictionary = {}

const MAX_MESSAGES = 50
const MAX_LENGTH = 255
var player_gladiator_data
var all_gladiators
var player_colors

var empty: Dictionary
var head: Dictionary
var shoulder: Dictionary
var chest: Dictionary
var ring1: Dictionary
var ring2: Dictionary
var inventory_slot1: Dictionary
var inventory_slot2: Dictionary
var inventory_slot3: Dictionary
var inventory_slot4: Dictionary

@onready var chat_log = $ChatPanel/ChatScroll/ChatLog
@onready var chat_input = $HBoxContainer/ChatInput
@onready var send_button = $HBoxContainer/SendButton
@onready var chat_scroll = $ChatPanel/ChatScroll

var no_wep = {"hands": 1,
			"min_dmg": 1, 
			"max_dmg": 3,
			"durability": 1,
			"crit_chance": 0.1,
			"crit_multi": 1.1,
			"speed": 0.25,
			"range": 150,
			"parry": false,
			"block": false,
			"price": 0,
			"stock": 500,
			"type": "weapon",
			"category": "unarmed",
			"str_req": 20,
			"skill_req": 30,
			"level": 1,
			"attributes": 
			{
				"weapon_skill": 0,
			}}

					 
var attributes := {}
var remaining_points := 0

@onready var remaining_label = $RemainingLabel
@onready var confirm_button = $ConfirmButton
@onready var player_life = 2000

func _ready():
	get_node("VBoxContainer/Human").pressed.connect(func(): on_race_selected("Human"))
	get_node("VBoxContainer/Elf").pressed.connect(func(): on_race_selected("Elf"))
	get_node("VBoxContainer/Orc").pressed.connect(func(): on_race_selected("Orc"))
	get_node("VBoxContainer/Troll").pressed.connect(func(): on_race_selected("Troll"))


	$GridContainer.visible = false
	$RemainingLabel.visible = false
	$ConfirmButton.visible = false
	
	_initialize_attributes()
	_setup_buttons()
	_update_ui()
	confirm_button.pressed.connect(_on_confirm)
	get_node("GoBack").pressed.connect(func(): go_back())
	
	GameState_.connect("send_gladiator_data_to_peer_signal", Callable(self, "_on_send_gladiator_data_to_peer_signal"))
	GameState_.connect("send_player_colors_to_peer_signal", Callable(self, "_on_colors_received"))
	GameState_.connect("broadcast_log_signal", Callable(self, "_on_log_received"))
	
	if multiplayer.is_server():
		GameState_.get_player_colors(multiplayer.get_unique_id())
	else:
		GameState_.rpc_id(1, "get_player_colors", multiplayer.get_unique_id())
	
	send_button.pressed.connect(_on_send_pressed)
	chat_input.text_submitted.connect(_on_send_pressed)
	

func on_race_selected(race: String):
	var color = player_colors[multiplayer.get_unique_id()]
	var hex_color = color.to_html()
	var formatted = "[color=%s]%s[/color]" % [hex_color, GameState_.selected_name]
	rpc("broadcast_peer", multiplayer.get_unique_id(), formatted + " selected " + race.to_upper() + "!")
	
	print("Selected race: ", race)
	GameState_.selected_race = race
	$GridContainer.visible = true
	$RemainingLabel.visible = true
	$ConfirmButton.visible = true
	$RaceSelectionTitle.visible = false
	$VBoxContainer.visible = false
	_update_ui()

func _on_colors_received(_id, colors):
	player_colors = colors
	
func _on_send_gladiator_data_to_peer_signal(peer_id: int, _player_gladiator_data: Dictionary, _all_gladiators):
	all_gladiators = _all_gladiators
	if peer_id == multiplayer.get_unique_id():
		player_gladiator_data = _player_gladiator_data
	
func _on_send_pressed():#submitted_text = ""):
	var msg = chat_input.text.strip_edges()
	if msg.length() == 0 or msg.length() > MAX_LENGTH:
		return

	var sender_id = get_tree().get_multiplayer().get_unique_id()
	var now = Time.get_datetime_dict_from_system()
	var timestamp = "[%02d:%02d]" % [now.hour, now.minute]

	chat_input.clear()
	rpc("broadcast_message", sender_id, str(GameState_.selected_name), timestamp, msg)


func _on_log_received(message):
	#var now = Time.get_datetime_dict_from_system()
	#var timestamp = "[%02d:%02d]" % [now.hour, now.minute]
	var formatted = "%s" % [message]
	#print(str(multiplayer.get_unique_id()) + message)
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
func broadcast_peer(sender_id, message: String):
	_add_message_peer(sender_id, message)
	
func _add_message_peer(_sender_id, message: String):
	#var gladiator = all_gladiators.get(sender_id)
	#var color = player_colors[sender_id]#Color.WHITE#gladiator.get("color", Color.WHITE)
	#var hex_color = color.to_html()
	var formatted = message
	#var formatted = "[color=%s]%s[/color]: %s" % [hex_color, sender_name, message]

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
	
@rpc("any_peer", "call_local")
func broadcast_message(sender_id, sender_name: String, timestamp: String, message: String):
	_add_message(sender_id, sender_name, timestamp, message)


func _add_message(sender_id, sender_name: String, timestamp: String, message: String):
	#var gladiator = all_gladiators.get(sender_id)
	var color = player_colors[sender_id]#Color.WHITE#gladiator.get("color", Color.WHITE)
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
	
func _initialize_attributes():
	attributes = {
		"strength": 25.0,
		"quickness": 81.0,
		"crit_rating": 10.0,
		"avoidance": 31.0,
		"health": 100.0,
		"resilience": 1.0,
		"endurance": 1.0,
		"sword_mastery": 40.0,
		"axe_mastery": 20.0,
		"hammer_mastery": 20.0,
		"dagger_mastery": 20.0,
		"chain_mastery": 20.0,
		"shield_mastery": 20.0,
		"unarmed_mastery": 10.0,
	}
	# Override with starting values if any
	for attr in starting_values:
		if attr in attributes:
			attributes[attr] = starting_values[attr]
	remaining_points = max_points - attributes.values().reduce(func(a, b): return a + b)


func _setup_buttons():
	for attr in attributes.keys():
		var add = $GridContainer.find_child(attr.capitalize() + "_Add", true, false)
		var sub = $GridContainer.find_child(attr.capitalize() + "_Sub", true, false)

		if add and sub:
			add.pressed.connect(func(): _increase(attr))
			sub.pressed.connect(func(): _decrease(attr))

			_bind_scroll_input(add, attr, true)
			_bind_scroll_input(sub, attr, false)



func _increase(attr):
	if remaining_points <= 0:
		return
	attributes[attr] += 1
	remaining_points -= 1
	_update_ui()

func _decrease(attr):
	if attributes[attr] <= 1:
		return
	attributes[attr] -= 1
	remaining_points += 1
	_update_ui()

func _update_ui():
	var race_modifiers = GameState_.RACE_MODIFIERS.get(GameState_.selected_race, {})
	
	for attr in attributes:
		var value_label = $GridContainer.get_node(attr.capitalize() + "_Value")
		var mod_label = $GridContainer.get_node(attr.capitalize() + "_Modifier")
		var final_label = $GridContainer.get_node(attr.capitalize() + "_Final")
		
		if value_label:
			value_label.text = str(int(attributes[attr])) 

		if mod_label:
			var multiplier = race_modifiers.get(attr, 1.0)
			
			var percent_change = int(round((multiplier - 1.0) * 100))
			var prefix = "+" if percent_change > 0 else ""

			mod_label.text = prefix + str(percent_change) + "%"
			#mod_label.text = "(x" + str(multiplier).pad_decimals(2) + ")"
			#mod_label.
			# Only show if not neutral
			if multiplier == 1.0:
				mod_label.add_theme_color_override("font_color", Color.YELLOW)
			if multiplier > 1.0:
				mod_label.add_theme_color_override("font_color", Color.GREEN)  # green
			if multiplier < 1.0:
				mod_label.add_theme_color_override("font_color", Color.RED)  # red
				
			mod_label.add_theme_font_size_override("font_size", 10)
			var final = int(round(attributes[attr] * multiplier))
			final_label.text = str(final)
		#value_label.text = str(attributes[attr])
	remaining_label.text = "Remaining: %d" % remaining_points

func _on_confirm():
	#print("✅ Client connected with ID:", multiplayer.get_unique_id())
	#print("❓ Is server:", multiplayer.is_server())
	
	if remaining_points > 0:
		print("Distribute all points before continuing.")
		return
	# Store or emit
	var final_attributes = apply_race_modifiers(GameState_.selected_race).duplicate()
	
	var color = player_colors[multiplayer.get_unique_id()]
	var hex_color = color.to_html()
	var formatted = "[color=%s]%s[/color] is ready!" % [hex_color, GameState_.selected_name]
	rpc("broadcast_peer", multiplayer.get_unique_id(), formatted)
	# Prepare your data
	var race_weights = {
		"Human": 12,
		"Elf": 7,
		"Troll": 20,
		"Orc": 16,
	}
	
	var gladiator = {
		"color": Color.WHITE,
		"name": GameState_.selected_name,
		"gold": 100,
		"exp": 0,
		"streak": 0,
		"level": "1",
		"race": GameState_.selected_race,
		"weight": race_weights[GameState_.selected_race.capitalize()],
		"concede": 0.5,
		"stance": "normal",
		"attack_type": "normal",
		"attributes": final_attributes,
		"player_life": player_life,
		
		"weapon1": {
			"unarmed": 
				no_wep
		},
		"weapon2": {
			"unarmed": 
				no_wep
		},
		
		"head": {},
		"shoulder": {},
		"chest": {},

		"ring1": {},
		"ring2": {},
		
		"inventory": {
			"slot1": {},
			"slot2": {},
			"slot3": {},
			"slot4": {}
		}
	}
	if multiplayer.is_server():
		print("✅ Server created gladiator")
		GameState_._submit_gladiator_remote.rpc(gladiator)
			
	if !multiplayer.is_server():
		print("✅ Client created gladiator")
		GameState_.submit_gladiator(gladiator)
		
	#GameState_.gladiator_attributes = final_attributes.duplicate()
	emit_signal("confirmed", attributes)
	
	#get_tree().change_scene_to_file("res://Main.tscn")

func apply_race_modifiers(race: String) -> Dictionary:
	var modifiers = GameState_.RACE_MODIFIERS.get(race, {})
	var modified_attributes = attributes.duplicate()

	for attr in modifiers:
		if modified_attributes.has(attr):
			modified_attributes[attr] = modified_attributes[attr] * modifiers[attr]

	return modified_attributes


func _bind_scroll_input(button: Button, attr: String, is_add_button: bool):
	button.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if is_add_button:
					_increase(attr)
				else:
					_decrease(attr)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if is_add_button:
					_decrease(attr)
				else:
					_increase(attr)
	)
	
func go_back():
	get_tree().change_scene_to_file("res://UI/RaceSelection.tscn")
