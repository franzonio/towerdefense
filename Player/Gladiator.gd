extends CharacterBody2D

@onready var DamagePopupScene = preload("res://DamagePopup.tscn")

@onready var synchronizer = $MultiplayerSynchronizer

@onready var nav = $NavigationAgent2D
@onready var sprite = $Sprite
@onready var health_bar = $HealthBar
@onready var health_bar_text = $HealthBar/HealthBarText

@export var speed: float = 250.0
#@export var max_health: int = 100
#var current_health: int = max_health

#@export var name: String = ""
@export var race: String = ""
@export var attributes: Dictionary = {}

#@onready var nameLabel = $Name

#var velocity: Vector2 = Vector2.ZERO
@export var current_animation: String = "idle_down"
@export var prev_animation: String = "idle_down"

var input_vector := Vector2.ZERO

####
@export var weapon_dmg_min := 3
@export var weapon_dmg_max := 5
@export var weapon_req := 2.0
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
@export var next_attack_critical: bool = false
@export var next_taken_hit_critical: bool = false

 # === Calculations ===
@export var weight = 1
@export var move_speed := 0
@export var current_health = max_health
@export var armor = (1+sqrt(resilience)/10.0) * armor_absorb				# flat damage reduction
@export var dodge_chance = (avoidance/200.0) / ((avoidance/200.0)+1)		# decaying dodge_chance -> 1
@export var seconds_to_live = endurance/3.0

####


const ATTACK_RANGE := 160.0
@export var last_attack_time := -999.0

var current_attack_target: Node = null
var attack_charge_time: float = 0.0

var float_speed = -30
var lifetime = 30


# Only process input if this is OUR player
func _physics_process(delta):
	if is_multiplayer_authority():
		handle_input(delta)
		check_for_attack(delta)
	else:
		# Non-authority plays animation based on synced variable
		sprite.play(current_animation)
		

func _ready():
	print("👀 Gladiator node created on peer:", multiplayer.get_unique_id())
	print("🛠 Is multiplayer authority:", is_multiplayer_authority())
	add_to_group("gladiators")
	
	var replication_config = SceneReplicationConfig.new()
	
	if synchronizer:
		replication_config = {
							"position": {},
							"velocity": {},
							}

func check_for_attack(delta: float):
	if not is_multiplayer_authority():
		return
	
	var found_target = false

	for other in get_tree().get_nodes_in_group("gladiators"):
		#print(other)
		if other == self:
			continue
			
		if global_position.distance_to(other.global_position) < ATTACK_RANGE:
			current_attack_target = other
			found_target = true
			#break

		#if found_target:
			attack_charge_time += delta
			if attack_charge_time >= attack_speed:
				print("next attack critical: " + str(next_attack_critical))
				#print("next hit received critical: " + str(next_taken_hit_critical))
				CombatManager_.deal_attack(self, other, input_vector)
				attack_charge_time = 0.0
			#rpc_id(other.get_multiplayer_authority(), "receive_damage", strength)
			
		else:
			attack_charge_time = 0.0

@rpc("any_peer", "call_local")
func receive_damage(amount: int, hit_success, dodge_success, crit):
	if !hit_success or dodge_success:
		next_attack_critical = true
	
	current_health -= amount
	$HealthBar.value = current_health
	$HealthBar/HealthBarText.text = str(int(current_health))
	print(name + " took damage! Health now: ", current_health)

	rpc("show_damage_popup", amount, hit_success, dodge_success, crit)

	if current_health <= 0:
		rpc("die")

@rpc("any_peer", "call_local")
func die():
	set_physics_process(false)
	set_process(false)
	$CollisionShape2D.disabled = true
	sprite.stop()
	if not sprite.is_playing():
		sprite.play("die")
		sprite.animation_finished.connect(_on_die_animation_finished, CONNECT_ONE_SHOT)
	#queue_free()

func _on_die_animation_finished():
	if sprite.animation == "die":
		#GameState_.gladiator_alive = 0
		queue_free()

func handle_input(delta):
	input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity = input_vector * move_speed
	position += velocity * delta

	prev_animation = current_animation
	# Update animation
	if input_vector != Vector2.ZERO:
		if abs(input_vector.x) > abs(input_vector.y):
			current_animation = "walk_right" if input_vector.x > 0 else "walk_left"
		else:
			current_animation = "walk_down" if input_vector.y > 0 else "walk_up"
	else:
		if prev_animation == "walk_right": current_animation = "idle_right"
		elif prev_animation == "walk_left": current_animation = "idle_left"
		elif prev_animation == "walk_up": current_animation = "idle_up"
		elif prev_animation == "walk_down": current_animation = "idle_down"
		#else: current_animation = "idle_down"

	sprite.play(current_animation)


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
	weapon_req = 2.0
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
	move_speed = 1000.0
	current_health = max_health
	armor = (1+sqrt(resilience)/10.0) * armor_absorb				# flat damage reduction
	dodge_chance = (avoidance/200.0) / ((avoidance/200.0)+1)		# decaying dodge_chance -> 1
	seconds_to_live = endurance/3.0

	current_health = max_health
	$HealthBar.max_value = max_health
	$HealthBar.value = max_health
	$HealthBar/HealthBarText.text = str(int(max_health))


@rpc("any_peer", "call_local")
func show_damage_popup(amount, hit_success, dodge_success, crit):
	var popup = DamagePopupScene.instantiate()
	
	if prev_animation == "idle_left" or prev_animation == "walk_left": popup.global_position = global_position + Vector2(150, 40)
	elif prev_animation == "idle_right" or prev_animation == "walk_right": popup.global_position = global_position + Vector2(-150, 40)
	else: popup.global_position = global_position + Vector2(0, 40)
	
	popup.show_damage(amount, hit_success, dodge_success, crit)


	get_tree().current_scene.add_child(popup)

func show_damage_popup_old(amount: float, hit_success, dodge_success, crit):
	if not hit_success:
		customize_popup_font(Color.DARK_ORANGE, 30, "MISS")
	elif dodge_success:
		customize_popup_font(Color.WHITE, 30, "DODGE")
	else:
		if crit == 2:
			customize_popup_font(Color.RED, 55, str(int(amount)))
		else:
			customize_popup_font(Color.YELLOW, 44, str(int(amount)))


func customize_popup_font(color: Color, size, text: String):
		$Label.add_theme_color_override("font_color", color) 
		$Label.add_theme_font_size_override("font_size", size)
		$Label.text = text
		$Label.modulate.a = 1.0  # Fully visible
