class_name InputHandler
extends Node

const directions = {
	"up": Vector2i.UP,
	"down": Vector2i.DOWN,
	"left": Vector2i.LEFT,
	"right": Vector2i.RIGHT,
	"up_left": Vector2i.UP + Vector2i.LEFT,
	"up_right": Vector2i.UP + Vector2i.RIGHT,
	"down_left": Vector2i.DOWN + Vector2i.LEFT,
	"down_right": Vector2i.DOWN + Vector2i.RIGHT,
}

var death_flag: bool = false

func _ready() -> void:
	Events.player_died.connect(_on_player_died)

func _on_player_died() -> void:
	death_flag = true

func get_action(player: Entity) -> Action:
	var action: Action = null
	
	for direction in directions:
		if Input.is_action_just_pressed(direction) and not death_flag:
			var offset: Vector2i = directions[direction]
			action = BumpAction.new(player, offset.x, offset.y)
	
	if Input.is_action_just_pressed("wait"):
		action = WaitAction.new(player)
	
	if Input.is_action_just_pressed("ui_cancel"):
		action = EscapeAction.new(player)
	
	return action
