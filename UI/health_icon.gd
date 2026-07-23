extends Button

var race_modifiers
var race: String

@export var attribute_name: String = ""

var pos_bonus_color = "77c33b"
var neg_bonus_color = "d2004f"
var normal_text_color = "efd8a1"
var no_bonus_color = "d2b600"

func _ready():
	race_modifiers = GameState_.RACE_MODIFIERS

func set_race(_race):
	race = _race
	tooltip_text = get_attribute_tooltip()

func _make_custom_tooltip(for_text):
	if modulate.a == 0:
		tooltip_text = ""
		return ""
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

func get_attribute_tooltip():
	var attribute_text = ""
	var race_mod = race_modifiers[race][attribute_name]
	var attr = attribute_name.replace("_mastery", "").capitalize()


	if race_mod == 1: attribute_text = "[color=%s]%s [/color][color=%s]x %s[/color]" % [normal_text_color, attr, no_bonus_color, race_mod]
	elif race_mod > 1: attribute_text = "[color=%s]%s [/color][color=%s]x %s[/color]" % [normal_text_color, attr, pos_bonus_color, race_mod]
	elif race_mod < 1: attribute_text = "[color=%s]%s [/color][color=%s]x %s[/color]" % [normal_text_color, attr, neg_bonus_color, race_mod]


	return attribute_text
