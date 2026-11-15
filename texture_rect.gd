extends TextureRect

@export var imgs: Array[Texture2D] = [
	preload("res://final_scene/the_end.png"),
	preload("res://final_scene/1s.png"),
	preload("res://final_scene/2s.png"),
	preload("res://final_scene/3s_heaven.png"),
	preload("res://final_scene/4s_hum.png"),
	preload("res://final_scene/5s.png"),
	preload("res://final_scene/6s.png"),]
	
@export var music: AudioStream = preload("res://dramatic_music.mp3")
@export var interv: float = 10.0       # tempo de cada imagem
@export var duration: float = 2.5      # duração do fade
@export var final_time: float = 115.0  # 1:55 na última imagem

var final_phase := false
var player := AudioStreamPlayer.new()

func _ready():
	if imgs.is_empty():
		return

	add_child(player)
	player.stream = music
	player.play()  # música começa junto com a cena

	# primeira imagem
	texture = imgs[0]
	await get_tree().create_timer(interv).timeout

	# passa por todas as outras uma vez
	for i in range(1, imgs.size()):
		await fade_to(imgs[i])
		await get_tree().create_timer(interv).timeout

	# volta para a primeira e fica 1:55
	await fade_to(imgs[0])
	final_phase = true
	await get_tree().create_timer(final_time).timeout
	get_tree().quit()

func fade_to(img: Texture2D):
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, duration)  # desaparece
	tween.tween_callback(func(): texture = img)              # troca a imagem
	tween.tween_property(self, "modulate:a", 1.0, duration)  # aparece
	await tween.finished

func _unhandled_input(event):
	if final_phase and event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().quit()
