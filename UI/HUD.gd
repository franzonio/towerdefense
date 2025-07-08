extends CanvasLayer

@onready var label_timer = $MarginContainer/HBoxContainer/Label_Timer
@onready var label_gold = $MarginContainer/HBoxContainer/Label_Gold
@onready var label_xp = $MarginContainer/HBoxContainer/Label_Experience

var time_passed: float = 0.0
var gold: int = 0
var experience: int = 0

func _process(delta: float) -> void:
	time_passed += delta
	label_timer.text = "Time: " + str(time_passed as int)

func update_gold(amount: int):
	gold = amount
	label_gold.text = "Gold: " + str(gold)

func update_experience(amount: int):
	experience = amount
	label_xp.text = "XP: " + str(experience)
