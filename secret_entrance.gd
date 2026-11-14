extends Node2D

@onready var layer: TileMapLayer = get_parent()
@onready var wall_colison: CollisionShape2D = $Wall/CollisionShape2D
@onready var detector: Area2D = $Detector
@onready var note: Area2D = get_node_or_null("Nota")

var aberta = false


func _ready() -> void:
	detector.body_entered.connect(_on_detetor_body_entered)
	if note:
		note.visible = false
		note.body_entered.connect(_on_nota_body_entered)


func _on_detetor_body_entered(body: Node2D) -> void:
	if aberta:
		return
	if body is CharacterBody2D:
		aberta = true
		wall_colison.set_deferred("disabled", true)
		abrir_tiles()
		if note:
			note.visible = true


func _on_nota_body_entered(body: Node2D) -> void:
	if note.visible and "money" in body:
		body.money += 100
		note.queue_free()


# Encontra os tiles que estão debaixo da colisão do Wall.
func abrir_tiles() -> void:
	var rect: Rect2 = wall_colison.shape.get_rect()
	var margem = Vector2(layer.tile_set.tile_size) * 0.3
	var canto1 = layer.to_local(wall_colison.to_global(rect.position)) + margem
	var canto2 = layer.to_local(wall_colison.to_global(rect.end)) - margem
	var inicio = layer.local_to_map(canto1)
	var fim = layer.local_to_map(canto2)
	for x in range(inicio.x, fim.x + 1):
		for y in range(inicio.y, fim.y + 1):
			tornar_passavel(Vector2i(x, y))


# tira a colisão a um tile e pinta-o de cinzento.
func tornar_passavel(celula: Vector2i) -> void:
	var source_id = layer.get_cell_source_id(celula)
	if source_id == -1:
		return
	var fonte = layer.tile_set.get_source(source_id) as TileSetAtlasSource
	if fonte == null:
		return
	var atlas = layer.get_cell_atlas_coords(celula)
	var alt = fonte.create_alternative_tile(atlas)
	var dados: TileData = fonte.get_tile_data(atlas, alt)
	dados.modulate = Color(0.55, 0.55, 0.55)
	for i in layer.tile_set.get_physics_layers_count():
		dados.set_collision_polygons_count(i, 0)
	layer.set_cell(celula, source_id, atlas, alt)
