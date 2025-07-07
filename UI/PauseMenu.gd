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
	#get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")  # Adjust if needed
