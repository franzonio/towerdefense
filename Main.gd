extends Node2D

@onready var pause_menu = $PauseMenu

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC by default
		if pause_menu.visible:
			pause_menu.hide_menu()
		else:
			pause_menu.show_menu()
