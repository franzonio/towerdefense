extends Button
var mouse_inside_button := false

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	mouse_inside_button = true
	var tween := get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_mouse_exited():
	mouse_inside_button = false
	var tween := get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _on_button_up():
	if mouse_inside_button:
		if multiplayer.is_server():
			GameState_.modify_attribute(multiplayer.get_unique_id(), 5, "health")
		else:
			GameState_.rpc_id(1, "modify_attribute", multiplayer.get_unique_id(), 5, "health")
			
		mouse_inside_button = false
		disabled = true
		var tween := get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 0, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
