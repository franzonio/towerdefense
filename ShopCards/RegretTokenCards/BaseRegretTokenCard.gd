extends Button

@export var attribute_name: String = ""
@export var amount: int
@export var cost: int
var name_label
var cost_label
var parent_name
var all_gladiators

var mouse_inside_button: = false
var added: = false

var name_color: = "#d2c9a5"
var base_text_color: = "927e6a"
var base_value_color: = "efd8a1"
var req_ok_color: = "efd8a1"
var req_nok_color: = "79444a"
var mod_color: = "3c9f9c"

var label_display
var race_modifiers

var pos_bonus_color = "77c33b"
var neg_bonus_color = "d2004f"
var normal_text_color = "efd8a1"
var no_bonus_color = "d2b600"

func _ready():
	add_theme_color_override("icon_hover_color", Color(1.27, 1.27, 1.27, 1.0))
	add_theme_color_override("icon_disabled_color", "ffffff")
	add_theme_color_override("icon_hover_pressed_color", "ffffffb5")
	add_theme_color_override("icon_pressed_color", "ffffffb5")

	flat = true
	pivot_offset = size / 2

	set_texture_filter(CanvasItem.TEXTURE_FILTER_NEAREST)
	race_modifiers = GameState_.RACE_MODIFIERS
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
	if parent_name.contains("shop"):
		label_display = format_name(attribute_name)
		label_display = label_display.substr(0, label_display.length() - 2)
		name_label = RichTextLabel.new()
		name_label.add_theme_font_size_override("normal_font_size", 22)
		name_label.add_theme_font_size_override("bold_font_size", 22)
		name_label.bbcode_enabled = true
		name_label.fit_content = false
		name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		name_label.scroll_active = false
		name_label.position.y = -12
		name_label.position.x = 30
		name_label.size = Vector2(128, 128)
		name_label.add_theme_color_override("font_outline_color", Color("#4b3d44"))
		name_label.add_theme_constant_override("outline_size", 12)
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
		cost_label.position.y = 120
		cost_label.position.x = 30
		cost_label.size = Vector2(128, 128)
		cost_label.add_theme_color_override("font_outline_color", Color("4d4539"))
		cost_label.add_theme_constant_override("outline_size", 8)
		cost_label["show_behind_parent"] = false
		cost_label.mouse_filter = Control.MOUSE_FILTER_IGNORE

		add_child(cost_label)
		add_child(name_label)
		if all_gladiators != null:
			_on_update_gold_req_shop(multiplayer.get_unique_id(), all_gladiators["gold"])

func _make_custom_tooltip(for_text):
	if modulate.a == 0:
		tooltip_text = ""
		return ""
	if for_text == "":
		return


	var panel: = PanelContainer.new()
	var sb: = StyleBoxFlat.new()

	sb.bg_color = Color("4d4539")
	sb.border_color = Color("#77883b")
	sb.border_width_left = 2
	sb.border_width_right = 2
	sb.border_width_top = 2
	sb.border_width_bottom = 2
	sb.corner_radius_bottom_left = 6
	sb.corner_radius_bottom_right = 6
	sb.corner_radius_top_left = 6
	sb.corner_radius_top_right = 6
	sb.content_margin_left = 8
	sb.content_margin_right = 8
	sb.content_margin_top = 6
	sb.content_margin_bottom = 6

	panel.add_theme_stylebox_override("panel", sb)

	var label = RichTextLabel.new()
	label.set_texture_filter(CanvasItem.TEXTURE_FILTER_NEAREST)
	label.add_theme_font_size_override("normal_font_size", 24)
	label.add_theme_font_size_override("bold_font_size", 24)
	label.bbcode_text = for_text
	label.bbcode_enabled = true
	label.fit_content = true
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.scroll_active = false
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 12)

	panel.add_child(label)

	return panel

func _on_update_gold_req_shop(_id, gold):
	var color = "8caba1"
	var gold_color = "#d2b600"

	if parent_name and parent_name.contains("shop"):
		if gold < cost:
			name_label.bbcode_text = "[color=%s]+%d %s[/color]" % [color, amount, label_display]
			cost_label.bbcode_text = "[color=%s]$ %d[/color]" % [req_nok_color, cost]
		else:
			name_label.bbcode_text = "[color=%s]+%d %s[/color]" % [color, amount, label_display]
			cost_label.bbcode_text = "[color=%s]$ %d[/color]" % [gold_color, cost]


func _on_send_gladiator_data_to_peer_card_signal(_peer_id: int, _player_gladiator_data: Dictionary):
	all_gladiators = _player_gladiator_data
	_on_update_gold_req_shop(multiplayer.get_unique_id(), all_gladiators["gold"])
	tooltip_text = get_attribute_tooltip(attribute_name)

func format_name(raw_name: String) -> String:
	var parts = raw_name.split("_")
	var joined = ""
	for i in parts.size():
		joined += parts[i]
		if i < parts.size() - 1:
			joined += " "
	return joined.capitalize()

func _on_mouse_entered():

	pivot_offset = size / 2
	mouse_inside_button = true
	var tween: = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_mouse_exited():
	mouse_inside_button = false
	var tween: = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _on_button_up():
	var _parent_name = get_parent().name

	if _parent_name.contains("shop"):
		if is_multiplayer_authority(): buy_card()
	if _parent_name == "InventoryGridContainer":
		if is_multiplayer_authority(): handle_inventory()
		#print("Pressed inventory slot")

func handle_inventory(): pass

func buy_card():
	if not attribute_name:
		push_error("Card attribute_name is not set!")
		return

	if mouse_inside_button:
		added = false
		var id: = multiplayer.get_unique_id()

		if attribute_name.contains("regret"):
			if multiplayer.is_server():
				GameState_.buy_regret_token_card(id, amount, attribute_name, cost, true, parent_name)
			else:
				GameState_.rpc_id(1, "buy_regret_token_card", id, amount, attribute_name, cost, true, parent_name)

		disabled = true
		#await get_tree().create_timer(0.15).timeout

		'''
		if added:
			tooltip_text = ""

			mouse_inside_button = false
			disabled = true


			var tween: = get_tree().create_tween()
			tween.tween_property(self, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			TweenFX.fold_out(self, 0.2)
		else: disabled = false
		'''

func _on_card_buy_result(peer_id: int, success: bool, _parent_name):
	if peer_id == multiplayer.get_unique_id():
		if parent_name == _parent_name:
			if success:
				tooltip_text = ""
				mouse_inside_button = false
				disabled = true
				var tween: = get_tree().create_tween()
				tween.tween_property(self, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				TweenFX.fold_out(self, 0.2)
			else: 
				disabled = false

func get_attribute_tooltip(_attribute_name):
	return ""
