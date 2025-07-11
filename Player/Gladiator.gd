extends CharacterBody2D

@onready var nav = $NavigationAgent2D
@onready var sprite = $Sprite
@onready var health_bar = $HealthBar
@onready var health_bar_text = $HealthBar/HealthBarText
@onready var enemy = null

var seconds : float = 0.0

# === Weapon attributes ===
var weapon_dmg_min := 3
var weapon_dmg_max := 5
var weapon_req := 20.0
var weapon_speed := 1
var weapon_range = 150
var weapon_crit := 1

var armor_absorb := 1

#var direction
# === Base attributes ===
var strength: int = GameState_.gladiator_attributes["strength"]
var weapon_skill: int = GameState_.gladiator_attributes["weapon_skill"]
var quickness: int = GameState_.gladiator_attributes["quickness"]
var crit_rating: int = GameState_.gladiator_attributes["crit_rating"]
var avoidance: int = GameState_.gladiator_attributes["avoidance"]

var max_health: int = GameState_.gladiator_attributes["health"]
var resilience: int = GameState_.gladiator_attributes["resilience"]
var endurance: int = GameState_.gladiator_attributes["endurance"]

# === Damage calculations ===
var attack_speed: float = (1/weapon_speed)/(log(10+sqrt(quickness))/log(10))  # Seconds between attacks
var time_since_last_attack: float = 0.0
var crit_chance = weapon_crit*crit_rating/20.0
var hit_chance = (weapon_skill/weapon_req) - 0.20*weapon_skill/100
var next_attack_critical := false
var next_taken_hit_critical := false

# === Calculations ===
var weight = 1
var move_speed := 350.0
var current_health := max_health
var armor := (1+sqrt(resilience)/10.0) * armor_absorb				# flat damage reduction
var dodge_chance := (avoidance/200.0) / ((avoidance/200.0)+1)		# decaying dodge_chance -> 1
var seconds_to_live := endurance/3.0

func _ready():
	GameState_.gladiator_alive = 1
	enemy = get_tree().get_root().get_node("Main/Skeleton")
	nav.target_position = get_node("/root/Main/PlayerGoal").global_position
	
	for attr in GameState_.gladiator_attributes.keys():
		self.set(attr, GameState_.gladiator_attributes[attr])
	current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = max_health
	health_bar_text.text = str(max_health)
	
	print("Seconds to live: %d" % [seconds_to_live])

func take_damage(damage: float):
	if seconds < seconds_to_live: 
		current_health = max(0, current_health - damage)
		health_bar.value = current_health
		health_bar_text.text = str(int(current_health))
		
		print("Gladiator hp: " + str(current_health))
		
		if current_health <= 0:
			print("Gladiator dies")
			die()

func die():
	set_physics_process(false)
	set_process(false)
	$CollisionShape2D.disabled = true

	# Connect to animation_finished and play die animation
	sprite.stop()
	if not sprite.is_playing():
		sprite.play("die")
		sprite.animation_finished.connect(_on_die_animation_finished, CONNECT_ONE_SHOT)

func _on_die_animation_finished():
	if sprite.animation == "die":
		GameState_.gladiator_alive = 0
		# Disable logic & collision
		#queue_free()

func _find_enemy():
	enemy = get_tree().get_root().get_node("Main/Skeleton")

func _physics_process(delta):
	time_since_last_attack += delta
	var prev_sec = seconds
	seconds += delta
	#print("gladiator seconds: " + str(seconds))
	
	if seconds > seconds_to_live :
		die()
	else:
		var direction = (nav.get_next_path_position() - global_position).normalized()
		
		if move_speed:
			play_walk_animation(direction, move_speed)
			velocity = direction * move_speed
			move_and_slide()

		#print(global_position)
		if enemy and global_position.distance_to(enemy.global_position) < weapon_range:
			#print("in range")
			if time_since_last_attack >= attack_speed and GameState_.skeleton_alive == 1:
				#print("asd")
				sprite.play("attack")
				#print(direction)
				CombatManager_.deal_attack(self, enemy, direction[0])
				time_since_last_attack = 0.0
				
				'''
				var xp_gain = 2#int(damage * 0.5)
				var gold_gain = 2 + randi() % 5  # 2–6 gold randomly
					# Tell the HUD to update
				var hud = get_tree().root.get_node("Main/HUD")  # adjust path if needed
				if hud:
					hud.update_experience(hud.experience + xp_gain)
					hud.update_gold(hud.gold + gold_gain)
				'''
		

		
		if nav.is_navigation_finished():
			#queue_free()  # Reached goal
			move_speed = 0
			#sprite.play("idle_left")
			return
		
		
		#var input_vector = Vector2.ZERO
		#input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		#input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#
		#if input_vector.length() > 0:
			#input_vector = input_vector.normalized()
			#velocity = input_vector * move_speed
			#play_walk_animation(input_vector)
		#else:
			#velocity = Vector2.ZERO
			#sprite.stop()
		




func play_walk_animation(direction: Vector2, move_speed):
	if move_speed != 0:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				sprite.play("walk_right")
			else:
				sprite.play("walk_left")
		else:
			if direction.y > 0:
				sprite.play("walk_down")
			else:
				sprite.play("walk_up")
	else:
		sprite.play("idle_left")
