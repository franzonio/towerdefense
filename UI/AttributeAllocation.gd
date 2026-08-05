extends Control
class_name AttributeAllocation

signal confirmed(attributes: Dictionary)

@export var max_points: = 164
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
@export var players_ready: int = 0
@export var total_peers: int = 0

@onready var chat_log = $ChatPanel / ChatScroll / ChatLog
@onready var chat_input = $HBoxContainer / ChatInput
@onready var send_button = $HBoxContainer / SendButton
@onready var chat_scroll = $ChatPanel / ChatScroll
@onready var attribute_container = $GridContainer

@onready var players_ready_label = $StartGameContainer / PlayersReadyLabel


@onready var time = 0
var sec = 0
var prev_sec = 0
var confirmed_pressed = false

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
	"str_req": 0, 
	"skill_req": 0, 
	"level": 1, 
	"modifiers": {
		"attributes": {}, 
		"bonuses": {}
		}
	}


var attributes: = {}
var remaining_points: = 0

@onready var remaining_label = $RemainingLabel
@onready var confirm_button = $ConfirmButton
@onready var player_life = 500

@onready var health_mods = [$AttributePanelHelp2/GridContainer/Attribute, $AttributePanelHelp2/GridContainer/Human, 
$AttributePanelHelp2/GridContainer/Elf, $AttributePanelHelp2/GridContainer/Troll, $AttributePanelHelp2/GridContainer/Orc]

@onready var strength_mods = [$AttributePanelHelp2/GridContainer/Attribute2, $AttributePanelHelp2/GridContainer/Human2, 
$AttributePanelHelp2/GridContainer/Elf2, $AttributePanelHelp2/GridContainer/Troll2, $AttributePanelHelp2/GridContainer/Orc2]

@onready var endurance_mods = [$AttributePanelHelp2/GridContainer/Attribute3, $AttributePanelHelp2/GridContainer/Human3, 
$AttributePanelHelp2/GridContainer/Elf3, $AttributePanelHelp2/GridContainer/Troll3, $AttributePanelHelp2/GridContainer/Orc3]

@onready var criticality_mods = [$AttributePanelHelp2/GridContainer/Attribute4, $AttributePanelHelp2/GridContainer/Human4, 
$AttributePanelHelp2/GridContainer/Elf4, $AttributePanelHelp2/GridContainer/Troll4, $AttributePanelHelp2/GridContainer/Orc4]

@onready var avoidance_mods = [$AttributePanelHelp2/GridContainer/Attribute5, $AttributePanelHelp2/GridContainer/Human5, 
$AttributePanelHelp2/GridContainer/Elf5, $AttributePanelHelp2/GridContainer/Troll5, $AttributePanelHelp2/GridContainer/Orc5]

@onready var quickness_mods = [$AttributePanelHelp2/GridContainer/Attribute6, $AttributePanelHelp2/GridContainer/Human6, 
$AttributePanelHelp2/GridContainer/Elf6, $AttributePanelHelp2/GridContainer/Troll6, $AttributePanelHelp2/GridContainer/Orc6]

@onready var resilience_mods = [$AttributePanelHelp2/GridContainer/Attribute7, $AttributePanelHelp2/GridContainer/Human7, 
$AttributePanelHelp2/GridContainer/Elf7, $AttributePanelHelp2/GridContainer/Troll7, $AttributePanelHelp2/GridContainer/Orc7]

@onready var stabbing_mods = [$AttributePanelHelp2/GridContainer/Attribute10, $AttributePanelHelp2/GridContainer/Human10, 
$AttributePanelHelp2/GridContainer/Elf10, $AttributePanelHelp2/GridContainer/Troll10, $AttributePanelHelp2/GridContainer/Orc10]

@onready var sword_mods = [$AttributePanelHelp2/GridContainer/Attribute11, $AttributePanelHelp2/GridContainer/Human11, 
$AttributePanelHelp2/GridContainer/Elf11, $AttributePanelHelp2/GridContainer/Troll11, $AttributePanelHelp2/GridContainer/Orc11]

@onready var axe_mods = [$AttributePanelHelp2/GridContainer/Attribute12, $AttributePanelHelp2/GridContainer/Human12, 
$AttributePanelHelp2/GridContainer/Elf12, $AttributePanelHelp2/GridContainer/Troll12, $AttributePanelHelp2/GridContainer/Orc12]

@onready var mace_mods = [$AttributePanelHelp2/GridContainer/Attribute13, $AttributePanelHelp2/GridContainer/Human13, 
$AttributePanelHelp2/GridContainer/Elf13, $AttributePanelHelp2/GridContainer/Troll13, $AttributePanelHelp2/GridContainer/Orc13]

@onready var flagellation_mods = [$AttributePanelHelp2/GridContainer/Attribute14, $AttributePanelHelp2/GridContainer/Human14, 
$AttributePanelHelp2/GridContainer/Elf14, $AttributePanelHelp2/GridContainer/Troll14, $AttributePanelHelp2/GridContainer/Orc14]

@onready var shield_mods = [$AttributePanelHelp2/GridContainer/Attribute15, $AttributePanelHelp2/GridContainer/Human15, 
$AttributePanelHelp2/GridContainer/Elf15, $AttributePanelHelp2/GridContainer/Troll15, $AttributePanelHelp2/GridContainer/Orc15]

@onready var human_mods = [$AttributePanelHelp2/GridContainer/Human, $AttributePanelHelp2/GridContainer/Human2, 
	$AttributePanelHelp2/GridContainer/Human3, $AttributePanelHelp2/GridContainer/Human7, 
	$AttributePanelHelp2/GridContainer/Human4, $AttributePanelHelp2/GridContainer/Human5, 
	$AttributePanelHelp2/GridContainer/Human6, $AttributePanelHelp2/GridContainer/Human10,
	 $AttributePanelHelp2/GridContainer/Human11, $AttributePanelHelp2/GridContainer/Human12, 
	$AttributePanelHelp2/GridContainer/Human13, $AttributePanelHelp2/GridContainer/Human14,
	 $AttributePanelHelp2/GridContainer/Human15, $AttributePanelHelp2/GridContainer/HumanTitle]
	
@onready var elf_mods = [$AttributePanelHelp2/GridContainer/Elf, $AttributePanelHelp2/GridContainer/Elf2, 
$AttributePanelHelp2/GridContainer/Elf3, $AttributePanelHelp2/GridContainer/Elf7, 
$AttributePanelHelp2/GridContainer/Elf4, $AttributePanelHelp2/GridContainer/Elf5, 
$AttributePanelHelp2/GridContainer/Elf6, $AttributePanelHelp2/GridContainer/Elf10, 
$AttributePanelHelp2/GridContainer/Elf11, $AttributePanelHelp2/GridContainer/Elf12, 
$AttributePanelHelp2/GridContainer/Elf13, $AttributePanelHelp2/GridContainer/Elf14,
$AttributePanelHelp2/GridContainer/Elf15, $AttributePanelHelp2/GridContainer/ElfTitle]

@onready var orc_mods = [$AttributePanelHelp2/GridContainer/Orc, $AttributePanelHelp2/GridContainer/Orc2, 
$AttributePanelHelp2/GridContainer/Orc3, $AttributePanelHelp2/GridContainer/Orc7,
 $AttributePanelHelp2/GridContainer/Orc4, $AttributePanelHelp2/GridContainer/Orc5, 
$AttributePanelHelp2/GridContainer/Orc6, $AttributePanelHelp2/GridContainer/Orc10,
 $AttributePanelHelp2/GridContainer/Orc11, $AttributePanelHelp2/GridContainer/Orc12, 
$AttributePanelHelp2/GridContainer/Orc13, $AttributePanelHelp2/GridContainer/Orc14, 
$AttributePanelHelp2/GridContainer/Orc15, $AttributePanelHelp2/GridContainer/OrcTitle]

@onready var troll_mods = [$AttributePanelHelp2/GridContainer/Troll, $AttributePanelHelp2/GridContainer/Troll2, 
$AttributePanelHelp2/GridContainer/Troll3, $AttributePanelHelp2/GridContainer/Troll7, 
$AttributePanelHelp2/GridContainer/Troll4, $AttributePanelHelp2/GridContainer/Troll5, 
$AttributePanelHelp2/GridContainer/Troll6, $AttributePanelHelp2/GridContainer/Troll10, 
$AttributePanelHelp2/GridContainer/Troll11, $AttributePanelHelp2/GridContainer/Troll12, 
$AttributePanelHelp2/GridContainer/Troll13, $AttributePanelHelp2/GridContainer/Troll14,
$AttributePanelHelp2/GridContainer/Troll15, $AttributePanelHelp2/GridContainer/TrollTitle]

var enter_color = "b3a555bb"
var exit_color = "b3a55500"

func _ready():
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

	get_node("VBoxContainer/Human").pressed.connect( func(): on_race_selected("Human"))
	get_node("VBoxContainer/Elf").pressed.connect( func(): on_race_selected("Elf"))
	get_node("VBoxContainer/Orc").pressed.connect( func(): on_race_selected("Orc"))
	get_node("VBoxContainer/Troll").pressed.connect( func(): on_race_selected("Troll"))

	GameState_.connect("broadcast_players_ready_signal", Callable(self, "_on_players_ready_received"))

	$GridContainer.visible = false
	$RemainingLabel.visible = false
	$ConfirmButton.visible = false

	_initialize_attributes()
	_setup_buttons()
	_update_ui()
	confirm_button.pressed.connect(_on_confirm)
	get_node("GoBack").pressed.connect( func(): go_back())

	GameState_.connect("send_gladiator_data_to_peer_signal", Callable(self, "_on_send_gladiator_data_to_peer_signal"))
	GameState_.connect("send_player_colors_to_peer_signal", Callable(self, "_on_colors_received"))
	GameState_.connect("broadcast_log_signal", Callable(self, "_on_log_received"))


	if multiplayer.is_server():
		GameState_.get_player_colors(multiplayer.get_unique_id())
	else:
		GameState_.rpc_id(1, "get_player_colors", multiplayer.get_unique_id())




	total_peers = 0

	for i in multiplayer.get_peers():
		if i == 0: continue
		total_peers += 1


	send_button.pressed.connect(_on_send_pressed)
	chat_input.text_submitted.connect(_on_send_pressed)
	players_ready_label.text = str(players_ready) + "/" + str(total_peers + 1) + " ready"

	"\n\tif multiplayer.is_server(): \n\t\tawait get_tree().process_frame\n\t\tremaining_points = 0\n\t\ton_race_selected(\"Human\")\n\t\tawait get_tree().process_frame\n\t\t_on_confirm()#confirm_button.button_pressed == true\n\t"



	TweenFX.glow_pulse($VBoxContainer, 1, 0, 0.2)


func _process(delta: float):

	if Input.is_action_just_pressed("focus_chat"):
		chat_input.grab_focus()

	time += delta
	prev_sec = sec
	sec = int(time)
	if sec != prev_sec:


		print("multiplayer.get_peers():" + str(multiplayer.get_peers()))
		if multiplayer.is_server():

			total_peers = 0

			for i in multiplayer.get_peers():
				if i == 0: continue
				total_peers += 1
		players_ready_label.text = str(players_ready) + "/" + str(total_peers + 1) + " ready"





func _on_peer_disconnected(id: int):
	print("Player left: ", id)
	multiplayer.disconnect_peer(id)

func on_race_selected(race: String):
	$VBoxContainer/Human.disabled = true
	$VBoxContainer/Elf.disabled = true
	$VBoxContainer/Orc.disabled = true
	$VBoxContainer/Troll.disabled = true
	
	var color = player_colors[multiplayer.get_unique_id()]
	var hex_color = color
	var formatted = "[color=%s]%s[/color]" % [hex_color, GameState_.selected_name]
	rpc("broadcast_peer", multiplayer.get_unique_id(), formatted + " selected " + race.to_upper() + "!")


	print("Selected race: ", race)
	GameState_.selected_race = race





	_update_ui()

	_on_confirm()

func _on_colors_received(_id, colors):
	print("Received colors from host: " + str(colors))
	player_colors = colors

func _on_send_gladiator_data_to_peer_signal(peer_id: int, _player_gladiator_data: Dictionary, _all_gladiators):
	all_gladiators = _all_gladiators
	if peer_id == multiplayer.get_unique_id():
		player_gladiator_data = _player_gladiator_data

func _on_send_pressed(submitted_text = ""):

	var msg = chat_input.text.strip_edges()
	if msg.length() == 0 or msg.length() > MAX_LENGTH:
		return

	var sender_id = get_tree().get_multiplayer().get_unique_id()
	var now = Time.get_datetime_dict_from_system()
	var timestamp = "[%02d:%02d]" % [now.hour, now.minute]

	chat_input.clear()
	rpc("broadcast_message", sender_id, str(GameState_.selected_name), timestamp, msg)


func _on_log_received(message):


	var formatted = "%s" % [message]

	var label = RichTextLabel.new()
	label.bbcode_enabled = true
	label.text = formatted


	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.fit_content = true
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	label.scroll_active = false


	chat_log.add_child(label)


	if chat_log.get_child_count() > MAX_MESSAGES:
		chat_log.get_child(0).queue_free()


	await get_tree().process_frame
	await get_tree().process_frame
	chat_scroll.scroll_vertical = chat_scroll.get_v_scroll_bar().max_value

@rpc("any_peer", "call_local")
func broadcast_peer(sender_id, message: String):
	_add_message_peer(sender_id, message)

func _add_message_peer(_sender_id, message: String):



	var formatted = message


	var label = RichTextLabel.new()
	label.bbcode_enabled = true
	label.text = formatted


	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.fit_content = true
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	label.scroll_active = false


	chat_log.add_child(label)





	if chat_log.get_child_count() > MAX_MESSAGES:
		chat_log.get_child(0).queue_free()


	await get_tree().process_frame
	await get_tree().process_frame
	chat_scroll.scroll_vertical = chat_scroll.get_v_scroll_bar().max_value

@rpc("any_peer", "call_local")
func broadcast_message(sender_id, sender_name: String, timestamp: String, message: String):
	_add_message(sender_id, sender_name, timestamp, message)

	print("broadcast_message")

func _add_message(sender_id, sender_name: String, timestamp: String, message: String):
	print("_add_message")

	var color = player_colors[sender_id]
	var hex_color = color

	var formatted = "%s [color=%s]%s[/color]: %s" % [timestamp, hex_color, sender_name, message]

	var label = RichTextLabel.new()
	label.bbcode_enabled = true
	label.text = formatted


	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.fit_content = true
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	label.scroll_active = false


	chat_log.add_child(label)





	if chat_log.get_child_count() > MAX_MESSAGES:
		chat_log.get_child(0).queue_free()


	await get_tree().process_frame
	await get_tree().process_frame
	chat_scroll.scroll_vertical = chat_scroll.get_v_scroll_bar().max_value

func _initialize_attributes():
	attributes = {
		"strength": 150.0, 
		"quickness": 0.0, 
		"crit_rating": 0.0, 
		"avoidance": 0.0, 
		"health": 100.0, 
		"resilience": 0.0, 
		"endurance": 3.0, 
		"sword_mastery": 0.0, 
		"axe_mastery": 0.0, 
		"mace_mastery": 0.0, 
		"stabbing_mastery": 0.0, 
		"flagellation_mastery": 0.0, 
		"shield_mastery": 0.0, 
		"unarmed_mastery": 0.0, 
	}

	for attr in starting_values:
		if attr in attributes:
			attributes[attr] = starting_values[attr]
	remaining_points = max_points - attributes.values().reduce( func(a, b): return a + b)


func _setup_buttons():
	for attr in attributes.keys():
		var add = $GridContainer.find_child(attr.capitalize() + "_Add", true, false)
		var sub = $GridContainer.find_child(attr.capitalize() + "_Sub", true, false)

		if add and sub:
			add.pressed.connect( func(): _increase(attr))
			sub.pressed.connect( func(): _decrease(attr))

			_bind_scroll_input(add, attr, true)
			_bind_scroll_input(sub, attr, false)



func _increase(attr):
	if remaining_points <= 0 or confirmed_pressed:
		return
	attributes[attr] += 1
	remaining_points -= 1
	_update_ui()

func _decrease(attr):
	if attributes[attr] <= 1 or confirmed_pressed:
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



			if multiplier == 1.0:
				mod_label.add_theme_color_override("font_color", Color.YELLOW)
			if multiplier > 1.0:
				mod_label.add_theme_color_override("font_color", Color.GREEN)
			if multiplier < 1.0:
				mod_label.add_theme_color_override("font_color", Color.RED)

			mod_label.add_theme_font_size_override("font_size", 10)
			var final = int(round(attributes[attr] * multiplier))
			final_label.text = str(final)

	remaining_label.text = "Remaining: %d" % remaining_points

func _on_players_ready_received(_players_ready):
	if multiplayer.is_server(): print("server: " + str(_players_ready))
	else: print("client: " + str(_players_ready))
	players_ready = _players_ready
	players_ready_label.text = str(players_ready) + "/" + str(total_peers + 1) + " ready"



func _on_confirm():








	if multiplayer.is_server():
		GameState_.client_send_ready_to_host(multiplayer.get_unique_id())
	else:
		GameState_.rpc_id(1, "client_send_ready_to_host", multiplayer.get_unique_id())




	var final_attributes = attributes

	var color = player_colors[multiplayer.get_unique_id()]
	var hex_color = color
	var formatted = "[color=%s]%s[/color] is ready!" % [hex_color, GameState_.selected_name]
	if !multiplayer.is_server(): rpc("broadcast_peer", multiplayer.get_unique_id(), formatted)

	var race_weights = {
		"Human": 12, 
		"Elf": 7, 
		"Troll": 20, 
		"Orc": 16, 
	}

	var gladiator = {
		"color": Color("d2c9ff"), 
		"name": GameState_.selected_name, 
		"gold": 20000, 
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
		"shoulders": {}, 
		"chest": {}, 
		"belt": {}, 
		"gloves": {}, 
		"boots": {}, 
		"legs": {}, 
		"amulet": {}, 

		"ring1": {}, 
		"ring2": {}, 

		"inventory": {
			"slot1": {}, 
			"slot2": {}, 
			"slot3": {}, 
			"slot4": {}, 
			"slot5": {}, 
			"slot6": {}, 
			"slot7": {}, 
			"slot8": {}
		}, 

		"crafting_mats": {
			"scroll_of_luck": 10000, 
			"scroll_of_injection": 10000
		}, 
		"total_modifier_bonuses": {}, 
		"age": "Young",
		"regret_points": 1000,
		"points": 150
	}

	if multiplayer.is_server():
		GameState_._submit_gladiator_remote.rpc(gladiator)
	elif !multiplayer.is_server():
		GameState_.submit_gladiator(gladiator)



	for attr in attributes.keys():
		var add = $GridContainer.find_child(attr.capitalize() + "_Add", true, false)
		var sub = $GridContainer.find_child(attr.capitalize() + "_Sub", true, false)
		add.disabled = true
		sub.disabled = true

	confirmed_pressed = true
	confirm_button.disabled = true
	emit_signal("confirmed", attributes)



func apply_race_modifiers(race: String) -> Dictionary:
	var modifiers = GameState_.RACE_MODIFIERS.get(race, {})
	var modified_attributes = attributes.duplicate()

	for attr in modifiers:
		if modified_attributes.has(attr):
			modified_attributes[attr] = modified_attributes[attr] * modifiers[attr]


	return modified_attributes


func _bind_scroll_input(button: Button, attr: String, is_add_button: bool):
	if confirmed_pressed: return
	button.gui_input.connect( func(event):
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
	if !multiplayer.is_server():
		var color = player_colors[multiplayer.get_unique_id()]
		var hex_color = color
		var formatted = "[color=%s]%s[/color][color=%s] disconnected![/color]" % [hex_color, GameState_.selected_name, Color.RED.to_html()]
		rpc("broadcast_peer", multiplayer.get_unique_id(), formatted)
		await get_tree().create_timer(1.0).timeout

		NetworkManager_.leave_game()
		multiplayer.multiplayer_peer.close()
		get_tree().set_multiplayer(null)
	else:
		var color = player_colors[multiplayer.get_unique_id()]
		var hex_color = color
		var formatted = "[color=%s]%s[/color][color=%s] (host) disconnected![/color]" % [hex_color, GameState_.selected_name, Color.RED.to_html()]
		rpc("broadcast_peer", multiplayer.get_unique_id(), formatted)
		await get_tree().create_timer(1.0).timeout

		NetworkManager_.leave_game()
		multiplayer.multiplayer_peer.close()

	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")

func apply_stylebox(mods, color):
	for mod in mods:
		var old_sb = mod.get_theme_stylebox("normal")

		if old_sb:
			var new_sb = old_sb.duplicate()
			new_sb.bg_color = color
			mod.add_theme_stylebox_override("normal", new_sb)

func _on_human_mouse_entered() -> void:
	apply_stylebox(human_mods, enter_color)

func _on_human_mouse_exited() -> void:
	apply_stylebox(human_mods, exit_color)

func _on_elf_mouse_entered() -> void:
	apply_stylebox(elf_mods, enter_color)


func _on_elf_mouse_exited() -> void:
	apply_stylebox(elf_mods, exit_color)


func _on_orc_mouse_entered() -> void:
	apply_stylebox(orc_mods, enter_color)


func _on_orc_mouse_exited() -> void:
	apply_stylebox(orc_mods, exit_color)


func _on_troll_mouse_entered() -> void:
	apply_stylebox(troll_mods, enter_color)


func _on_troll_mouse_exited() -> void:
	apply_stylebox(troll_mods, exit_color)


func _on_health_icon_mouse_entered() -> void:
	apply_stylebox(health_mods, enter_color)


func _on_health_icon_mouse_exited() -> void:
	apply_stylebox(health_mods, exit_color)


func _on_endurance_icon_mouse_entered() -> void:
	apply_stylebox(endurance_mods, enter_color)


func _on_endurance_icon_mouse_exited() -> void:
	apply_stylebox(endurance_mods, exit_color)


func _on_avoidance_icon_mouse_entered() -> void:
	apply_stylebox(avoidance_mods, enter_color)


func _on_avoidance_icon_mouse_exited() -> void:
	apply_stylebox(avoidance_mods, exit_color)


func _on_resilience_icon_mouse_entered() -> void:
	apply_stylebox(resilience_mods, enter_color)


func _on_resilience_icon_mouse_exited() -> void:
	apply_stylebox(resilience_mods, exit_color)


func _on_strength_icon_mouse_entered() -> void:
	apply_stylebox(strength_mods, enter_color)


func _on_strength_icon_mouse_exited() -> void:
	apply_stylebox(strength_mods, exit_color)


func _on_criticality_icon_mouse_entered() -> void:
	apply_stylebox(criticality_mods, enter_color)


func _on_criticality_icon_mouse_exited() -> void:
	apply_stylebox(criticality_mods, exit_color)


func _on_quickness_icon_mouse_entered() -> void:
	apply_stylebox(quickness_mods, enter_color)


func _on_quickness_icon_mouse_exited() -> void:
	apply_stylebox(quickness_mods, exit_color)


func _on_sword_icon_mouse_entered() -> void:
	apply_stylebox(sword_mods, enter_color)


func _on_sword_icon_mouse_exited() -> void:
	apply_stylebox(sword_mods, exit_color)


func _on_axe_icon_mouse_entered() -> void:
	apply_stylebox(axe_mods, enter_color)


func _on_axe_icon_mouse_exited() -> void:
	apply_stylebox(axe_mods, exit_color)


func _on_stabbing_icon_mouse_entered() -> void:
	apply_stylebox(stabbing_mods, enter_color)


func _on_stabbing_icon_mouse_exited() -> void:
	apply_stylebox(stabbing_mods, exit_color)


func _on_mace_icon_mouse_entered() -> void:
	apply_stylebox(mace_mods, enter_color)


func _on_mace_icon_mouse_exited() -> void:
	apply_stylebox(mace_mods, exit_color)


func _on_flagellation_icon_mouse_entered() -> void:
	apply_stylebox(flagellation_mods, enter_color)


func _on_flagellation_icon_mouse_exited() -> void:
	apply_stylebox(flagellation_mods, exit_color)


func _on_shield_icon_mouse_entered() -> void:
	apply_stylebox(shield_mods, enter_color)


func _on_shield_icon_mouse_exited() -> void:
	apply_stylebox(shield_mods, exit_color)
