class_name Entity
extends Sprite2D

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Utils.grid_to_world(grid_position)

func _init(start_position: Vector2i, entity_data: EntityData) -> void:
	centered = false
	grid_position = start_position
	texture = entity_data.texture
	modulate = entity_data.color

func move(move_offset: Vector2i) -> void:
	grid_position += move_offset
