class_name EntityData
extends Resource

enum AIType {NONE, HOSTILE}

@export_category("Visuals")
@export var name: String = "Unnamed"
@export var texture: AtlasTexture
@export_color_no_alpha var color: Color = Color.WHITE

@export_category("Mechanics")
@export var is_blocking_movement: bool = true

@export_category("Components")
@export var fighter_data: FighterData
#@export var ai_type: AIType
@export_enum("NONE", "HOSTILE") var ai_type: String = "NONE"
