extends CanvasLayer

@onready var label_timer = $MarginContainer/HBoxContainer/Label_Timer
@onready var label_gold = $MarginContainer/HBoxContainer/Label_Gold
@onready var label_xp = $MarginContainer/HBoxContainer/Label_Experience

@export var time_passed: float = 0.0
@export var gold: int = 0
@export var experience: int = 0

@export var name_label: Node
@export var race_label: Node
@export var life_label: Node

var countdown_label 
var countdown_active := true

func _ready():
	GameState_.connect("gladiator_life_changed", Callable(self, "_on_life_changed"))
	GameState_.connect("countdown_updated", Callable(self, "_on_countdown_updated"))
	populate_hud()  # Initial draw
	countdown_label = $IntermissionTimerLabel
	
	
func _on_countdown_updated(time_left: int):
	if time_left > 0: countdown_active = true
	if countdown_active: 
		#update_countdown_labels(time_left)
		if countdown_label: countdown_label.text = "⏳ %d" % time_left
		
		if time_left == 0:
			countdown_active = false
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
	var peer_ids = GameState_.all_gladiators.keys()
	peer_ids.sort()  # Optional but stable

	for i in range(min(peer_ids.size(), 8)):  # Clamp to available HUD slots
		var peer_id = peer_ids[i]
		var gladiator_data = GameState_.all_gladiators[peer_id]
		var container_name = "Player%d" % (i + 1)

		var player_container = $GridContainer/VBoxContainer.get_node_or_null(container_name)
		if player_container == null:
			push_warning("Missing container: %s" % container_name)
			continue

		name_label = player_container.get_node("PlayerInfo/PlayerName")
		race_label = player_container.get_node("PlayerInfo/PlayerRace")
		life_label = player_container.get_node("PlayerLife")

		name_label.text = str(gladiator_data.get("name", "Unknown"))
		race_label.text = str(gladiator_data.get("race", "???"))
		life_label.text = "❤️ %d" % int(gladiator_data.get("player_life", 0))



func _process(delta: float) -> void:
	time_passed += delta
	label_timer.text = "Time: " + str(time_passed as int)

func update_gold(amount: int):
	gold = amount
	label_gold.text = "Gold: " + str(gold)

func update_experience(amount: int):
	experience = amount
	label_xp.text = "XP: " + str(experience)
