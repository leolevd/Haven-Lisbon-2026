extends Button

@export var raio = 300.0          # a que distância do rato começa a fugir
@export var forca = 70.0          # quanto foge no máximo (em píxeis)
@export var velocidade = 12.0     # rapidez com que se mexe
@export var so_horizontal = true  # true = só foge para os lados, não sobe para o Start
@export var tremer = 2.0          # pequeno tremor quando o rato está em cima (0 = desliga)

var posicao_inicial: Vector2


func _ready() -> void:
	# Espera um frame para os containers arrumarem os botões primeiro.
	await get_tree().process_frame
	posicao_inicial = position


func _process(delta: float) -> void:
	if posicao_inicial == Vector2.ZERO and position != Vector2.ZERO:
		return

	# O centro original do botão (onde ele estaria se não fugisse).
	var centro_inicial = global_position - position + posicao_inicial + size / 2
	var rato = get_global_mouse_position()
	var diferenca = centro_inicial - rato
	var distancia = diferenca.length()

	var alvo = posicao_inicial
	if distancia < raio:
		var direcao = diferenca.normalized() if distancia > 0.1 else Vector2.RIGHT
		var empurrao = direcao * (1.0 - distancia / raio) * forca
		if so_horizontal:
			empurrao.y = 0
		alvo = posicao_inicial + empurrao
		if is_hovered():
			alvo += Vector2(randf_range(-tremer, tremer), randf_range(-tremer, tremer))

	position = position.lerp(alvo, 1.0 - exp(-velocidade * delta))
