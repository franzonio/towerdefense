extends Node2D

var float_speed = -30
var lifetime = 3

func show_damage(amount: float, hit_success, dodge_success, crit):
	if not hit_success:
		customize_popup_font(Color.DARK_ORANGE, 30, "MISS")
	elif dodge_success:
		customize_popup_font(Color.WHITE, 30, "DODGE")
	else:
		if crit == 2:
			customize_popup_font(Color.RED, 55, str(int(amount)))
		else:
			customize_popup_font(Color.YELLOW, 44, str(int(amount)))


func customize_popup_font(color: Color, size, text: String):
		$Label.add_theme_color_override("font_color", color) 
		$Label.add_theme_font_size_override("font_size", size)
		$Label.text = text
		
		modulate.a = 1.0  # Fully visible


func _process(delta):
	position.y += float_speed * delta
	modulate.a -= delta / lifetime
	if modulate.a <= 0:
		queue_free()
