class_name FighterComponent
extends Component

var max_hp: int
var hp: int:
	set(value):
		hp = clampi(value, 0, max_hp)
		if hp <= 0:
			die()
var defense: int
var power: int

var death_texture: Texture
var death_color: Color

func _init(data: FighterData) -> void:
	max_hp = data.max_hp
	hp = data.max_hp
	defense = data.defense
	power = data.power
	death_texture = data.death_texture
	death_color = data.death_color

func die() -> void:
	var death_message: String
	
	if get_map_data().player == entity:
		death_message = "You died!"
		Events.player_died.emit()
	else:
		death_message = "%s is dead!" % entity.get_entity_name()
	
	print(death_message)
	entity.texture = death_texture
	entity.modulate = death_color
	entity.ai_component.queue_free()
	entity.ai_component = null
	entity.entity_name = "Remains of %s" % entity.entity_name
	entity.blocks_movement = false
	get_map_data().unregister_blocking_entity(entity)
	entity.type = Enums.EntityType.CORPSE
