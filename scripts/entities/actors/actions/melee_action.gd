class_name MeleeAction
extends ActionWithDirection

func perform() -> bool:
	var target: Entity = get_target_actor()
	if not target:
		if entity == get_map_data().player:
			MessageLog.send_message("Nothing to attack.", GameColors.IMPOSSIBLE)
		return false
	
	if target.type == Enums.EntityType.SIGN:
		MessageLog.send_message("hellooo friendo !^ $%&!*(@, have y^u heard $%!@ the pools of ip^* )(@*$!@ @!# ^% !@#$ hea! y^u)", GameColors.HEALTH_RECOVERED)
		return false
	
	var damage: int = entity.fighter_component.power - target.fighter_component.defense
	var attack_color: Color
	if entity == get_map_data().player:
		attack_color = GameColors.PLAYER_ATTACK
	else:
		attack_color = GameColors.ENEMY_ATTACK
	var attack_description: String = "%s %s %s" % [entity.get_entity_name(), entity.get_attack_string(), target.get_entity_name()]
	if damage > 0:
		attack_description += " for %d hit points." % damage
		MessageLog.send_message(attack_description, attack_color)
		target.fighter_component.hp -= damage
	else:
		attack_description += " but does no damage."
		MessageLog.send_message(attack_description, attack_color)
	return true
