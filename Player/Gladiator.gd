extends CharacterBody2D

@onready var nav = $NavigationAgent2D
@onready var sprite = $Sprite
@onready var health_bar = $HealthBar
@onready var enemy = null




# === Damage attributes ===
var strength := 10.0
var base_dmg_min := 3
var base_dmg_max := 15
var weapon_skill := 80.0
var weapon_req := 100.0
var attack_speed: float = 1.25  # Seconds between attacks
var time_since_last_attack: float = 0.0
var attack_range = 150
var crit_chance = 0.10
var hit_chance = (weapon_skill/weapon_req) - 0.20*weapon_skill/100

var weight = 1# === Defense attributes ===
var max_health := 100
var current_health := 100
var armor := 0.1       # 10% damage reduction
var dodge_chance := 0.15  # 5% chance to dodge
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
	#damage_popup(damage)
	
	if current_health <= 0:
		die()

func die():
	print("GLADIATOR DIED")
	queue_free()  # Or play death animation, game over, etc.

func _ready():
	enemy = get_tree().get_root().get_node("Main/Skeleton")
	#call_deferred("_find_enemy")
	nav.target_position = get_node("/root/Main/PlayerGoal").global_position
	

func _find_enemy():
	enemy = get_tree().get_root().get_node("Main/Skeleton")

func _physics_process(delta):
	time_since_last_attack += delta
	#print(enemy.global_position)
	if enemy and global_position.distance_to(enemy.global_position) < attack_range:
		#print("in range")
		if time_since_last_attack >= attack_speed:
			#print("asd")
			sprite.play("attack")
			CombatManager_.deal_attack(self, enemy)
			time_since_last_attack = 0.0
	
	'''
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		velocity = input_vector * move_speed
		play_walk_animation(input_vector)
	else:
		velocity = Vector2.ZERO
		sprite.stop()
	'''

	if nav.is_navigation_finished():
		#queue_free()  # Reached goal
		move_speed = 0
		#sprite.play("idle_left")
		return
		
	var direction = (nav.get_next_path_position() - global_position).normalized()
	
	play_walk_animation(direction, move_speed)
	velocity = direction * move_speed
	
	move_and_slide()


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
