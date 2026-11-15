extends StaticBody2D
@export_enum("Clones", "Jump", "Speed", "Strength", "Instant_hay") var type = 0
@export var haystack: Node2D = null
var cost_speed = 5
var cost_jump = 5
var cost_clones = 10
var cost_strength = 15
@onready var num: Sprite2D = $Sprite2D

func _ready() -> void:
	$Sprite2D2.frame = type
	match type:
		0:
			num.frame = 2
		1, 2:
			num.frame = 0
		3:
			num.frame = 7
		4:
			num.frame = 8


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		$AnimatedSprite2D.play("click")
		match type:
			0:
				if body.money >= cost_clones and cost_clones <= 22:
					if haystack:
						body.money -= cost_clones
						haystack.createclone()
						cost_clones += 3
						match cost_clones:
							13:
								num.frame = 3
							16:
								num.frame = 4
							19:
								num.frame = 5
							22:
								num.frame = 6
							25:
								num.frame = 9
			1:
				if body.money >= cost_jump and body.jump_boosts < 2:
					body.JUMP_VELOCITY -= 15
					body.money -= cost_jump
					body.jump_boosts += 1
					cost_jump += 2
					match cost_jump:
						7:
							num.frame = 1
						9:
							num.frame = 9
				
			2:
				if body.money >= cost_speed and body.speed_boosts < 2:
					body.SPEED += 20
					body.money -= cost_speed
					body.speed_boosts += 1
					cost_speed += 2
					match cost_speed:
						7:
							num.frame = 1
						9:
							num.frame = 9
			3:
				if body.money >= cost_strength and haystack.strength < 3:
					if haystack:
						body.money -= cost_strength
						haystack.strength += 1
						cost_strength += 5
						match cost_strength:
							20:
								num.frame = 8
							25:
								num.frame = 9
			4:
				if body.money >= 20 and haystack:
					haystack.hayleft -= 100
					body.money -= 20
					
