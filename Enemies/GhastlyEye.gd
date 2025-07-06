extends CharacterBody2D

@onready var nav = $NavigationAgent2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var health_bar = $HealthBar

# === Base Attributes ===
var max_health := 100
var current_health := 100
var strength := 10
var armor := 0.1       # 10% damage reduction
var dodge_chance := 0.05  # 5% chance to dodge
var move_speed := 250.0

func take_damage(amount: float):
	current_health = max(0, current_health - amount)
	health_bar.value = current_health

func _ready():
	nav.target_position = get_node("/root/Main/Goal").global_position
	animated_sprite_2d.play("walk")

func _physics_process(delta):
	if nav.is_navigation_finished():
		queue_free()  # Reached goal
		return

	var direction = (nav.get_next_path_position() - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()
