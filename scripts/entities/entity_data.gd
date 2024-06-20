class_name EntityData
extends Resource

@export_category("Visuals")
@export var name: String = "Unnamed"
@export var texture: AtlasTexture
@export_color_no_alpha var color: Color = Color.WHITE

@export_category("Mechanics")
@export var is_blocking_movement: bool = true
@export var type: Enums.EntityType = Enums.EntityType.ACTOR

@export_category("Components")
@export var fighter_data: FighterData
@export var ai_type: Enums.AIType
#@export_enum(
	#"NONE",
	#"PLAYER",
	#"HOSTILE"
	#) var ai_type: String = "NONE"
