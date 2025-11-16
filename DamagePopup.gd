extends Node2D

var float_speed = -30
var lifetime = 3
var direction = "up"
var side
var alternate = -1

func show_damage(amount, raw_damage, hit_success, dodge_success, crit, parry_success, spawn_point,
				 defender_weapon1_broken, defender_weapon2_broken, block_success, shield_absorb):
	if randf() > 0.5: alternate = 1
			
	var formatted : String		
	if int(amount) == amount:
		# It's effectively an integer
		formatted = str(int(amount))
	else:
		# Has decimals, show two
		formatted = "%.2f" % amount
		
	if not hit_success:
		customize_popup_font(Color.DARK_ORANGE, 30, "MISS", spawn_point, "up")
	elif raw_damage == -1: # THORNS OR BLOOD RAGE
		customize_popup_font(Color.PURPLE, 25, formatted, spawn_point, "behind")
	elif amount < 0: # SELF HEAL
		customize_popup_font(Color.GREEN, 25, "+"+str(int(abs(amount))), spawn_point, "down")
	elif dodge_success:
		customize_popup_font(Color.WHITE, 30, "DODGE", spawn_point, "up")
	elif block_success and defender_weapon2_broken == 0:
		customize_popup_font(Color.WHITE, 30, "BLOCK (" + str(int(clamp(raw_damage - shield_absorb, 0, 9999))) + ")", spawn_point, "up")
	elif block_success and defender_weapon2_broken == 1:
		customize_popup_font(Color.RED, 30, "🛡️DESTROYED", spawn_point, "up")
	elif parry_success and defender_weapon1_broken == 0 and defender_weapon2_broken == 0:
		customize_popup_font(Color.WHITE, 30, "PARRY (" + str(int(raw_damage)) + ")", spawn_point, "up")
	elif parry_success and defender_weapon1_broken == 1 and defender_weapon2_broken == 0:
		customize_popup_font(Color.RED, 30, "🗡️DESTROYED", spawn_point, "up")
	elif parry_success and defender_weapon1_broken == 0 and defender_weapon2_broken == 1:
		customize_popup_font(Color.RED, 30, "🗡️DESTROYED", spawn_point, "up")
	else:
		if crit != 1:
			customize_popup_font(Color.RED, 40, str(int(amount)), spawn_point, "up")
		else:
			customize_popup_font(Color.YELLOW, 30, str(int(amount)), spawn_point, "up")


func customize_popup_font(color: Color, size, text: String, spawn_point, _direction):
	direction = _direction
	$Label.add_theme_color_override("font_color", color) 
	$Label.add_theme_font_size_override("font_size", size)
	$Label.add_theme_color_override("font_outline_color", Color.BLACK)
	$Label.add_theme_constant_override("outline_size", 5)
	$Label.text = text
	side = find_spawn_side(spawn_point)
	if _direction == "up":
		if side == "left": 
			$Label.position.x = -100
			$Label.position.y = -100
		if side == "right": 
			$Label.position.x = 75
			$Label.position.y = -100
	
	if _direction == "behind":
		if side == "left": 
			$Label.position.x = -100
			#$Label.position.y = -100
		if side == "right": 
			$Label.position.x = 75
			#$Label.position.y = -100
			
	if _direction == "down":
		if side == "left": 
			$Label.position.x = -50
			$Label.position.y = 50
		if side == "right": 
			$Label.position.x = 55
			$Label.position.y = 50
	
	modulate.a = 1.0  # Fully visible

func find_spawn_side(target):
	for side in GameState_.spawn_points.keys():
		for point in GameState_.spawn_points[side]:
			if point == target:
				return side
	return "unknown"  # Or null if you prefer

func _process(delta):
	
	
	
	if direction == "up": 
		position.y += float_speed * delta
		position.x += alternate*0.25*float_speed * delta
	elif direction == "down": 
		position.y -= float_speed * delta
		position.x += alternate*0.25*float_speed * delta
	elif direction == "front" and side == "left": 
		position.x -= float_speed * delta
		position.y += alternate*0.25*float_speed * delta
	elif direction == "front" and side == "right":
		position.x += float_speed * delta
		position.y += alternate*0.25*float_speed * delta
	elif direction == "behind" and side == "left": 
		position.x += float_speed * delta
		position.y += alternate*0.25*float_speed * delta
	elif direction == "behind" and side == "right": 
		position.x -= float_speed * delta
		position.y += alternate*0.25*float_speed * delta
	
	
	modulate.a -= delta / lifetime
	if modulate.a <= 0:
		queue_free()
