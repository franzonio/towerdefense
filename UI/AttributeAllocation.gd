extends Control
class_name AttributeAllocation

signal confirmed(attributes: Dictionary)

@export var max_points := 148
@export var starting_values: Dictionary = {}

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

var no_weapon := {
	"hands": 1,
	"min_dmg": 1, 
	"max_dmg": 3,
	"durability": 1,
	"req": 1,
	"crit": 0.1,
	"speed": 0.25,
	"range": 150,
	"parry:": false,
	"block": false,
	"attributes": 0
	}

					 
var attributes := {}
var remaining_points := 0

@onready var remaining_label = $RemainingLabel
@onready var confirm_button = $ConfirmButton
@onready var player_life = 200

func _ready():
	_initialize_attributes()
	_setup_buttons()
	_update_ui()
	confirm_button.pressed.connect(_on_confirm)
	get_node("GoBack").pressed.connect(func(): go_back())

func _initialize_attributes():
	attributes = {
		"strength": 1,
		"weapon_skill": 21,
		"quickness": 81,
		"crit_rating": 1,
		"avoidance": 31,
		"health": 11,
		"resilience": 1,
		"endurance": 1,
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
			value_label.text = str(attributes[attr]) 

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
	
	# Prepare your data
	var gladiator = {
		"name": GameState_.selected_name,
		"gold": 100,
		"exp": 0,
		"level": 0,
		"race": GameState_.selected_race,
		"attributes": final_attributes,
		"player_life": player_life,
		"weapon_slot1": no_weapon,
		"weapon_slot2": no_weapon,
		"armor": {
			"head": {},
			"shoulder": {},
			"chest": {},
			},
		"talismans:": {
			"ring1": {},
			"ring2": {}
		},
		"inventory": {
			"slot1": {},
			"slot2": {},
			"slot3": {},
			"slot4": {}
		}
	}
	#print(multiplayer.is_server)
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
			modified_attributes[attr] = round(modified_attributes[attr] * modifiers[attr])

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
