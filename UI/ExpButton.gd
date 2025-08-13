# BaseCard.gd
extends Button

var amount = 4
var cost = 5

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

'func _on_button_up():
	if mouse_inside_button:
		if multiplayer.is_server():
			GameState_.grant_exp_for_peer(multiplayer.get_unique_id(), amount, cost)
		else:
			GameState_.rpc_id(1, "grant_exp_for_peer", multiplayer.get_unique_id(), amount, cost)
	'
