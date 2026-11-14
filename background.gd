extends Node2D

@onready var camera: Camera2D = get_viewport().get_camera_2d()

func _ready() -> void:
	_process(0.0)


func _process(_delta: float) -> void:
	# The artwork is centered, so use the camera center in world coordinates.
	var camera_center := camera.get_screen_center_position()
	for child in get_children():
		var layer := child as Parallax2D
		layer.screen_offset = camera_center
