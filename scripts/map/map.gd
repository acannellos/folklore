class_name Map
extends Node2D

@export var tiles: Node2D
@export var entities: Node2D
@export var forest_generator: ForestGenerator
@export var fov: FieldOfView
@export var fov_radius: int = 8

var map_data: MapData

func generate(player: Entity) -> void:
	map_data = forest_generator.generate_forest(player)
	_place_tiles()
	_place_entities()

func _place_entities() -> void:
	for entity in map_data.entities:
		entities.add_child(entity)

func _place_tiles() -> void:
	for tile in map_data.tiles:
		tiles.add_child(tile)

func update_fov(player_position: Vector2i) -> void:
	fov.update_fov(map_data, player_position, fov_radius)
	for entity in map_data.entities:
		entity.visible = map_data.get_tile(entity.grid_position).is_in_view
