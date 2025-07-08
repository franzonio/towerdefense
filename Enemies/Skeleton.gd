extends CharacterBody2D

@onready var nav = $NavigationAgent2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var health_bar = $HealthBar
@onready var gladiator = null

var target: Node = null
var direction

# === Weapon attributes ===
var weapon_dmg_min := 1
var weapon_dmg_max := 5
var weapon_req := 100.0
var weapon_speed := 1
var weapon_range = 150
var weapon_crit := 1

var armor_rating := 1

#var direction
# === Base attributes ===
var strength := 1
var weapon_skill := 80.0
var quickness := 40
var crit_rating := 1
var avoidance := 1

var max_health := 1
var resilience := 1

# === Damage calculations ===
var attack_speed: float = weapon_speed*10*(1/sqrt(quickness))  # Seconds between attacks
var time_since_last_attack: float = 0.0
var crit_chance = weapon_crit*crit_rating/200.0
var hit_chance = (weapon_skill/weapon_req) - 0.20*weapon_skill/100.0
var next_attack_critical := false
var next_taken_hit_critical := false

# === Defense calculations ===
var weight = 1
var current_health := 100
var armor := (1+sqrt(resilience)/10.0) * armor_rating				# flat damage reduction
var dodge_chance := (avoidance/200.0) / ((avoidance/200.0)+1)		# decaying dodge_chance -> 1
var move_speed := 350.0

func take_damage(damage: float):
	current_health = max(0, current_health - damage)
	$HealthBar.value = current_health
	if current_health <= 0:
		die()

func die():
	print("SKELETON DIED")
	queue_free()  # Or play death animation, game over, etc.


func _ready():
	gladiator = get_tree().get_root().get_node("Main/Gladiator")  # Adjust path if needed
	nav.target_position = get_node("/root/Main/EnemyGoal").global_position
	
	if move_speed == 0:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("walk")
	
	
func _physics_process(delta):
	direction = (nav.get_next_path_position() - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()
	
	time_since_last_attack += delta
	
	if gladiator and global_position.distance_to(gladiator.global_position) < weapon_range:
		if time_since_last_attack >= attack_speed:
			#attack_gladiator()
			CombatManager_.deal_attack(self, gladiator, direction[0])
			time_since_last_attack = 0.0

	if nav.is_navigation_finished():
		#queue_free()  # Reached goal
		move_speed = 0
		animated_sprite_2d.play("idle")
		return
		
