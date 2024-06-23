class_name BumpAction
extends ActionWithDirection

func perform() -> bool:
	if get_target_actor():
		if is_in_pool():
			entity.heal_player(1)
			print("HEALS")
		return MeleeAction.new(entity, offset.x, offset.y).perform()
	else:
		if is_in_pool():
			entity.heal_player(1)
			print("HEALS")
		return MovementAction.new(entity, offset.x, offset.y).perform()
