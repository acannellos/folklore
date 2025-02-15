class_name Entity
extends Sprite2D

var _entity_data = EntityData
var entity_name: String
var blocks_movement: bool
var map_data: MapData

var type: Enums.EntityType:
	set(value):
		type = value
		z_index = type

var fighter_component: FighterComponent
var ai_component: AIComponent

func _init(map_data: MapData, start_position: Vector2i, entity_data: EntityData) -> void:
	centered = false
	grid_position = start_position
	self.map_data = map_data
	set_entity_type(entity_data)

func set_entity_type(entity_data: EntityData) -> void:
	_entity_data = entity_data
	type = _entity_data.type
	blocks_movement = _entity_data.is_blocking_movement
	entity_name = _entity_data.name
	texture = entity_data.texture
	modulate = entity_data.color
	
	match entity_data.ai_type:
		#Enums.AIType.NONE:
			#ai_component = AIComponent.new()
			#add_child(ai_component)
		Enums.AIType.PLAYER:
			ai_component = AIComponent.new()
			add_child(ai_component)
		Enums.AIType.HOSTILE:
			ai_component = HostileAIComponent.new()
			add_child(ai_component)
	
	if entity_data.fighter_data:
		fighter_component = FighterComponent.new(entity_data.fighter_data)
		add_child(fighter_component)

func is_blocking_movement() -> bool:
	return blocks_movement

func get_entity_name() -> String:
	return entity_name

func get_attack_string() -> String:
	return fighter_component.attack_string

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Utils.grid_to_world(grid_position)

func move(move_offset: Vector2i) -> void:
	map_data.unregister_blocking_entity(self)
	grid_position += move_offset
	map_data.register_blocking_entity(self)

func is_alive() -> bool:
	return ai_component != null

func is_player() -> bool:
	return _entity_data.ai_type == Enums.AIType.PLAYER

func heal_player(amount: int) -> void:
	fighter_component.heal(amount)
