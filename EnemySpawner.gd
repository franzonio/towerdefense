extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_delay := 1.0  # Seconds between spawns

var enemy_scenes = {
	"GhastlyEye": preload("res://Enemies/GhastlyEye.tscn"),
	"Skeleton": preload("res://Enemies/Skeleton.tscn")
}

var wave_data = [["GhastlyEye", 0], ["Skeleton", 0]]

func _ready():
	spawn_wave(wave_data)

func spawn_wave(data):
	for entry in data:
		var type = entry[0]
		var count = entry[1]

		for i in range(count):
			spawn_enemy(type)
			await get_tree().create_timer(spawn_delay).timeout

func spawn_enemy(type_name: String):
	if not enemy_scenes.has(type_name):
		push_warning("Enemy type '%s' not found!" % type_name)
		return

	var enemy = enemy_scenes[type_name].instantiate()
	enemy.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", enemy)
