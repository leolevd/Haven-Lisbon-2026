extends StaticBody2D
@export_enum("Clones", "Jump", "Speed", "Strength") var type = 0
@export var haystack: Node2D = null
var cost_speed = 5
var cost_jump = 5
var cost_clones = 10
var cost_strength = 15

func _ready() -> void:
	$Sprite2D2.frame = type


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		$AnimatedSprite2D.play("click")
		match type:
			0:
				if body.money >= cost_clones:
					if haystack:
						body.money -= cost_clones
						haystack.createclone()
						cost_clones += 3
			1:
				if body.money >= cost_jump and body.jump_boosts < 2:
					body.JUMP_VELOCITY -= 15
					body.money -= cost_jump
					body.jump_boosts += 1
					cost_jump += 2
				
			2:
				if body.money >= cost_speed and body.speed_boosts < 2:
					body.SPEED += 20
					body.money -= cost_speed
					body.speed_boosts += 1
					cost_speed += 2
			3:
				if body.money >= cost_strength:
					if haystack:
						body.money -= cost_strength
						haystack.strength += 1
						cost_strength += 5
			
