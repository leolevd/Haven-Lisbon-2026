extends CharacterBody2D

# Useful things
@onready var everything_else: Control = $CanvasLayer/HUD/Everything_else
@onready var label_2: Label = $CanvasLayer/HUD/Money/Label2
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var GRAVITY = 980.0
@export var SPEED = 200.0
@export var JUMP_VELOCITY = -300.0
@export var DASH_RELOAD = 0.6
@export var DASH_SPEED = 600.0
@export var haystack: Node2D
@export var heaven: bool = false
var jump_boosts = 0
var speed_boosts = 0
var dash_timer = 0.0
var jumping = false
var wobbling = false
var needles = 0
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
	if not heaven:
		label_2.text = str(money)
		if Input.is_action_pressed("showstats"):
			everything_else.visible = true
		else:
			everything_else.visible = false
		$CanvasLayer/HUD/Everything_else/workers/Label2.text = str(haystack.clonesthere)
		$CanvasLayer/HUD/Everything_else/jump_boosts/Label2.text = str(jump_boosts)
		$CanvasLayer/HUD/Everything_else/speed_boosts/Label2.text = str(speed_boosts)
		$CanvasLayer/HUD/Everything_else/needles/Label2.text = str(needles)
		$CanvasLayer/HUD/Everything_else/strength_boosts/Label2.text = str(haystack.strength)
		$CanvasLayer/HUD/Everything_else/hay_left/Label2.text = str(haystack.hayleft)
	# Add the gravity.
	if not is_on_floor():
		velocity += Vector2(0, GRAVITY) * delta
	else:
		jumping = false
		if wobbling:
			unwobble()
			wobbling = false
			
	# Handle dash down.
	dash_timer -= delta
	if Input.is_action_just_pressed("dash_down") and not is_on_floor() and not is_on_wall() and not is_on_ceiling() and dash_timer <= 0:
		velocity.y = DASH_SPEED
		dash_timer = DASH_RELOAD
		animated_sprite_2d.global_rotation_degrees = 0
			
			
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
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
