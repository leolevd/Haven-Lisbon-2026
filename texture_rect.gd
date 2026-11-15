extends TextureRect

@export var imgs: Array[Texture2D] = [preload("res://final_scene/the_end.png")]
@export var interv: float = 10.0    
@export var duration: float = 2.5 

var atual := 1

func _ready():
	if imgs.is_empty():
		return
	texture = imgs[0]

	var timer := Timer.new()
	timer.wait_time = interv
	timer.autostart = true
	timer.timeout.connect(_proxima_imagem)
	add_child(timer)

func _proxima_imagem():
	atual = (atual + 1) % imgs.size()  # volta para a primeira no fim

	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, duration)  # some
	tween.tween_callback(func(): texture = imgs[atual])       # troca a imagem
	tween.tween_property(self, "modulate:a", 1.0, duration)  # aparece
