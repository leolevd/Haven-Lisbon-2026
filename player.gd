extends CharacterBody2D

# Useful things
@onready var label_2: Label = $CanvasLayer/HUD/Label2
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var GRAVITY = 980.0
@export var SPEED = 200.0
@export var JUMP_VELOCITY = -300.0
@export var DASH_RELOAD = 0.6
@export var DASH_SPEED = 600.0


var dash_timer = 0.0
var jumping = false
var wobbling = false

var money = 0



func wobble():
	wobbling = true
	animated_sprite_2d.material = ShaderMaterial.new()
	animated_sprite_2d.material.shader = preload("res://wobbly.gdshader")
	animated_sprite_2d.material.set_shader_parameter("sway_intensivity", 1)
	animated_sprite_2d.material.set_shader_parameter("sway_speed", 10)
func unwobble():
	animated_sprite_2d.material = null
func _physics_process(delta: float) -> void:
	label_2.text = str(money)
	# Add the gravity.
	if not is_on_floor():
		velocity += Vector2(0, GRAVITY) * delta
	else:
		jumping = false
		if wobbling:
			unwobble()
			wobbling = false
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jumping = true
		animated_sprite_2d.play("jumping")
		animated_sprite_2d.global_rotation_degrees = 0
		velocity.y = JUMP_VELOCITY
		
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor() and not jumping:
			animated_sprite_2d.play("rolling")
			animated_sprite_2d.global_rotation_degrees += SPEED * 2 * direction * delta
		else:
			animated_sprite_2d.global_rotation_degrees = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and not jumping:
			animated_sprite_2d.play("idle")
			animated_sprite_2d.global_rotation_degrees = 0
	move_and_slide()
