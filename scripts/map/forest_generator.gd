class_name ForestGenerator
extends Node

@export_category("Map Dimensions")
@export var map_width: int = 160
@export var map_height: int = 90

@export_category("Rooms RNG")
@export var max_rooms: int = 20
@export var room_max_size: int = 30
@export var room_min_size: int = 10

@export_category("Mob RNG")
@export var max_mob_per_room = 4

var forest: MapData

const entity_types = {
	"wolf": preload("res://data/entities/entity_data_wolf.tres"),
	"antelope": preload("res://data/entities/entity_data_antelope.tres"),
	"snake": preload("res://data/entities/entity_data_snake.tres"),
	"sign": preload("res://data/entities/entity_data_sign.tres"),
}

var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()

func _create_wall(forest: MapData, x: int, y: int) -> void:
		var tile_position = Vector2i(x, y)
		var tile: Tile = forest.get_tile(tile_position)
		#tile.set_tile_type(forest.tile_types.wall)
		match randi_range(0, 2):
			0:
				tile.set_tile_type(forest.tile_types.brick)
			1:
				tile.set_tile_type(forest.tile_types.brick)
			2:
				tile.set_tile_type(forest.tile_types.wall)

func _create_floor(forest: MapData, x: int, y: int) -> void:
		var tile_position = Vector2i(x, y)
		var tile: Tile = forest.get_tile(tile_position)
		
		match randi_range(0, 3):
			0:
				tile.set_tile_type(forest.tile_types.grass)
			1:
				tile.set_tile_type(forest.tile_types.dot)
			2:
				tile.set_tile_type(forest.tile_types.other)
			3:
				tile.set_tile_type(forest.tile_types.floor)
		
		#tile.set_tile_type(forest.tile_types.floor)

func _create_pool(forest: MapData, x: int, y: int) -> void:
		var tile_position = Vector2i(x, y)
		var tile: Tile = forest.get_tile(tile_position)
		if randf() < 0.9:
			tile.set_tile_type(forest.tile_types.pool)
		else:
			tile.set_tile_type(forest.tile_types.pool_deep)
		#tile.set_tile_type(forest.tile_types.pool)

func _create_tree(forest: MapData, x: int, y: int) -> void:
		var tile_position = Vector2i(x, y)
		var tile: Tile = forest.get_tile(tile_position)
		tile.set_tile_type(forest.tile_types.fir)

func _create_path(forest: MapData, x: int, y: int) -> void:
		var tile_position = Vector2i(x, y)
		var tile: Tile = forest.get_tile(tile_position)
		tile.set_tile_type(forest.tile_types.path)

func _create_room(forest: MapData, room: Rect2i) -> void:
	for y in range(room.position.y, room.end.y + 1):
		for x in range(room.position.x, room.end.x + 1):
			_create_wall(forest, x, y)
	
	var inner: Rect2i = room.grow(-1)
	for y in range(inner.position.y, inner.end.y + 1):
		for x in range(inner.position.x, inner.end.x + 1):
			_create_floor(forest, x, y)

func _create_floors(forest: MapData, room: Rect2i) -> void:
	for y in range(room.position.y, room.end.y + 1):
		for x in range(room.position.x, room.end.x + 1):
			_create_floor(forest, x, y)

func _tunnel_horizontal(forest: MapData, y: int, x_start: int, x_end: int) -> void:
	var x_min: int = mini(x_start, x_end)
	var x_max: int = maxi(x_start, x_end)
	for x in range(x_min, x_max + 1):
		if not forest.get_tile(Vector2i(x, y)).is_walkable():
			_create_floor(forest, x, y)

func _tunnel_vertical(forest: MapData, x: int, y_start: int, y_end: int) -> void:
	var y_min: int = mini(y_start, y_end)
	var y_max: int = maxi(y_start, y_end)
	for y in range(y_min, y_max + 1):
		if not forest.get_tile(Vector2i(x, y)).is_walkable():
			_create_floor(forest, x, y)

func _path_vertical(forest: MapData, x: int, y_start: int, y_end: int) -> void:
	var y_min: int = mini(y_start, y_end)
	var y_max: int = maxi(y_start, y_end)
	for y in range(y_min, y_max + 1):
		_create_path(forest, x, y)

func _tunnel_between(forest: MapData, start: Vector2i, end: Vector2i) -> void:
	if _rng.randf() < 0.5:
		_tunnel_horizontal(forest, start.y, start.x, end.x)
		_tunnel_vertical(forest, end.x, start.y, end.y)
	else:
		_tunnel_vertical(forest, start.x, start.y, end.y)
		_tunnel_horizontal(forest, end.y, start.x, end.x)

func _place_entities(forest: MapData, room: Rect2i) -> void:
	#var number_of_mobs: int = _rng.randi_range(0, max_mob_per_room)
	var number_of_mobs: int = max_mob_per_room
	
	for _i in number_of_mobs:
		var x: int = _rng.randi_range(room.position.x + 1, room.end.x - 1)
		var y: int = _rng.randi_range(room.position.y + 1, room.end.y - 1)
		var new_entity_position := Vector2i(x, y)
		
		var can_place = true
		for entity in forest.entities:
			if entity.grid_position == new_entity_position:
				can_place = false
				break
		
		if can_place:
			var new_entity: Entity
			match randi_range(0, 2):
				0:
					new_entity = Entity.new(forest, new_entity_position, entity_types.wolf)
				1:
					new_entity = Entity.new(forest, new_entity_position, entity_types.antelope)
				2:
					new_entity = Entity.new(forest, new_entity_position, entity_types.snake)
			#if _rng.randf() < 0.5:
				#new_entity = Entity.new(forest, new_entity_position, entity_types.wolf)
			#else:
				#new_entity = Entity.new(forest, new_entity_position, entity_types.antelope)
			forest.entities.append(new_entity)

func generate_forest(player: Entity) -> MapData:
	forest = MapData.new(map_width, map_height, player)
	
	forest.entities.append(player)
	
	var floors := Rect2i(10, 10, forest.width - 20, forest.height - 20)
	_create_floors(forest, floors)
	
	var rooms: Array[Rect2i] = []
	var map_rect := Rect2i(0, 0, map_width, map_height)
	var center := map_rect.get_center()
	var center_floors := Rect2i(center.x - 10, center.y - 10, 20, 20)
	
	var iper_pool: Rect2i
	
	for y in map_height:
		for x in map_width:
			if randf() < 0.95:
				pass
			else:
				_create_tree(forest, x, y)
	
	for _try_room in max_rooms:
		var room_width: int = _rng.randi_range(room_min_size, room_max_size)
		var room_height: int = _rng.randi_range(room_min_size, room_max_size)
		
		var x: int = _rng.randi_range(3, forest.width - room_width - 1)
		var y: int = _rng.randi_range(3, forest.height - room_height - 1)
		
		var new_room := Rect2i(x, y, room_width, room_height)
		
		var has_intersections := false
		for room in rooms:
			if room.intersects(new_room.grow(-1)):
				has_intersections = true
				break
		if has_intersections:
			continue
		
		_create_room(forest, new_room)
		
		if rooms.is_empty():
			iper_pool = new_room.grow(-2)
			print(iper_pool)
			for iy in range(iper_pool.position.y, iper_pool.end.y + 1):
				for ix in range(iper_pool.position.x, iper_pool.end.x + 1):
					_create_pool(forest, ix, iy)
			#_create_floors(forest, center_floors)
			#var inner: Rect2i = new_room.grow(-2)
			#for iy in range(inner.position.y, inner.end.y + 1):
				#for ix in range(inner.position.x, inner.end.x + 1):
					#_create_pool(forest, x, y)
			player.grid_position = center
			player.map_data = forest
		else:
			_tunnel_between(forest, rooms.back().get_center(), new_room.get_center())
		
		#if _try_room == max_rooms - 2:
			#print("baba")
			#var inner: Rect2i = new_room.grow(-1)
			#for iy in range(inner.position.y, inner.end.y + 1):
				#for ix in range(inner.position.x, inner.end.x + 1):
					#_create_pool(forest, ix, iy)
		
		_place_entities(forest, new_room)
		
		rooms.append(new_room)
	
	_create_floors(forest, center_floors)
	
	#for y in map_height:
		#for x in map_width:
			#if randf() < 0.98:
				#pass
			#else:
				#_create_tree(forest, x, y)
	
	#for iy in range(iper_pool.position.y, iper_pool.end.y + 1):
		#for ix in range(iper_pool.position.x, iper_pool.end.x + 1):
			#_create_pool(forest, ix, iy)
	
	_path_vertical(forest, center.x + 1, center.y, center.y - 15)
	
	#var temp_tile: Tile = forest.get_tile(Vector2i(center.x + 1, center.y))
	#temp_tile.set_tile_type(forest.tile_types.sign)
	var new_sign: Entity = Entity.new(forest, Vector2i(center.x + 1, center.y), entity_types.sign)
	forest.entities.append(new_sign)
	
	forest.setup_pathfinding()
	return forest
