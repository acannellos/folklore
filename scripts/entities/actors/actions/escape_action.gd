class_name EscapeAction
extends Action

func perform() -> bool:
	#entity.get_tree().quit()
	if Global.is_game_paused:
		Global.is_game_paused = false
		Events.game_unpaused.emit()
		#entity.get_tree().quit()
	else:
		Global.is_game_paused = true
		Events.game_paused.emit()
	return false
