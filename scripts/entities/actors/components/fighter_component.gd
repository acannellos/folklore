class_name FighterComponent
extends Component

var max_hp: int
var hp: int:
	set(value):
		hp = clampi(value, 0, max_hp)
		#Events.player_hp_changed.emit(hp, max_hp)
		Events.fighter_hp_changed.emit(entity, hp, max_hp)
		
		if hp <= 0:
			die()
var defense: int
var power: int

var death_texture: Texture
var death_color: Color
var attack_string: String

func _init(data: FighterData) -> void:
	max_hp = data.max_hp
	hp = data.max_hp
	defense = data.defense
	power = data.power
	death_texture = data.death_texture
	death_color = data.death_color
	attack_string = data.attack_string

func heal(amount: int) -> int:
	if hp == max_hp:
		return 0
	
	var new_hp_value: int = hp + amount
	
	if new_hp_value > max_hp:
		new_hp_value = max_hp
		
	var amount_recovered: int = new_hp_value - hp
	hp = new_hp_value
	return amount_recovered


func take_damage(amount: int) -> void:
	hp -= amount

func die() -> void:
	var death_message: String
	var death_message_color: Color
	
	if get_map_data().player == entity:
		death_message = "You died"
		death_message_color = GameColors.PLAYER_DIE
		Events.player_died.emit()
	else:
		death_message = "%s is dead" % entity.get_entity_name()
		death_message_color = GameColors.ENEMY_DIE
	
	MessageLog.send_message(death_message, death_message_color)
	
	print(death_message)
	entity.texture = death_texture
	entity.modulate = death_color
	entity.ai_component.queue_free()
	entity.ai_component = null
	entity.entity_name = "Bones of %s" % entity.entity_name
	entity.blocks_movement = false
	get_map_data().unregister_blocking_entity(entity)
	entity.type = Enums.EntityType.CORPSE
