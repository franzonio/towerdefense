extends CanvasLayer

@onready var strength_card = preload("res://ShopCards/StrengthCard.tscn")
@onready var health_card = preload("res://ShopCards/HealthCard.tscn")
@onready var criticality_card = preload("res://ShopCards/CriticalityCard.tscn")
@onready var endurance_card = preload("res://ShopCards/EnduranceCard.tscn")
@onready var quickness_card = preload("res://ShopCards/QuicknessCard.tscn")
@onready var resilience_card = preload("res://ShopCards/ResilienceCard.tscn")
@onready var weapon_mastery_card = preload("res://ShopCards/WeaponMasteryCard.tscn")

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
var shop
var countdown_active := true
var shop_pressed := false
var grid
var refresh_button
var all_cards
var is_refreshing := false

func _ready():
	GameState_.connect("gladiator_life_changed", Callable(self, "_on_life_changed"))
	GameState_.connect("countdown_updated", Callable(self, "_on_countdown_updated"))
	populate_hud()  # Initial draw
	countdown_label = $IntermissionTimerLabel
	shop = $Shop
	shop.visible = false
	all_cards = [strength_card, health_card, criticality_card, endurance_card, quickness_card, resilience_card, weapon_mastery_card]
	grid = $Shop/HBoxContainer/GridContainer
	refresh_button = $Shop/HBoxContainer/HBoxContainer/RefreshButton
	roll_initial_cards()
	
func roll_initial_cards():
	for i in range(5):
		var random_card = all_cards[randi() % all_cards.size()]  # Safe random index
		var card_instance = random_card.instantiate()
		card_instance.modulate.a = 0
		card_instance.scale = Vector2(0.8, 0.8)
		grid.add_child(card_instance)

		var tween := get_tree().create_tween()
		tween.tween_property(card_instance, "modulate:a", 1.0, 0.3).set_delay(i * 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(card_instance, "scale", Vector2.ONE, 0.3).set_delay(i * 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	
func clear_shop_grid():
	var tweens = []

	for child in grid.get_children():
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
	await clear_shop_grid()

	for i in range(5):
		var random_card = all_cards[randi() % all_cards.size()]
		var card_instance = random_card.instantiate()
		card_instance.modulate.a = 0
		card_instance.scale = Vector2(0.8, 0.8)
		grid.add_child(card_instance)

		var tween := get_tree().create_tween()
		tween.tween_property(card_instance, "modulate:a", 1.0, 0.3).set_delay(i * 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(card_instance, "scale", Vector2.ONE, 0.3).set_delay(i * 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)



func _on_refresh_button_pressed():
	if is_refreshing:
		return
	is_refreshing = true
	refresh_button.disabled = true
	await roll_cards()
	await get_tree().create_timer(0.8).timeout
	refresh_button.disabled = false
	is_refreshing = false


func _on_shop_button_pressed():
	shop_pressed = !shop_pressed
	if shop_pressed: shop.visible = true
	else: shop.visible = false
	#else: countdown_label.visible = true
	#pass # Replace with function body.

	
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
