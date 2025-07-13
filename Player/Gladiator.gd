extends CharacterBody2D
@onready var synchronizer = $MultiplayerSynchronizer

@onready var nav = $NavigationAgent2D
@onready var sprite = $Sprite
@onready var health_bar = $HealthBar
@onready var health_bar_text = $HealthBar/HealthBarText

@export var speed: float = 100.0
#@export var max_health: int = 100
#var current_health: int = max_health

#@export var name: String = ""
@export var race: String = ""
@export var attributes: Dictionary = {}

#@onready var nameLabel = $Name

#var velocity: Vector2 = Vector2.ZERO
@export var current_animation: String = "idle"
var input_vector := Vector2.ZERO

####
@export var weapon_dmg_min := 3
@export var weapon_dmg_max := 5
@export var weapon_req := 20.0
@export var weapon_speed := 1
@export var weapon_range = 150
@export var weapon_crit := 1

@export var armor_absorb := 1


@export var strength := 1
@export var weapon_skill := 1
@export var quickness := 1
@export var crit_rating := 1
@export var avoidance := 1

@export var max_health := 1
@export var resilience := 1
@export var endurance := 1
 
 # === Damage calculations ===
@export var attack_speed: float = (1/weapon_speed)/(log(10+sqrt(quickness))/log(10))  # Seconds between attacks
@export var time_since_last_attack: float = 0.0
@export var crit_chance = weapon_crit*crit_rating/20.0
@export var hit_chance = (weapon_skill/weapon_req) - 0.20*weapon_skill/100
@export var next_attack_critical := false
@export var next_taken_hit_critical := false

 # === Calculations ===
@export var weight = 1
@export var move_speed := 350.0
@export var current_health = max_health
@export var armor = (1+sqrt(resilience)/10.0) * armor_absorb				# flat damage reduction
@export var dodge_chance = (avoidance/200.0) / ((avoidance/200.0)+1)		# decaying dodge_chance -> 1
@export var seconds_to_live = endurance/3.0

####


# Only process input if this is OUR player
func _physics_process(delta):
	if is_multiplayer_authority():
		var input_vector = Vector2(
			Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
			Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		).normalized()

		velocity = input_vector * 200
		position += velocity * delta

		# Update animation
		if input_vector != Vector2.ZERO:
			if abs(input_vector.x) > abs(input_vector.y):
				current_animation = "walk_right" if input_vector.x > 0 else "walk_left"
			else:
				current_animation = "walk_down" if input_vector.y > 0 else "walk_up"
		else:
			current_animation = "idle"

		sprite.play(current_animation)
	else:
		# Non-authority plays animation based on synced variable
		sprite.play(current_animation)
		
	

func _ready():
	print("👀 Gladiator node created on peer:", multiplayer.get_unique_id())
	print("🛠 Is multiplayer authority:", is_multiplayer_authority())
	
	var replication_config = SceneReplicationConfig.new()
	
	if synchronizer:
		replication_config = {
							"position": {},
							"velocity": {},
							}


func handle_input():
	input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	velocity = input_vector * speed

	# Animation update, optional
	update_animation(input_vector)

func update_animation(input_vector):
	if input_vector == Vector2.ZERO:
		return
	var dir = input_vector
	if abs(dir.x) > abs(dir.y):
		sprite.play("walk_right" if dir.x > 0 else "walk_left")
	else:
		sprite.play("walk_down" if dir.y > 0 else "walk_up")


func _multiplayer_post_spawn(data):
	print("🧬 Gladiator spawned with data:", data)
	initialize_gladiator(data)

# Called by the server to initialize this gladiator
#@rpc("any_peer", "call_local")
func initialize_gladiator(data: Dictionary):
	print("Initializing gladiator for " + data.name)
	print(data)
	weapon_dmg_min = 3
	weapon_dmg_max = 5
	weapon_req = 20.0
	weapon_speed = 1
	weapon_range = 150
	weapon_crit = 1
	armor_absorb = 1
	
	$Name.text = data.name
	strength = data["attributes"]["strength"]
	weapon_skill = data["attributes"]["weapon_skill"]
	quickness = data["attributes"]["quickness"]
	crit_rating = data["attributes"]["crit_rating"]
	avoidance = data["attributes"]["avoidance"]
	max_health = data["attributes"]["health"]
	resilience = data["attributes"]["resilience"]
	endurance = data["attributes"]["endurance"]

	# === Damage calculations ===
	attack_speed = (1/weapon_speed)/(log(10+sqrt(quickness))/log(10))  # Seconds between attacks
	time_since_last_attack = 0.0
	crit_chance = weapon_crit*crit_rating/20.0
	hit_chance = (weapon_skill/weapon_req) - 0.20*weapon_skill/100
	next_attack_critical = false
	next_taken_hit_critical = false

	# === Calculations ===
	weight = 1
	move_speed = 350.0
	current_health = max_health
	armor = (1+sqrt(resilience)/10.0) * armor_absorb				# flat damage reduction
	dodge_chance = (avoidance/200.0) / ((avoidance/200.0)+1)		# decaying dodge_chance -> 1
	seconds_to_live = endurance/3.0

	current_health = max_health
	$HealthBar.max_value = max_health
	$HealthBar.value = max_health
	$HealthBar/HealthBarText.text = str(int(max_health))

func gladiator_set_attributes(data: Dictionary):
	weapon_dmg_min = 3
	weapon_dmg_max = 5
	weapon_req = 20.0
	weapon_speed = 1
	weapon_range = 150
	weapon_crit = 1
	armor_absorb= 1
	
	#print(data.name)
	#print(get_multiplayer_authority())
	$Name.text = data.name
	strength = data["attributes"]["strength"]
	weapon_skill = data["attributes"]["weapon_skill"]
	quickness = data["attributes"]["quickness"]
	crit_rating = data["attributes"]["crit_rating"]
	avoidance = data["attributes"]["avoidance"]
	max_health = data["attributes"]["health"]
	resilience = data["attributes"]["resilience"]
	endurance = data["attributes"]["endurance"]

	# === Damage calculations ===
	attack_speed = (1/weapon_speed)/(log(10+sqrt(quickness))/log(10))  # Seconds between attacks
	time_since_last_attack = 0.0
	crit_chance = weapon_crit*crit_rating/20.0
	hit_chance = (weapon_skill/weapon_req) - 0.20*weapon_skill/100
	next_attack_critical = false
	next_taken_hit_critical = false

	# === Calculations ===
	weight = 1
	move_speed = 350.0
	current_health = max_health
	armor = (1+sqrt(resilience)/10.0) * armor_absorb				# flat damage reduction
	dodge_chance = (avoidance/200.0) / ((avoidance/200.0)+1)		# decaying dodge_chance -> 1
	seconds_to_live = endurance/3.0

	current_health = max_health
	$HealthBar.max_value = max_health
	$HealthBar.value = max_health
	$HealthBar/HealthBarText.text = str(int(max_health))
