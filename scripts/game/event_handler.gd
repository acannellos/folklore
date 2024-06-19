class_name EventHandler
extends Node

func get_action() -> Action:
	var action: Action = null
	
	if Input.is_action_just_pressed("wait"):
		action = BumpAction.new(0, 0)
	elif Input.is_action_just_pressed("up_left"):
		action = BumpAction.new(-1, -1)
	elif Input.is_action_just_pressed("up"):
		action = BumpAction.new(0, -1)
	elif Input.is_action_just_pressed("up_right"):
		action = BumpAction.new(1, -1)
	elif Input.is_action_just_pressed("right"):
		action = BumpAction.new(1, 0)
	elif Input.is_action_just_pressed("down_right"):
		action = BumpAction.new(1, 1)
	elif Input.is_action_just_pressed("down"):
		action = BumpAction.new(0, 1)
	elif Input.is_action_just_pressed("down_left"):
		action = BumpAction.new(-1, 1)
	elif Input.is_action_just_pressed("left"):
		action = BumpAction.new(-1, 0)

	if Input.is_action_just_pressed("ui_cancel"):
		action = EscapeAction.new()
	
	return action
