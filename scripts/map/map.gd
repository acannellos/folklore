class_name Map
extends Node2D

@export var forest_generator: ForestGenerator
@export var fov: FieldOfView
@export var fov_radius: int = 8

var map_data: MapData

#func _ready() -> void:
	#map_data = forest_generator.generate_forest()
	#_place_tiles()

func generate(player: Entity) -> void:
	map_data = forest_generator.generate_forest(player)
	_place_tiles()

func _place_tiles() -> void:
	for tile in map_data.tiles:
		add_child(tile)

func update_fov(player_position: Vector2i) -> void:
	fov.update_fov(map_data, player_position, fov_radius)
