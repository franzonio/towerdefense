extends Node2D

@export var enemy_scene: PackedScene
@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	var enemy = enemy_scene.instantiate()
	enemy.global_position = global_position
	get_tree().current_scene.add_child(enemy)
