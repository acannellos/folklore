class_name Tile
extends Sprite2D

var _tile_data: _TileData

func _init(grid_position: Vector2i, tile_data: _TileData) -> void:
	visible = false
	centered = false
	position = Utils.grid_to_world(grid_position)
	set_tile_type(tile_data)

var is_explored: bool = false:
	set(value):
		is_explored = value
		if is_explored and not visible:
			visible = true

var is_in_view: bool = false:
	set(value):
		is_in_view = value
		modulate = _tile_data.color_lit if is_in_view else _tile_data.color_dark
		if is_in_view and not is_explored:
			is_explored = true

func set_tile_type(tile_data: _TileData) -> void:
	_tile_data = tile_data
	texture = _tile_data.texture
	modulate = _tile_data.color_dark

func is_walkable() -> bool:
	return _tile_data.is_walkable

func is_transparent() -> bool:
	return _tile_data.is_transparent
