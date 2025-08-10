extends Node2D

var float_speed = -40
var lifetime = 4

func show_damage(amount: float, hit_success, dodge_success, crit, parry_success, spawn_point, defender_weapon1_broken, defender_weapon2_broken):
	if not hit_success:
		customize_popup_font(Color.DARK_ORANGE, 30, "MISS", spawn_point)
	elif dodge_success:
		customize_popup_font(Color.WHITE, 30, "DODGE", spawn_point)
	elif parry_success and defender_weapon1_broken == 0 and defender_weapon2_broken == 0:
		customize_popup_font(Color.WHITE, 30, "PARRY", spawn_point)
	elif parry_success and defender_weapon1_broken == 1 and defender_weapon2_broken == 0:
		customize_popup_font(Color.RED, 30, "🗡️DESTROYED", spawn_point)
	elif parry_success and defender_weapon1_broken == 0 and defender_weapon2_broken == 1:
		customize_popup_font(Color.RED, 30, "🗡️DESTROYED", spawn_point)
	else:
		if crit == 2:
			customize_popup_font(Color.RED, 55, str(int(amount)), spawn_point)
		else:
			customize_popup_font(Color.YELLOW, 44, str(int(amount)), spawn_point)


func customize_popup_font(color: Color, size, text: String, spawn_point):
		$Label.add_theme_color_override("font_color", color) 
		$Label.add_theme_font_size_override("font_size", size)
		$Label.text = text
		var side = find_spawn_side(spawn_point)
		if side == "left": $Label.position.x = -150
		if side == "right": $Label.position.x = 150
		
		modulate.a = 1.0  # Fully visible

func find_spawn_side(target):
	for side in GameState_.spawn_points.keys():
		for point in GameState_.spawn_points[side]:
			if point == target:
				return side
	return "unknown"  # Or null if you prefer

func _process(delta):
	position.y += float_speed * delta
	modulate.a -= delta / lifetime
	if modulate.a <= 0:
		queue_free()
