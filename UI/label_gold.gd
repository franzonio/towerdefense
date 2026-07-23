extends RichTextLabel

var race_modifiers
var race: String
#var income_details = {}

@export var attribute_name: String = ""

var white = "d2c9a5"
var gold = "d2b600"

func _ready():
	pass
	
	
func get_income_details(income_details):
	tooltip_text = get_income_tooltip(income_details)

func _make_custom_tooltip(for_text):
	if modulate.a == 0:
		tooltip_text = ""
		return ""   # disables tooltip
	if for_text == "": 
		return
	
	var panel := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	
	sb.bg_color = Color("4d4539")            # background color
	sb.border_color = Color("gold")        # border color
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
	
	panel.add_child(label)
	
	return panel
	
func get_income_tooltip(income_details):
	print(income_details)
	var base = income_details.get("base", 0)
	var win = income_details.get("win", 0)
	var income = income_details.get("income", 0)
	var streak = income_details.get("streak", 0)
	var streak_break = income_details.get("streak_break", 0)
	var gold_gear = income_details.get("gear", 0)
	var total = base + win + income + streak + streak_break + gold_gear
	
	var income_text =  "[color=%s]Total:[/color] [color=%s]%s[/color]
[color=%s]Base:[/color] [color=%s]%s[/color]
[color=%s]Win:[/color] [color=%s]%s[/color]
[color=%s]Income:[/color] [color=%s]%s[/color]
[color=%s]Streak:[/color] [color=%s]%s[/color]
[color=%s]Buzzkiller:[/color] [color=%s]%s[/color]
[color=%s]Gear bonus:[/color] [color=%s]%s[/color]" % [gold, gold, total, white, gold, base, white, gold, win, white, gold, income, 
														white, gold, streak, white, gold, streak_break, white, gold, gold_gear]
	return income_text

# 		all_gladiators[id]["income_last_round"] = {
#		"base": base_amount, "win": win_bonus, "income": income_bonus, 
#		"streak": streak_bonus, "streak_break": streak_break_bonus, "gear": gold_from_gear}
