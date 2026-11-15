extends TextureRect

@export var imgs: Array[Texture2D] = [
	preload("res://tuturial/haven-black.png"),
	preload("res://tuturial/1s.png"),
	preload("res://tuturial/2s.png"),
	preload("res://tuturial/3s.png"),
	preload("res://tuturial/4s.png"),
	preload("res://tuturial/5s.png"),
	preload("res://tuturial/6s.png"),
]
@export var music: AudioStream = preload("res://tuturial/drama.mp3")

@export var first_time: float = 3.0    # haven-black no início (com fade)
@export var interv: float = 10.0       # cada imagem (com fade)
@export var duration: float = 2.5      # duração de cada fade
@export var final_time: float = 3.0    # haven-black no final (com fade)

var player := AudioStreamPlayer.new()

func _ready():
	if imgs.is_empty():
		return

	modulate.a = 0.0

	add_child(player)
	player.stream = music
	player.play()

	await show_img(imgs[0], first_time)

	for i in range(1, imgs.size()):
		await show_img(imgs[i], interv)

	await show_img(imgs[0], final_time, false)  # última: fica visível, sem fade de saída

	go_to_main()

func show_img(img: Texture2D, total: float, fade_out := true):
	var fade: float = min(duration, total / 3.0)
	texture = img

	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, fade)      # aparece
	if fade_out:
		tween.tween_interval(total - fade * 2)               # fica na tela
		tween.tween_property(self, "modulate:a", 0.0, fade)  # desaparece
	else:
		tween.tween_interval(total - fade)                   # fica na tela até ao fim
	await tween.finished

func go_to_main():
	get_tree().change_scene_to_file("res://main.tscn")
