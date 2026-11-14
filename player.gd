extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var GRAVITY = 980.0
@export var SPEED = 200.0
@export var JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		animated_sprite_2d.play("jumping")
		animated_sprite_2d.global_rotation_degrees = 0
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			animated_sprite_2d.play("rolling")
			animated_sprite_2d.global_rotation_degrees += SPEED * 2 * direction * delta
		else:
			animated_sprite_2d.global_rotation_degrees = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite_2d.play("idle")
		animated_sprite_2d.global_rotation_degrees = 0
	move_and_slide()
