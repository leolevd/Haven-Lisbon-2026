extends Area2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(reactivate)
	timer.one_shot = true

func reactivate():
	sprite.visible = true
	collision.set_deferred("disabled", false)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.money += 1
		sprite.visible = false
		collision.set_deferred("disabled", true)
		timer.start()
