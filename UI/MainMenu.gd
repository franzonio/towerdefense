extends Control

var lobby = preload("res://Scenes/Lobby.tscn").instantiate()

func _ready():
	$VBoxContainer/StartButton.pressed.connect(on_start_pressed)
	$VBoxContainer/OptionsButton.pressed.connect(on_options_pressed)
	$VBoxContainer/ExitButton.pressed.connect(on_exit_pressed)
	


func on_start_pressed():
	#add_child(lobby)
	get_tree().change_scene_to_file("res://Scenes/Lobby.tscn")
	
	
	#get_tree().change_scene_to_file("res://UI/RaceSelection.tscn")
	#get_tree().change_scene_to_file("res://Main.tscn")  # <-- Replace with your actual game scene

func on_options_pressed():
	print("Options clicked - not implemented yet")

func on_exit_pressed():
	get_tree().quit()
