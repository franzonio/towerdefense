extends CharacterBody2D

@onready var nav = $NavigationAgent2D
@onready var animated_sprite_2d = $AnimatedSprite2D
var speed = 100.0

func _ready():
	nav.target_position = get_node("/root/Main/Goal").global_position
	animated_sprite_2d.play("walk")

func _physics_process(delta):
	if nav.is_navigation_finished():
		queue_free()  # Reached goal
		return

	var direction = (nav.get_next_path_position() - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
