extends CharacterBody2D

@onready var nav = $NavigationAgent2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var health_bar = $HealthBar
@onready var gladiator = null

var target: Node = null

# === Damage attributes ===
var strength := 10.0
var base_dmg_min := 3
var base_dmg_max := 15
var weapon_skill := 80.0
var weapon_req := 100.0
var attack_speed: float = 1.5  # Seconds between attacks
var time_since_last_attack: float = 0.0
var attack_range = 80
var crit_chance = 0.10
var hit_chance = (weapon_skill/weapon_req) - 0.20*weapon_skill/100

var weight = 1
# === Defense attributes ===
var max_health := 100
var current_health := 100
var armor := 0.1       # 10% damage reduction
var dodge_chance := 0.05  # 5% chance to dodge
var move_speed := 200.0

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
	time_since_last_attack += delta
	
	if gladiator and global_position.distance_to(gladiator.global_position) < attack_range:
		if time_since_last_attack >= attack_speed:
			#attack_gladiator()
			CombatManager_.deal_attack(self, gladiator, weapon_req, weight, crit_chance, strength, base_dmg_min, base_dmg_max, dodge_chance)
			time_since_last_attack = 0.0

	if nav.is_navigation_finished():
		#queue_free()  # Reached goal
		move_speed = 0
		animated_sprite_2d.play("idle")
		return
		
	var direction = (nav.get_next_path_position() - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()

func attack_gladiator():
	if gladiator:
		var crit = 1
		var hit_success = 1
		if randf() < crit_chance:
			crit = 2
		if randf() > hit_chance:
			hit_success = 0
			print("SKELETON MISSED")
			
		gladiator.take_damage(hit_success*(randf_range(base_dmg_min, base_dmg_max)*crit+strength/15))
		time_since_last_attack = 0.0
