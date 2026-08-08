extends Node2D

var gladiator_scene = preload("res://Player/Gladiator.tscn")


var weapon_dmg_min
var weapon_dmg_max
var weapon_req
var weapon_speed
var weapon_range
var weapon_crit

var armor_absorb


var strength
var weapon_skill
var quickness
var crit_rating
var avoidance

var max_health
var resilience
var endurance


var attack_speed
var time_since_last_attack
var crit_chance
var hit_chance
var next_attack_critical: = false
var next_taken_hit_critical: = false


var weight
var move_speed
var current_health
var armor
var dodge_chance
var seconds_to_live

@onready var spawn_points = $SpawnPoints.get_children()
@onready var meeting_points = $MeetingPoints.get_children()

var round_manager_scene: = preload("res://Scenes/RoundManager.tscn")

func _ready():

	GameState_.spawn_points["left"] = [
		$SpawnPoints / SpawnPoint0.position, 
		$SpawnPoints / SpawnPoint1.position, 
		$SpawnPoints / SpawnPoint2.position, 
		$SpawnPoints / SpawnPoint3.position
	]
	GameState_.spawn_points["right"] = [
		$SpawnPoints / SpawnPoint4.position, 
		$SpawnPoints / SpawnPoint5.position, 
		$SpawnPoints / SpawnPoint6.position, 
		$SpawnPoints / SpawnPoint7.position
	]
	GameState_.meeting_points = meeting_points

	var hud = preload("res://UI/HUD.tscn").instantiate()
	hud.name = "HUD"
	add_child(hud)

	$GladiatorSpawner.spawn_function = custom_spawn


	if multiplayer.is_server():
		var round_manager = round_manager_scene.instantiate()
		add_child(round_manager)


func custom_spawn(args: Dictionary) -> Node:
	var scene_path = args.get("scene", "")
	var peer_id = args.get("peer_id", 1)
	var gladiator_data = args.get("gladiator_data", {})
	var opponent_id = args.get("opponent_id", {})
	var spawn_point = args.get("spawn_point", {})
	var meeting_point = args.get("meeting_point", {})

	var scene = load(scene_path)
	var instance = scene.instantiate()


	instance.set_multiplayer_authority(peer_id)


	if instance.has_method("initialize_gladiator"):
		instance.initialize_gladiator(gladiator_data, opponent_id, spawn_point, meeting_point, peer_id)

	return instance
