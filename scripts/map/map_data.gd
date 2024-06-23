class_name MapData
extends RefCounted

const tile_types = {
	"floor": preload("res://data/map/tile_data_floor.tres"),
	"grass": preload("res://data/map/tile_data_floor_grass.tres"),
	"dot": preload("res://data/map/tile_data_floor_dot.tres"),
	"other": preload("res://data/map/tile_data_floor_other.tres"),
	"path": preload("res://data/map/tile_data_floor_path.tres"),
	
	"wall": preload("res://data/map/tile_data_wall.tres"),
	"brick": preload("res://data/map/tile_data_wall_brick.tres"),
	
	"elm": preload("res://data/map/tile_data_tree_elm.tres"),
	"fir": preload("res://data/map/tile_data_tree_fir.tres"),
	"oak": preload("res://data/map/tile_data_tree_oak.tres"),
	
	"pool": preload("res://data/map/tile_data_pool.tres"),
	"pool_deep": preload("res://data/map/tile_data_pool_deep.tres"),
}

const entity_pathfinding_weight = 10.0

var width: int
var height: int
var tiles: Array[Tile]
var entities: Array[Entity]
var player: Entity
var pathfinder: AStarGrid2D

func _init(map_width: int, map_height: int, player: Entity) -> void:
	width = map_width
	height = map_height
	self.player = player
	entities = []
	_setup_tiles()

func _setup_tiles() -> void:
	tiles = []	
	for y in height:
		for x in width:
			var tile_position := Vector2i(x, y)
			#var tile := Tile.new(tile_position, tile_types.floor)
			#var tile := Tile.new(tile_position, tile_types.oak)
			
			var tile: Tile
			match randi_range(0, 2):
				0:
					tile = Tile.new(tile_position, tile_types.elm)
				1:
					tile = Tile.new(tile_position, tile_types.fir)
				2:
					tile = Tile.new(tile_position, tile_types.oak)
			
			tiles.append(tile)

func get_tile(grid_position: Vector2i) -> Tile:
	var tile_index: int = grid_to_index(grid_position)
	if tile_index == -1:
		return null
	return tiles[tile_index]

func get_tile_xy(x: int, y: int) -> Tile:
	var grid_position := Vector2i(x, y)
	return get_tile(grid_position)

func grid_to_index(grid_position: Vector2i) -> int:
	if not is_in_bounds(grid_position):
		return -1
	return grid_position.y * width + grid_position.x

func is_in_bounds(coordinate: Vector2i) -> bool:
	return (
		0 <= coordinate.x
		and coordinate.x < width
		and 0 <= coordinate.y
		and coordinate.y < height
	)

func get_blocking_entity_at_location(grid_position: Vector2i) -> Entity:
	for entity in entities:
		if entity.is_blocking_movement() and entity.grid_position == grid_position:
			return entity
	return null

func register_blocking_entity(entity: Entity) -> void:
	pathfinder.set_point_weight_scale(entity.grid_position, entity_pathfinding_weight)

func unregister_blocking_entity(entity: Entity) -> void:
	pathfinder.set_point_weight_scale(entity.grid_position, 0)

func setup_pathfinding() -> void:
	pathfinder = AStarGrid2D.new()
	pathfinder.region = Rect2i(0, 0, width, height)
	pathfinder.update()
	for y in height:
		for x in width:
			var grid_position := Vector2i(x, y)
			var tile: Tile = get_tile(grid_position)
			pathfinder.set_point_solid(grid_position, not tile.is_walkable())
	for entity in entities:
		if entity.is_blocking_movement():
			register_blocking_entity(entity)

func get_actors() -> Array[Entity]:
	var actors: Array[Entity] = []
	for entity in entities:
		if entity.is_alive() or entity.type == Enums.EntityType.SIGN:
			actors.append(entity)
	return actors

func get_actor_at_location(location: Vector2i) -> Entity:
	for actor in get_actors():
		if actor.grid_position == location:
			return actor
	return null
