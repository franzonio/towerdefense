extends Camera2D

var dragging = false
var last_mouse_position = Vector2.ZERO
var zoom_step = 0.02
var min_zoom = 0.02
var max_zoom = 2.0

var target_zoom = Vector2(1, 1)
var zoom_speed = 8.0
var chat_input

func _ready():
	target_zoom = zoom


func _input(event):
	if event is InputEventMouse:
		var hud = get_parent().get_node("HUD")
		var chat_window = hud.get_node("Panel/ChatScroll")

		var mouse_pos = get_viewport().get_mouse_position()
		var rect = Rect2(chat_window.global_position, chat_window.size)

		if rect.has_point(mouse_pos):
			return
"\n\t# Zoom with mouse wheel\n\tif event is InputEventMouseButton and event.pressed:\n\t\tif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:\n\t\t\ttarget_zoom -= Vector2(zoom_step, zoom_step)\n\t\telif event.button_index == MOUSE_BUTTON_WHEEL_UP:\n\t\t\ttarget_zoom += Vector2(zoom_step, zoom_step)\n\n\t\ttarget_zoom.x = clamp(target_zoom.x, min_zoom, max_zoom)\n\t\ttarget_zoom.y = clamp(target_zoom.y, min_zoom, max_zoom)\n\n\t# Drag camera with right mouse button\n\tif event is InputEventMouseButton:\n\t\tif event.button_index == MOUSE_BUTTON_RIGHT:\n\t\t\tdragging = event.pressed\n\t\t\tlast_mouse_position = event.position\n\n\telif event is InputEventMouseMotion and dragging:\n\t\tvar delta = event.position - last_mouse_position\n\t\tglobal_position -= delta * zoom\n\t\tlast_mouse_position = event.position\n"






















func _process(delta):


	zoom = zoom.lerp(target_zoom, zoom_speed * delta)
