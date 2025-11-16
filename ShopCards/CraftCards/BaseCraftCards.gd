# BaseCard.gd
extends Button

@export var craft_name: String = ""
#@export var amount: int
@export var cost: int
var name_label
var parent_name
var all_gladiators

var mouse_inside_button := false
var added := false

var name_color := "ef692f"#Color.GOLD.to_html(false)
var base_text_color := "927e6a"#Color.DARK_GRAY.to_html(false)
var base_value_color := "efd8a1"#Color.WHITE_SMOKE.to_html(false)
var req_ok_color := "efd8a1"#Color.WHITE_SMOKE.to_html(false)
var req_nok_color := "79444a"#Color.RED.to_html(false)
var mod_color := "3c9f9c"#Color.DODGER_BLUE.to_html(false)

var label_display

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	GameState_.connect("card_buy_result", Callable(self, "_on_card_buy_result"))
	GameState_.connect("send_equipment_dict_to_peer_signal", Callable(self, "_on_send_equipment_dict_to_peer"))
	GameState_.connect("send_gladiator_data_to_peer_card_signal", Callable(self, "_on_send_gladiator_data_to_peer_card_signal"))
	GameState_.connect("update_equipment_card_signal", Callable(self, "_on_equipment_card_updated"))
	GameState_.connect("signal_update_gold_req_in_shop_for_peer", Callable(self, "_on_update_gold_req_shop"))
	
	if multiplayer.is_server():
		GameState_.refresh_gladiator_data_card(multiplayer.get_unique_id())
	else:
		GameState_.rpc_id(1, "refresh_gladiator_data_card", multiplayer.get_unique_id())
		
	parent_name = get_parent().name
	if parent_name == "ShopGridContainer":
		label_display = format_name(craft_name)
		name_label = RichTextLabel.new()
		name_label.add_theme_font_size_override("normal_font_size", 26)
		name_label.add_theme_font_size_override("bold_font_size", 26)
		name_label.bbcode_enabled = true
		name_label.fit_content = true
		name_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		name_label.scroll_active = false
		name_label.position.y = 15
		name_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
		name_label.add_theme_color_override("font_outline_color", Color.BLACK)
		name_label.add_theme_constant_override("outline_size", 5)
		
		add_child(name_label)
		if all_gladiators != null:
			_on_update_gold_req_shop(multiplayer.get_unique_id(), all_gladiators[multiplayer.get_unique_id()]["gold"])

		

func _make_custom_tooltip(for_text):
	
	var label = RichTextLabel.new()
	label.add_theme_font_size_override("normal_font_size", 20)
	label.add_theme_font_size_override("bold_font_size", 20)
	label.bbcode_text = for_text
	label.bbcode_enabled = true
	label.fit_content = true
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.scroll_active = false
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 5)
	
	return label

func _on_update_gold_req_shop(_id, gold):
	if parent_name == "ShopGridContainer":
		if gold < cost:
			name_label.bbcode_text = "[color=%s]%s[/color] \n💰[color=%s]%d[/color] " % [mod_color, label_display, req_nok_color, cost] 
		else:
			name_label.bbcode_text = "[color=%s]%s[/color] \n💰%d " % [mod_color, label_display, cost] 


func _on_send_gladiator_data_to_peer_card_signal(_peer_id: int, _player_gladiator_data: Dictionary, _all_gladiators):
	all_gladiators = _all_gladiators
	_on_update_gold_req_shop(multiplayer.get_unique_id(), all_gladiators[multiplayer.get_unique_id()]["gold"])
	tooltip_text = get_craft_tooltip(craft_name)

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

func get_craft_tooltip(_craft_name):
	var craft_text = ""
	if _craft_name == "tome_of_chaos":
		craft_text = "Rerolls an item with new modifiers"
	elif _craft_name == "tome_of_injection":
		craft_text = "Adds an additional modifier on an item"
	elif _craft_name == "tome_of_refinement":
		craft_text = "Rerolls the numeric values of existing modifiers on an item"
	
	return craft_text
	
	
