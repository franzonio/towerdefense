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

var name_color := "B00098"#Color.GOLD.to_html(false)
var base_text_color := "927e6a"#Color.DARK_GRAY.to_html(false)
var base_value_color := "efd8a1"#Color.WHITE_SMOKE.to_html(false)
var req_ok_color := "efd8a1"#Color.WHITE_SMOKE.to_html(false)
var req_nok_color := "79444a"#Color.RED.to_html(false)
var mod_color := "B00098"#Color.DODGER_BLUE.to_html(false)

var label_display
var cost_label

func _ready():
	add_theme_color_override("icon_hover_color", Color(1.27, 1.27, 1.27, 1.0))#"ffffffb5") #b00098
	add_theme_color_override("icon_disabled_color", "ffffff")
	add_theme_color_override("icon_hover_pressed_color", "ffffffb5")
	add_theme_color_override("icon_pressed_color", "ffffffb5")
	flat = true
	pivot_offset = Vector2(128,128)
	
	set_texture_filter(CanvasItem.TEXTURE_FILTER_NEAREST)
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
		name_label.add_theme_font_size_override("normal_font_size", 22)
		name_label.add_theme_font_size_override("bold_font_size", 22)
		name_label.bbcode_enabled = true
		name_label.fit_content = false
		name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		name_label.scroll_active = false
		name_label.position.y = -70
		name_label.position.x = 30
		name_label.size = Vector2(128,128)
		name_label.add_theme_color_override("font_outline_color", Color.BLACK)
		name_label.add_theme_constant_override("outline_size", 5)
		name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		cost_label = RichTextLabel.new()
		cost_label.add_theme_font_size_override("normal_font_size", 32)
		cost_label.add_theme_font_size_override("bold_font_size", 32)
		cost_label.bbcode_enabled = true
		cost_label.fit_content = false
		cost_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		cost_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cost_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		cost_label.scroll_active = false
		cost_label.position.y = 158
		cost_label.position.x = 30#100
		cost_label.size = Vector2(128,128)
		cost_label.add_theme_color_override("font_outline_color", Color.BLACK)
		cost_label.add_theme_constant_override("outline_size", 5)
		cost_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		add_child(cost_label)
		add_child(name_label)
		if all_gladiators != null:
			_on_update_gold_req_shop(multiplayer.get_unique_id(), all_gladiators[multiplayer.get_unique_id()]["gold"])

		

func _make_custom_tooltip(for_text):
	if modulate.a == 0:
		tooltip_text = ""
		return ""   # disables tooltip
	if for_text == "": 
		return
		
	var label = RichTextLabel.new()
	label.set_texture_filter(CanvasItem.TEXTURE_FILTER_NEAREST)
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
	#var color = "#CD8900"
	var gold_color = "#d2b600"
	
	if parent_name == "ShopGridContainer":
		if gold < cost:
			name_label.bbcode_text = "[color=%s]%s[/color]" % [name_color, label_display] 
			cost_label.bbcode_text = "[color=%s]%d[/color]" 	% [req_nok_color, cost]
		else:
			name_label.bbcode_text = "[color=%s]%s[/color]" % [name_color, label_display] 
			cost_label.bbcode_text = "[color=%s]$ %d[/color]" 	% [gold_color, cost]


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
	pivot_offset = size / 2
	
	var tween := get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#tween.tween_property(self, "position", Vector2.RIGHT * 300, 1.0).as_relative().set_trans(Tween.TRANS_SINE)
	#tween.tween_property(self, "position", Vector2.RIGHT * 300, 1.0).as_relative().from_current().set_trans(Tween.TRANS_EXPO)
	


	

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
			tooltip_text = ""
			print("💰Bought " + craft_name + " card")
			mouse_inside_button = false
			disabled = true
			var tween := get_tree().create_tween()
			tween.tween_property(self, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			TweenFX.fold_out(self, 0.2)
			
			
			

func _on_card_buy_result(peer_id: int, success: bool, _gladiator_data):
	if peer_id == multiplayer.get_unique_id():
		added = success

func get_craft_tooltip(_craft_name):
	var craft_text = ""
	if _craft_name == "scroll_of_luck":
		craft_text = "Rerolls an item with new modifiers"
	elif _craft_name == "scroll_of_injection":
		craft_text = "Adds an additional modifier on an item"
	elif _craft_name == "scroll_of_refinement":
		craft_text = "Rerolls the numeric values of existing modifiers on an item"
	
	return craft_text
	
	
