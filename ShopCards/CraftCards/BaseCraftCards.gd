# BaseCard.gd
extends Button

@export var craft_name: String = ""
#@export var amount: int
@export var cost: int
var label
var parent_name

var mouse_inside_button := false
var added := false


func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	GameState_.connect("card_buy_result", Callable(self, "_on_card_buy_result"))
	parent_name = get_parent().name
	if parent_name == "ShopGridContainer":
		var label_display = format_name(craft_name)
		label = $Label
		label.text = label_display+"\n💰" + str(cost)

func format_name(raw_name: String) -> String:
	var parts = raw_name.split("_")            # → ["simple", "sword"]
	var joined = ""                            
	for i in parts.size():
		joined += parts[i]
		if i < parts.size() - 1:
			joined += " "
	return joined.capitalize()                 # → "Simple Sword"

func _on_mouse_entered():
	mouse_inside_button = true
	var tween := get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_mouse_exited():
	mouse_inside_button = false
	var tween := get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _on_button_up():
	var _parent_name = get_parent().name
	
	if _parent_name == "ShopGridContainer": 
		if is_multiplayer_authority(): buy_card()
	if _parent_name == "InventoryGridContainer": 
		if is_multiplayer_authority(): handle_inventory()
		print("Pressed inventory slot")

func handle_inventory(): pass

func buy_card():
	if not craft_name:
		push_error("Card attribute_name is not set!")
		return

	if mouse_inside_button:
		added = false
		var id := multiplayer.get_unique_id()
		
		if multiplayer.is_server():
			GameState_.buy_craft_card(id, craft_name, cost)
		else:
			GameState_.rpc_id(1, "buy_craft_card", id, craft_name, cost)

		await get_tree().create_timer(0.15).timeout
		#print(added)
		if added:
			print("💰Bought " + craft_name + " card")
			mouse_inside_button = false
			disabled = true
			var tween := get_tree().create_tween()
			tween.tween_property(self, "modulate:a", 0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_card_buy_result(peer_id: int, success: bool, _gladiator_data):
	if peer_id == multiplayer.get_unique_id():
		added = success
