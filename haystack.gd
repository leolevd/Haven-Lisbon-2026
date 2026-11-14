extends StaticBody2D
@export var player: CharacterBody2D
const LILHELPER = preload("res://lilhelper.tscn")
var hayleft = 500
var clonesthere = 0
var timer = 0
var minx = -16
var maxx = 16
var miny = 30
var maxy = 30
var strength = 1
func _physics_process(delta: float) -> void:
	if timer < 2:
		timer += delta
	else:
		timer = 0
		hayleft -= clonesthere * strength / 2
		if randi_range(0, 50 - (clonesthere*2*strength)) == 1 and clonesthere >= 1:
			player.money += 10
			player.needles += 1
	
	var state = max((6 if hayleft <= 0 else ((hayleft / (500/7)) - 6) * -1), 0)
	$Sprite2D.frame = state
	
	if state == 2 and $toremove1:
		$toremove1.queue_free()
	elif state == 3 and $toremove2:
		$toremove2.queue_free()
	elif  state == 5 and $toremove3:
		$toremove3.queue_free()
	elif state == 6 and clonesthere > 0:
		clonesthere = 0
		for i in get_tree().get_nodes_in_group("helper"):
			i.queue_free()

func createclone():
	clonesthere += 1
	var helper: Node2D = LILHELPER.instantiate()
	helper.add_to_group("helper")
	add_child(helper)
	helper.position = Vector2(randi_range(minx, maxx), randi_range(miny, maxy))
