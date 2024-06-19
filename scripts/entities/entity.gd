class_name Entity
extends Sprite2D

var _entity_data = EntityData

func _init(start_position: Vector2i, entity_data: EntityData) -> void:
	centered = false
	grid_position = start_position
	set_entity_type(entity_data)

func set_entity_type(entity_data: EntityData) -> void:
	_entity_data = entity_data
	texture = entity_data.texture
	modulate = entity_data.color

func is_blocking_movement() -> bool:
	return _entity_data.is_blocking_movement

func get_entity_name() -> String:
	return _entity_data.name

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Utils.grid_to_world(grid_position)

func move(move_offset: Vector2i) -> void:
	grid_position += move_offset
