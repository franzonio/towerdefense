extends CanvasLayer

func _ready():
	visible = false  # Hide initially
	$VBoxContainer/ResumeButton.pressed.connect(_on_resume_pressed)
	$VBoxContainer/MainMenuButton.pressed.connect(_on_main_menu_pressed)

func show_menu():
	visible = true
	#get_tree().paused = true

func hide_menu():
	visible = false
	#get_tree().paused = false

func _on_resume_pressed():
	hide_menu()

func _on_main_menu_pressed():
	
	if !multiplayer.is_server():
		#var color = player_colors[multiplayer.get_unique_id()]
		#var hex_color = color.to_html()
		var formatted = "[color=%s]%s[/color][color=%s] disconnected![/color]" % [Color.RED.to_html(), GameState_.selected_name, Color.RED.to_html()]
		rpc("broadcast_peer", multiplayer.get_unique_id(), formatted)
		await get_tree().create_timer(1.0).timeout # 11
		
		multiplayer.multiplayer_peer.close()
		get_tree().set_multiplayer(null)
	else: 
		#var color = player_colors[multiplayer.get_unique_id()]
		#var hex_color = color.to_html()
		var formatted = "[color=%s]%s[/color][color=%s] (host) disconnected![/color]" % [Color.RED.to_html(), GameState_.selected_name, Color.RED.to_html()]
		rpc("broadcast_peer", multiplayer.get_unique_id(), formatted)
		await get_tree().create_timer(1.0).timeout # 11
	
	#get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")  # Adjust if needed
