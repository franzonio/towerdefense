extends Control
class_name AttributeAllocation

signal confirmed(attributes: Dictionary)

@export var max_points := 57
@export var starting_values: Dictionary = {}

var attributes := {}
var remaining_points := 0

@onready var remaining_label = $Panel/RemainingLabel
@onready var confirm_button = $Panel/ConfirmButton

func _ready():
	_initialize_attributes()
	_setup_buttons()
	_update_ui()
	confirm_button.pressed.connect(_on_confirm)

func _initialize_attributes():
	attributes = {
		"strength": 1,
		"weapon_skill": 1,
		"quickness": 1,
		"crit_rating": 1,
		"avoidance": 1,
		"health": 1,
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
		var add = $Panel/GridContainer.find_child(attr.capitalize() + "_Add", true, false)
		var sub = $Panel/GridContainer.find_child(attr.capitalize() + "_Sub", true, false)

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
	for attr in attributes:
		var value_label = $Panel/GridContainer.get_node(attr.capitalize() + "_Value")
		value_label.text = str(attributes[attr])
	remaining_label.text = "Remaining: %d" % remaining_points

func _on_confirm():
	if remaining_points > 0:
		print("Distribute all points before continuing.")
		return
	# Store or emit
	GameState_.gladiator_attributes = attributes.duplicate()
	emit_signal("confirmed", attributes)
	# Optional: transition to game
	get_tree().change_scene_to_file("res://Main.tscn")


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
