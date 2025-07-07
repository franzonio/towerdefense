extends Node2D

#@onready var label = $Label
var float_speed = -30
var lifetime = 2

func show_damage(amount: float, hit_success, dodge_success):
	if not hit_success:
		#print("Color is now:", $Label.get_theme_color("font_color"))
		$Label.remove_theme_color_override("font_color")  # clear existing
		$Label.add_theme_color_override("font_color", Color.WHITE) 
		$Label.text = "MISS"
		#print("Color is now:", $Label.get_theme_color("font_color"))
		modulate.a = 1.0  # Fully visible
	elif dodge_success:
		$Label.text = "DODGE"
		modulate.a = 1.0  # Fully visible
	else:
		$Label.text = str(int(amount))
		modulate.a = 1.0  # Fully visible

func _process(delta):
	position.y += float_speed * delta
	modulate.a -= delta / lifetime
	if modulate.a <= 0:
		queue_free()
