extends CanvasLayer

@onready var strength_card = preload("res://ShopCards/AttributeCards/StrengthCard.tscn")
@onready var health_card = preload("res://ShopCards/AttributeCards/HealthCard.tscn")
@onready var criticality_card = preload("res://ShopCards/AttributeCards/CriticalityCard.tscn")
@onready var endurance_card = preload("res://ShopCards/AttributeCards/EnduranceCard.tscn")
@onready var quickness_card = preload("res://ShopCards/AttributeCards/QuicknessCard.tscn")
@onready var resilience_card = preload("res://ShopCards/AttributeCards/ResilienceCard.tscn")
@onready var weapon_mastery_card = preload("res://ShopCards/AttributeCards/WeaponMasteryCard.tscn")

@onready var simple_sword_card = preload("res://ShopCards/EquipmentCards/Sword/SimpleSword.tscn")

var equipment_card_scenes = {
	"simple_sword": simple_sword_card
}

@onready var item_popup := $ItemPopup
@onready var label_timer = $MarginContainer/HBoxContainer/Label_Timer
@onready var label_gold = $MarginContainer/HBoxContainer/Label_Gold
@onready var label_xp = $MarginContainer/HBoxContainer/Label_Experience

@export var time_passed: float = 0.0
@export var gold: int = 0
@export var experience: int = 0

@export var name_label: Node
@export var race_label: Node
@export var life_label: Node

var player_gladiator_data
var countdown_label 
var shop
var intermission := true
var shop_pressed := false
var shop_grid
var inventory_grid
var refresh_button
@export var all_cards: Array
#var _all_cards
var reroll_start_of_intermission
var is_refreshing := false
@export var card_stock: Dictionary

var selected_item_name := ""
var selected_slot := ""

func _ready():
	GameState_.connect("gladiator_life_changed", Callable(self, "_on_life_changed"))
	GameState_.connect("countdown_updated", Callable(self, "_on_countdown_updated"))
	GameState_.connect("card_stock_changed", Callable(self, "_on_card_stock_changed"))
	GameState_.connect("add_to_inventory_signal", Callable(self, "_on_add_to_inventory_signal"))
	
	#GameState_.connect("card_stock_initialize", Callable(self, "_on_card_stock_initialized"))
	populate_hud()  # Initial draw
	
	item_popup.clear()
	item_popup.add_item("Equip", 0)
	item_popup.add_item("Sell", 1)
	item_popup.id_pressed.connect(_on_item_popup_pressed)

	countdown_label = $IntermissionTimerLabel
	shop = $Shop
	shop.visible = false

	if multiplayer.is_server(): GameState_.initialize_card_stock()
	else: GameState_.rpc_id(1, "initialize_card_stock")
	all_cards = [strength_card, health_card, criticality_card, endurance_card, quickness_card, 
	resilience_card, weapon_mastery_card, simple_sword_card]
	shop_grid = $Shop/VBoxContainer/ShopGridContainer
	refresh_button = $Shop/VBoxContainer/HBoxContainer/RefreshButton
	inventory_grid = $Inventory/InventoryGridContainer
	#update_inventory_ui()
	await get_tree().create_timer(0.8).timeout
	roll_cards()
	
func _on_add_to_inventory_signal(peer_id: int, success: bool, _player_gladiator_data: Dictionary):
	if peer_id == multiplayer.get_unique_id():
		player_gladiator_data = _player_gladiator_data
		update_inventory_ui(peer_id)
	
func update_inventory_ui(glad_id: int):
	var gladiator_inventory = player_gladiator_data["inventory"]
	print("gladiator_inventory: " + str(gladiator_inventory))
	# Clear existing grid (optional, if you're reloading)
	for child in inventory_grid.get_children():
		child.queue_free()

	# Build a lookup from card name to PackedScene
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

func _on_item_popup_pressed(id: int):
	match id:
		0:
			print("Equip requested for ", selected_item_name, " from ", selected_slot)
			'''
			if multiplayer.is_server():
				GameState_.equip_item(multiplayer.get_unique_id(), "selected_slot")
			else:
				GameState_.rpc_id(1, "equip_item", multiplayer.get_unique_id(), "selected_slot")
			'''
		1:
			print("Sell requested for ", selected_item_name, " from ", selected_slot)
			#GameState_.sell_item(multiplayer.get_unique_id(), selected_slot)

	# Optionally repopulate UI after action
	update_inventory_ui(multiplayer.get_unique_id())


func _on_inventory_item_pressed(item_name: String, slot_name: String):
	# Store selected item info (you can make these class vars if needed)
	selected_item_name = item_name
	selected_slot = slot_name

	# Show popup near mouse
	item_popup.set_position(get_viewport().get_mouse_position())
	item_popup.popup()

	
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
	print("\n" + str(multiplayer.get_unique_id()) + "🃏reroll_cards: " + str(card_stock))
	all_cards = [[strength_card, "strength", card_stock["strength"]], [health_card, "health", card_stock["health"]], 
			[criticality_card, "crit_rating", card_stock["crit_rating"]], [endurance_card, "endurance", card_stock["endurance"]], 
			[quickness_card, "quickness", card_stock["quickness"]], [resilience_card, "resilience", card_stock["resilience"]], 
			[weapon_mastery_card, "weapon_skill", card_stock["weapon_skill"]], [simple_sword_card, "simple_sword", card_stock["simple_sword"]]]
			
	#print("owner: " + str(multiplayer.get_unique_id()))
			
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
	print("\n" + str(multiplayer.get_unique_id()) + "🃏weighted_random_selection: " + str(_all_cards))
	for pair in _all_cards:
		var item = pair[0]
		var stock = int(pair[2])
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
		if reroll_start_of_intermission:
			reroll_cards()
			reroll_start_of_intermission = 0
		#update_countdown_labels(time_left)
		if countdown_label: countdown_label.text = "⏳ %d" % time_left
		
		if time_left == 0:
			reroll_start_of_intermission = 1
			intermission = false
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
