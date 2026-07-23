extends OptionButton

var tooltiptext = ""

func _ready():
	tooltip_text = get_tooltip_string()

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
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.scroll_active = false
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 5)
	
	return label
	
func get_tooltip_string():
	
	var t = "Normal - no impact\nOffensive - increases attack speed and criticality, but reduces dodge and parry chance\nDefensive - increases dodge and parry chance, but reduces attack speed and criticality\nJester - reduces enemy hit chance, but reduces your endurance"
	
	tooltiptext = "[color=%s]%s[/color]" % ["d2c9a5", t]
	
	return tooltiptext
