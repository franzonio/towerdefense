extends Node2D

var gladiator_scene = preload("res://Player/Gladiator.tscn")
@onready var pause_menu = $PauseMenu

var weapon_dmg_min# := 3
var weapon_dmg_max# := 5
var weapon_req# := 20.0
var weapon_speed# := 1
var weapon_range# = 150
var weapon_crit# := 1

var armor_absorb# := 1


var strength#: int = GameState_.gladiator_attributes["strength"]
var weapon_skill#: int = GameState_.gladiator_attributes["weapon_skill"]
var quickness#: int = GameState_.gladiator_attributes["quickness"]
var crit_rating#: int = GameState_.gladiator_attributes["crit_rating"]
var avoidance#: int = GameState_.gladiator_attributes["avoidance"]

var max_health#: int = GameState_.gladiator_attributes["health"]
var resilience#: int = GameState_.gladiator_attributes["resilience"]
var endurance#: int = GameState_.gladiator_attributes["endurance"]

# === Damage calculations ===
var attack_speed#: float = (1/weapon_speed)/(log(10+sqrt(quickness))/log(10))  # Seconds between attacks
var time_since_last_attack#: float = 0.0
var crit_chance# = weapon_crit*crit_rating/20.0
var hit_chance# = (weapon_skill/weapon_req) - 0.20*weapon_skill/100
var next_attack_critical := false
var next_taken_hit_critical := false

# === Calculations ===
var weight #= 1
var move_speed #:= 350.0
var current_health #:= max_health
var armor #:= (1+sqrt(resilience)/10.0) * armor_absorb				# flat damage reduction
var dodge_chance #:= (avoidance/200.0) / ((avoidance/200.0)+1)		# decaying dodge_chance -> 1
var seconds_to_live #:= endurance/3.0



func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC by default
		if pause_menu.visible:
			pause_menu.hide_menu()
		else:
			pause_menu.show_menu()

func _ready():
	#if multiplayer.is_server():
	#	get_tree().get_multiplayer().set_root_node(self)  # ✅ Correct
	
	var hud = preload("res://UI/HUD.tscn").instantiate()
	add_child(hud)
	$GladiatorSpawner.spawn_function = custom_spawn
	
	if multiplayer.is_server():
		spawn_all_gladiators()

func spawn_all_gladiators():
	for peer_id in GameState_.all_gladiators.keys():
		var data = GameState_.all_gladiators[peer_id]

		var spawn_data = {
			"gladiator_data": data
		}
		var gladiator = $GladiatorSpawner.spawn({
							"scene": "res://Player/Gladiator.tscn",
							"peer_id": peer_id,
							"gladiator_data": data
							})



		print("✅ Spawned gladiator '" + data.name + "' (peer: %d) on the arena." % [peer_id])
		gladiator.global_position = Vector2(100+randi_range(300,800), 200)
		#gladiator.gladiator_set_attributes(data)
		#gladiator.rpc_id(peer_id, "initialize_gladiator", data)


func custom_spawn(args: Dictionary) -> Node:
	var scene_path = args.get("scene", "")
	var peer_id = args.get("peer_id", 1)  # Default to 1 if missing
	var gladiator_data = args.get("gladiator_data", {})

	var scene = load(scene_path)
	var instance = scene.instantiate()

	# Set authority (very important)
	instance.set_multiplayer_authority(peer_id)

	# Call init
	if instance.has_method("initialize_gladiator"):
		instance.initialize_gladiator(gladiator_data)

	return instance
