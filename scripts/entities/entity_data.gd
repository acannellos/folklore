class_name EntityData
extends Resource

@export_category("Visuals")
@export var name: String = "Unnamed"
@export var texture: AtlasTexture
@export_color_no_alpha var color: Color = Color.WHITE

@export_category("Mechanics")
@export var is_blocking_movement: bool = true

#is_aggressive