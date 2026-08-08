extends Camera2D

var dragging = false
var last_mouse_position = Vector2.ZERO
var zoom_step = 0.02
var min_zoom = 0.02
var max_zoom = 2.0

var target_zoom = Vector2(1, 1)
var zoom_speed = 8.0
var chat_input

var previous_camera_pos := Vector2.ZERO
var hud #= get_node("/root/Main/HUD")

var cam_pos_limit_top
var cam_pos_limit_left
var cam_pos_limit_right 
var cam_pos_limit_bottom

func _ready():
	target_zoom = zoom
	previous_camera_pos = global_position
	
	cam_pos_limit_top = limit_top + 1080.0/2.0
	cam_pos_limit_left = limit_left + 1920.0/2.0
	cam_pos_limit_right = limit_right - 1920.0/2.0
	cam_pos_limit_bottom = limit_bottom - 1080.0/2.0
	

func _input(event):
	if event is InputEventMouse:
		var mouse_pos = get_viewport().get_mouse_position()
		
		var hud = get_parent().get_node("HUD")
		var chat_window = hud.get_node("Panel/ChatScroll")
		var shop_window = hud.get_node("ShopGridContainer")
		var inventory_window = hud.get_node("Inventory")
		var equipment_windows = hud.get_tree().get_nodes_in_group("equipment_panels")
		
		"CraftingContainer"
		"ConcedePanel"
		"AttackPanel"
		"StancePanel"
		"AttributePanel"

		
		var chat_rect = Rect2(chat_window.global_position, chat_window.size)
		var shop_rect = Rect2(shop_window.global_position, shop_window.size)
		var inventory_rect = Rect2(inventory_window.global_position, inventory_window.size)

		if event is InputEventMouseButton and not dragging:
			if event.button_index == MOUSE_BUTTON_LEFT:
				for node in equipment_windows:
					var equipment_rect = Rect2(node.global_position, node.size)
					if equipment_rect.has_point(mouse_pos):
						return
				if chat_rect.has_point(mouse_pos):
					return
				if shop_rect.has_point(mouse_pos):
					return
				if inventory_rect.has_point(mouse_pos):
					return
	# Zoom with mouse wheel
	
	'if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom -= Vector2(zoom_step, zoom_step)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom += Vector2(zoom_step, zoom_step)

		target_zoom.x = clamp(target_zoom.x, min_zoom, max_zoom)
		target_zoom.y = clamp(target_zoom.y, min_zoom, max_zoom)'

	# Drag camera with right mouse button
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			last_mouse_position = event.position

	elif event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_position
		global_position -= delta * zoom
		last_mouse_position = event.position





func _process(delta):
	var cam := self
	
	if hud == null:
		hud = get_node("/root/Main/HUD")
		
	if cam.global_position.x > cam_pos_limit_right: 
		cam.global_position.x = cam_pos_limit_right
		previous_camera_pos.x = cam_pos_limit_right
		
	if cam.global_position.y > cam_pos_limit_bottom: 
		cam.global_position.y = cam_pos_limit_bottom
		previous_camera_pos.y = cam_pos_limit_bottom
	
	if cam.global_position.x < cam_pos_limit_left: 
		cam.global_position.x = cam_pos_limit_left
		previous_camera_pos.x = cam_pos_limit_left
		
	if cam.global_position.y < cam_pos_limit_top: 
		cam.global_position.y = cam_pos_limit_top
		previous_camera_pos.y = cam_pos_limit_top
		
	if Input.is_key_pressed(KEY_SPACE):
		var id = multiplayer.get_unique_id()
		var spawn_point = hud.player_gladiator_data["spawn_point"]
		previous_camera_pos = cam.global_position 
		cam.global_position = spawn_point
		hud.update_equipment_panel_position()
	# Only update HUD positions if camera actually moved 
	else: 
		if cam.global_position != previous_camera_pos:
			previous_camera_pos = cam.global_position
			hud.update_equipment_panel_position()
		

	zoom = zoom.lerp(target_zoom, zoom_speed * delta)
