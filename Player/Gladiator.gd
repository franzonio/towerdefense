extends CharacterBody2D

@onready var DamagePopupScene = preload("res://DamagePopup.tscn")

#@onready var synchronizer = $MultiplayerSynchronizer

@onready var nav = $NavigationAgent2D
@onready var sprite = $Sprite
@onready var health_bar = $HealthBar
@onready var health_bar_text = $HealthBar/HealthBarText
@onready var multiplayer_sync = $MultiplayerSynchronizer

@export var speed: float = 250.0
#@export var max_health: int = 100
#var current_health: int = max_health

#@export var name: String = ""
@export var race: String = ""
@export var attributes: Dictionary = {}
@export var gladiator_name: String = ""

#@onready var nameLabel = $Name

#var velocity: Vector2 = Vector2.ZERO
@export var current_animation: String = "idle_down"
@export var prev_animation: String = "idle_down"

var input_vector := Vector2.ZERO

####
@export var weapon_dmg_min := 3.0
@export var weapon_dmg_max := 5.0
@export var weapon_req := 2.0
@export var weapon_speed := 1.0
@export var weapon_range = 150.0
@export var weapon_crit := 0.1

@export var armor_absorb := 1.0


@export var strength := 1.0
@export var weapon_skill := 1.0
@export var quickness := 1.0
@export var crit_rating := 1.0
@export var avoidance := 1.0

@export var max_health := 1.0
@export var resilience := 1.0
@export var endurance := 1.0
 
 # === Damage calculations ===
@export var attack_speed: float = (1/weapon_speed)/(log(10+sqrt(quickness))/log(10))  # Seconds between attacks
@export var time_since_last_attack: float = 0.0
@export var crit_chance = weapon_crit*crit_rating/20.0
@export var hit_chance = (weapon_skill/weapon_req) - 0.20*weapon_skill/100
@export var next_attack_critical: bool = false
@export var next_taken_hit_critical: bool = false
var spawn_point

 # === Calculations ===
@export var weight = 1
@export var move_speed := 0
@export var current_health = max_health
@export var armor = (1+sqrt(resilience)/10.0) * armor_absorb				# flat damage reduction
@export var dodge_chance = (avoidance/200.0) / ((avoidance/200.0)+1)		# decaying dodge_chance -> 1
@export var seconds_to_live = endurance/3.0

####
var target_position: Vector2 = Vector2.ZERO

const ATTACK_RANGE := 160.0
@export var last_attack_time := -999.0

var current_attack_target: Node = null
var attack_charge_time: float = 0.0

var float_speed = -30
var lifetime = 30

var attack_right_animations: Array = []# all_animations.filter(func(name): return name.begins_with("attack_right"))
var attack_left_animations: Array = []# = all_animations.filter(func(name): return name.begins_with("attack_left"))

@export var opponent_peer_id: int = -1
@onready var opponent: Node = null
#@onready var round_manager = get_tree().get_root().get_node("Main/RoundManager")

@export var in_combat := false
var last_played_animation: String = ""
@export var direction: Vector2 = Vector2.ZERO
var owner_id

signal died

func _ready():
	await get_tree().process_frame 
	add_to_group("gladiators")
	sprite.play("idle_down")
	await get_tree().create_timer(11.0).timeout
	
	# Intermission phase where players buy upgrades
	
	if multiplayer.is_server(): update_all_gladiators(GameState_.all_gladiators)

	#$HealthBar.value = max_health
	$HealthBar.max_value = max_health
	$HealthBar.value = max_health
	$HealthBar/HealthBarText.text = str(int(current_health))

	if opponent_peer_id:
		if opponent == null:
			for g in get_tree().get_nodes_in_group("gladiators"):
				if g.get_multiplayer_authority() == opponent_peer_id: opponent = g
		
		var all_animations = sprite.sprite_frames.get_animation_names()

		for animation_name in all_animations:
			if animation_name.begins_with("attack_right"): attack_right_animations.append(animation_name)
			if animation_name.begins_with("attack_left"): attack_left_animations.append(animation_name)
	
# Only process input if this is OUR player
func _physics_process(delta):
	$HealthBar.value = current_health
	if is_multiplayer_authority() and opponent != null and is_instance_valid(opponent) and opponent.current_health > 0 and opponent_peer_id:
		
		prev_animation = current_animation
		check_for_attack(delta)
		handle_ai_movement(delta)
		handle_animation()
	else: 
		if current_animation.begins_with("attack"): sprite.play(current_animation)
		elif !current_animation.begins_with("attack") and current_animation != "N/A": sprite.play(current_animation)
		
		
func handle_animation():
	if current_animation.begins_with("attack") and !sprite.is_playing(): sprite.play(current_animation)
	elif !current_animation.begins_with("attack") and current_animation != "N/A": sprite.play(current_animation)
	
	if not sprite.is_connected("animation_finished", _on_any_animation_finished): sprite.animation_finished.connect(_on_any_animation_finished, CONNECT_ONE_SHOT)
	
	
func _on_any_animation_finished(): 
	if sprite.animation == "die": emit_signal("died")
	else: current_animation = "N/A"
		
		
func check_for_attack(delta: float):
	if opponent == null or !is_instance_valid(opponent):
		current_attack_target = null
		attack_charge_time = 0.0
		return

	if opponent and opponent.is_inside_tree():
		var distance = global_position.distance_to(opponent.global_position)

		if distance <= ATTACK_RANGE:
			in_combat = true
			current_attack_target = opponent
			attack_charge_time += delta

			if attack_charge_time >= attack_speed and opponent.current_health > 0:
				if direction.x > 0.0: current_animation = attack_right_animations[randi_range(0, attack_right_animations.size()-1)]
				if direction.x < 0.0: current_animation = attack_left_animations[randi_range(0, attack_left_animations.size()-1)]
				CombatManager_.deal_attack(self, opponent)
				attack_charge_time = 0.0
		else:
			attack_charge_time = 0.0
			in_combat = false
	else:
		in_combat = false
		attack_charge_time = 0.0


@rpc("any_peer", "call_local")
func receive_damage(amount: int, hit_success, dodge_success, crit):
	if !hit_success or dodge_success: next_attack_critical = true
	
	current_health -= amount
	$HealthBar.value = current_health
	$HealthBar/HealthBarText.text = str(int(current_health))
	rpc("show_damage_popup", amount, hit_success, dodge_success, crit)

	if current_health <= 0 and is_multiplayer_authority(): rpc("die")


@rpc("any_peer", "call_local")
func die():
	if is_multiplayer_authority():
		var health_loss = 5
		GameState_.modify_gladiator_life.rpc(owner_id, health_loss)
		GameState_.modify_gladiator_life(owner_id, health_loss)  # Run it locally too!
		#var life = GameState_.all_gladiators[owner_id]["player_life"]
		#GameState_.all_gladiators[owner_id]["player_life"] -= health_loss
		#print("🩸 " + GameState_.all_gladiators[owner_id]["name"] + " lost " + str(health_loss) + " life, remaining: " + str(life))
	set_physics_process(false)
	set_process(false)
	$CollisionShape2D.disabled = true
	sprite.stop()
	
	if not sprite.is_playing():
		sprite.play("die")
		sprite.animation_finished.connect(_on_die_animation_finished, CONNECT_ONE_SHOT)
		

func _on_die_animation_finished():
	if sprite.animation == "die": emit_signal("died")
	#if owner_id == multiplayer.get_unique_id(): multiplayer_sync.public_visibility = false
	#if !multiplayer.is_server(): return
	#queue_free()

func handle_ai_movement(delta):
	direction = (target_position - global_position).normalized()
	
	if !in_combat: velocity = direction * move_speed
	else: velocity = Vector2.ZERO
		
	position += velocity * delta

	if !current_animation.begins_with("attack"):# or current_animation != "N/A":
		if !in_combat:
			if abs(direction.x) > abs(direction.y): current_animation = "walk_right" if direction.x > 0 else "walk_left"
			else: current_animation = "walk_down" if direction.y > 0 else "walk_up"
			prev_animation = current_animation
		else:
			# Stop at idle direction depending on last move
			if prev_animation == "walk_right": current_animation = "idle_right"
			elif prev_animation == "walk_left": current_animation = "idle_left"
			elif prev_animation == "walk_up": current_animation = "idle_up"
			elif prev_animation == "walk_down": current_animation = "idle_down"

	# Stop when close enough
	if global_position.distance_to(target_position) < 10:
		velocity = Vector2.ZERO
		target_position = Vector2.ZERO


# Called by the server to initialize this gladiator
#@rpc("any_peer", "call_local")
func initialize_gladiator(data, opponent_id, _spawn_point, meeting_point, peer_id):
	weapon_dmg_min = 3.0
	weapon_dmg_max = 5.0
	weapon_req = 15.0
	weapon_speed = 1.0
	weapon_range = 150
	weapon_crit = 0.1
	armor_absorb = 1.0
	
	spawn_point = _spawn_point
	position = _spawn_point
	
	owner_id = peer_id
	if opponent_id: 
		opponent_peer_id = opponent_id
		target_position = meeting_point
	else: target_position = position
	gladiator_name = data.name
	$Name.text = data.name
	strength = data["attributes"]["strength"]
	weapon_skill = data["attributes"]["weapon_skill"]
	quickness = data["attributes"]["quickness"]
	crit_rating = data["attributes"]["crit_rating"]
	avoidance = data["attributes"]["avoidance"]
	max_health = data["attributes"]["health"]
	resilience = data["attributes"]["resilience"]
	endurance = data["attributes"]["endurance"]
	
	#print("str: " + str(strength))

	# === Damage calculations ===
	attack_speed = (1/weapon_speed)/(log(10+sqrt(quickness))/log(10))  # Seconds between attacks
	time_since_last_attack = 0.0
	crit_chance = weapon_crit*crit_rating/10.0
	hit_chance = (weapon_skill/weapon_req) - 0.20*weapon_skill/100
	next_attack_critical = false
	next_taken_hit_critical = false

	# === Calculations ===
	weight = 1
	move_speed = 500
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
	#print("show_damage_popup" + str(spawn_point))
	popup.show_damage(amount, hit_success, dodge_success, crit, spawn_point)
	get_tree().current_scene.add_child(popup)


func customize_popup_font(color: Color, size, text: String):
		$Label.add_theme_color_override("font_color", color) 
		$Label.add_theme_font_size_override("font_size", size)
		$Label.text = text
		$Label.modulate.a = 1.0  # Fully visible


'''func handle_input(delta):
	input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity = input_vector * move_speed
	position += velocity * delta

	prev_animation = current_animation
	# Update animation
	if !sprite.animation == "attack":
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

		sprite.play(current_animation)'''

func update_all_gladiators(data: Dictionary): 
	for id in data:
		for g in get_tree().get_nodes_in_group("gladiators"):
			if g.owner_id == id:
				var stats = data[id]["attributes"]
				if g.is_multiplayer_authority():
					# Local node: update directly
					g.apply_stats(stats)
				else:
					# Remote node: call via RPC on owner
					g.rpc_id(g.get_multiplayer_authority(), "apply_stats", stats)



@rpc("any_peer", "call_local")
func apply_stats(data: Dictionary):
	strength = data.get("strength", 0)
	weapon_skill = data.get("weapon_skill", 0)
	quickness = data.get("quickness", 0)
	crit_rating = data.get("crit_rating", 0)
	avoidance = data.get("avoidance", 0)
	max_health = data.get("health", 0)
	resilience = data.get("resilience", 0)
	endurance = data.get("endurance", 0)

	# Derived stats
	attack_speed = (1/weapon_speed)/(log(10+sqrt(quickness))/log(10))
	time_since_last_attack = 0.0
	crit_chance = weapon_crit * crit_rating / 10.0
	hit_chance = (weapon_skill / weapon_req) - 0.20 * weapon_skill / 100
	next_attack_critical = false
	next_taken_hit_critical = false

	weight = 1
	move_speed = 500
	current_health = max_health
	armor = (1+sqrt(resilience)/10.0) * armor_absorb
	dodge_chance = (avoidance/200.0) / ((avoidance/200.0)+1)
	seconds_to_live = endurance/3.0
	
	$HealthBar.max_value = max_health
	$HealthBar.value = max_health
	$HealthBar/HealthBarText.text = str(int(max_health))
