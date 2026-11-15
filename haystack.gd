extends StaticBody2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
const LILHELPER = preload("res://lilhelper.tscn")
const GOLDEN_NEEDLE = preload("res://golden_needle.tscn")
var hayleft = 2000
var clonesthere = 0
var timer = 0
var minx = -16
var maxx = 16
var miny = 30
var maxy = 30
var strength = 1
var r1
var r2
var r3
func _physics_process(delta: float) -> void:
	if timer < 2:
		timer += delta
	else:
		timer = 0
		hayleft -= clonesthere * strength / 2
		if randi_range(0, max(50 - (clonesthere*3*strength), 0)) == 0 and clonesthere >= 1:
			player.money += 10
			player.needles += 1
	
	var state = max((6 if hayleft <= 0 else ((hayleft / (2000/7)) - 6) * -1), 0)
	$Sprite2D.frame = state
	
	if state == 2:
		var node = get_node_or_null("toremove1")
		if node:
			node.queue_free()
	elif state == 3:
		var node = get_node_or_null("toremove2")
		if node:
			node.queue_free()
	elif state == 5:
		var node = get_node_or_null("toremove3")
		if node:
			node.queue_free()
	elif state == 6 and clonesthere > 0:
		clonesthere = 0
		for i in get_tree().get_nodes_in_group("helper"):
			i.queue_free()
		var gne: Area2D = GOLDEN_NEEDLE.instantiate()
		add_child(gne)
		gne.position = Vector2(0, 20)

func createclone():
	clonesthere += 1
	var helper: Node2D = LILHELPER.instantiate()
	helper.add_to_group("helper")
	add_child(helper)
	helper.position = Vector2(randi_range(minx, maxx), randi_range(miny, maxy))
