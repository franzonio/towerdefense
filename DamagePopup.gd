extends Control

var float_speed = -30
var lifetime = 3
var direction = "up"
var side
var alternate = -1
var id
var equipment_panel
var eq_pos
var float_pos_x = 0
var float_pos_y = 0

func show_damage(amount, raw_damage, hit_success, dodge_success, crit, parry_success, spawn_point, 
				defender_weapon1_broken, defender_weapon2_broken, block_success, shield_absorb, winner = ""):
	if randf() > 0.5: alternate = 1

	$Label.z_index = 2000
	var hud = get_parent()  # Popup's parent is HUD
	equipment_panel = hud.get_node("_EquipmentPanel" + str(id))
	position = equipment_panel.position
	
	if winner == "WINNER":
		customize_popup_font(Color.GREEN, 40, "WINNER", spawn_point, "up")
	else:
		var formatted: String
		if int(amount) == amount:

			formatted = str(int(amount))
		else:

			formatted = "%.2f" % amount

		if not hit_success:
			customize_popup_font("cd8900", 30, "MISS", spawn_point, "up")
		elif raw_damage == -1:
			customize_popup_font("#b00098", 25, formatted, spawn_point, "behind")
		elif amount < 0:
			customize_popup_font(Color.GREEN, 25, "+" + str(int(abs(amount))), spawn_point, "down")
		elif dodge_success:
			customize_popup_font("d2c9a5", 30, "DODGE", spawn_point, "up")
		elif block_success and defender_weapon2_broken == 0:
			customize_popup_font("d2c9a5", 30, "BLOCK (" + str(int(clamp(raw_damage - shield_absorb, 0, 9999))) + ")", spawn_point, "up")
		elif block_success and defender_weapon2_broken == 1:
			customize_popup_font("d2004f", 30, "🛡️DESTROYED", spawn_point, "up")
		elif parry_success and defender_weapon1_broken == 0 and defender_weapon2_broken == 0:
			customize_popup_font("d2c9a5", 30, "PARRY (" + str(int(raw_damage)) + ")", spawn_point, "up")
		elif parry_success and defender_weapon1_broken == 1 and defender_weapon2_broken == 0:
			customize_popup_font("d2004f", 30, "🗡️DESTROYED", spawn_point, "up")
		elif parry_success and defender_weapon1_broken == 0 and defender_weapon2_broken == 1:
			customize_popup_font("d2004f", 30, "🗡️DESTROYED", spawn_point, "up")
		else:
			if crit != 1 and not block_success:
				customize_popup_font("d2004f", 40, str(int(amount)), spawn_point, "up")

			elif crit == 1 and not block_success:
				customize_popup_font("d2b600", 30, str(int(amount)), spawn_point, "up")


func customize_popup_font(color: Color, size, text: String, spawn_point, _direction, winner = ""):
	modulate.a = 0
	direction = _direction
	$Label.add_theme_color_override("font_color", color)
	$Label.add_theme_font_size_override("font_size", size)
	$Label.add_theme_color_override("font_outline_color", Color.BLACK)
	$Label.add_theme_constant_override("outline_size", 5)
	$Label.text = text
	side = find_spawn_side(spawn_point)
	if _direction == "up":
		if side == "left":
			$Label.position.x = 50
			$Label.position.y = 100
		if side == "right":
			$Label.position.x = 150
			$Label.position.y = 100

	if _direction == "behind":
		if side == "left":
			$Label.position.x = 0
			$Label.position.y = 100
		if side == "right":
			$Label.position.x = 180
			$Label.position.y = 100

	if _direction == "down":
		if side == "left":
			$Label.position.x = 50
			$Label.position.y = 200
		if side == "right":
			$Label.position.x = 150
			$Label.position.y = 200

	pivot_offset = Vector2($Label.position.x + 20, $Label.position.y + 11.5)


	modulate.a = 1.0

func find_spawn_side(target):
	for side in GameState_.spawn_points.keys():
		for point in GameState_.spawn_points[side]:
			if point == target:
				return side
	return "unknown"

func _process(delta):
	
	if equipment_panel != null: 
		eq_pos = equipment_panel.position
		position = eq_pos

	if direction == "up":
		float_pos_y += float_speed * delta
		float_pos_x += alternate * 0.25 * float_speed * delta
	elif direction == "down":
		float_pos_y -= float_speed * delta
		float_pos_x += alternate * 0.25 * float_speed * delta
	elif direction == "front" and side == "left":
		float_pos_x -= float_speed * delta
		float_pos_y += alternate * 0.25 * float_speed * delta
	elif direction == "front" and side == "right":
		float_pos_x += float_speed * delta
		float_pos_y += alternate * 0.25 * float_speed * delta
	elif direction == "behind" and side == "left":
		float_pos_x += float_speed * delta
		float_pos_y += alternate * 0.25 * float_speed * delta
	elif direction == "behind" and side == "right":
		float_pos_x -= float_speed * delta
		float_pos_y += alternate * 0.25 * float_speed * delta

	if eq_pos and float_pos_y and float_pos_x:
		position = eq_pos + Vector2(float_pos_x, float_pos_y)

	modulate.a -= delta / lifetime
	if modulate.a <= 0:
		queue_free()
