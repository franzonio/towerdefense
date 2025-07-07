extends CharacterBody2D

@onready var nav = $NavigationAgent2D
@onready var sprite = $Sprite
@onready var health_bar = $HealthBar
@onready var enemy = null

# === Weapon attributes ===
var weapon_dmg_min := 3
var weapon_dmg_max := 15
var weapon_req := 100.0
var weapon_speed := 1
var weapon_range = 150
var weapon_crit := 1

var armor_rating := 1

#var direction
# === Base attributes ===
var strength := 1
var weapon_skill := 80.0
var quickness := 100
var crit_rating := 1
var avoidance := 1

var max_health := 1
var resilience := 1

# === Damage calculations ===
var attack_speed: float = weapon_speed*10*(1/sqrt(quickness))  # Seconds between attacks
var time_since_last_attack: float = 0.0
var crit_chance = weapon_crit*crit_rating/200.0
var hit_chance = (weapon_skill/weapon_req) - 0.20*weapon_skill/100
var next_attack_critical := false
var next_taken_hit_critical := false

# === Defense calculations ===
var weight = 1
var current_health := 100
var armor := (1+sqrt(resilience)/10.0) * armor_rating				# flat damage reduction
var dodge_chance := (avoidance/200.0) / ((avoidance/200.0)+1)		# decaying dodge_chance -> 1
var move_speed := 350.0

func upgrade_attribute(attr_name: String, amount: float):
	if get_script().has_property(attr_name):
		var new_value = self.get(attr_name) + amount
		self.set(attr_name, new_value)
		print("Upgraded %s by %s → New value: %s" % [attr_name, amount, self.get(attr_name)])
	else:
		push_warning("Tried to upgrade invalid attribute: " + attr_name)


func take_damage(damage: float):
	current_health = max(0, current_health - damage)
	$HealthBar.value = current_health
	
	if current_health <= 0:
		die()

func die():
	print("GLADIATOR DIED")
	queue_free()  # Or play death animation, game over, etc.

func _ready():
	enemy = get_tree().get_root().get_node("Main/Skeleton")
	nav.target_position = get_node("/root/Main/PlayerGoal").global_position
	

func _find_enemy():
	enemy = get_tree().get_root().get_node("Main/Skeleton")

func _physics_process(delta):
	time_since_last_attack += delta
	
	var direction = (nav.get_next_path_position() - global_position).normalized()
	
	if move_speed:
		play_walk_animation(direction, move_speed)
		velocity = direction * move_speed
		move_and_slide()

	#print(global_position)
	if enemy and global_position.distance_to(enemy.global_position) < weapon_range:
		#print("in range")
		if time_since_last_attack >= attack_speed:
			#print("asd")
			sprite.play("attack")
			#print(direction)
			CombatManager_.deal_attack(self, enemy, direction[0])
			time_since_last_attack = 0.0
	

	
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
