extends Camera2D

var dragging = false
var last_mouse_position = Vector2.ZERO
var zoom_step = 0.1
var min_zoom = 0.1
var max_zoom = 2.0

func _input(event):
	# Zoom with mouse wheel
	if event is InputEventMouseButton and event.pressed:
		var new_zoom = zoom
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			new_zoom -= Vector2(zoom_step, zoom_step)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			new_zoom += Vector2(zoom_step, zoom_step)

		# Clamp each axis individually
		new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
		new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)

		zoom = new_zoom

	# Drag camera with right mouse button
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			dragging = event.pressed
			last_mouse_position = event.position

	elif event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_position
		global_position -= delta * zoom
		last_mouse_position = event.position

