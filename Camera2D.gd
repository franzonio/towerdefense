extends Camera2D

var dragging = false
var last_mouse_position = Vector2.ZERO
var zoom_step = 0.02
var min_zoom = 0.02
var max_zoom = 2.0

var target_zoom = Vector2(1, 1)
var zoom_speed = 8.0  # Higher = faster smoothing
var chat_input #= $HUD/ChatInput

func _ready():
	target_zoom = zoom

	
func _input(event):
	if event is InputEventMouse:
		var hud = get_parent().get_node("HUD")
		var chat_window = hud.get_node("Panel/ChatScroll")
		
		var mouse_pos = get_viewport().get_mouse_position()
		var rect = Rect2(chat_window.global_position, chat_window.size)
		
		if rect.has_point(mouse_pos):
			return  # Cursor is outside chat window, ignore input
'''
	# Zoom with mouse wheel
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom -= Vector2(zoom_step, zoom_step)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom += Vector2(zoom_step, zoom_step)

		target_zoom.x = clamp(target_zoom.x, min_zoom, max_zoom)
		target_zoom.y = clamp(target_zoom.y, min_zoom, max_zoom)

	# Drag camera with right mouse button
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			dragging = event.pressed
			last_mouse_position = event.position

	elif event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_position
		global_position -= delta * zoom
		last_mouse_position = event.position
'''

func _process(delta):
	
	# Smooth zoom transition
	zoom = zoom.lerp(target_zoom, zoom_speed * delta)
