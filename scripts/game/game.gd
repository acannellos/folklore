class_name Game
extends Node2D

const player_data = preload("res://data/entities/entity_data_player.tres")

signal player_created(player)

@export var input_handler: InputHandler
@export var map: Map
@export var camera: Camera2D

var player: Entity

func _ready() -> void:
	player = Entity.new(null, Vector2i.ZERO, player_data)
	player_created.emit(player)
	remove_child(camera)
	player.add_child(camera)
	map.generate(player)
	map.update_fov(player.grid_position)
	
	Events.player_died.connect(game_over)
	
	MessageLog.send_message.bind(
		"Welcome, Druid, to yet another forest",
		GameColors.WELCOME_TEXT
	).call_deferred()
#
#func _physics_process(_delta: float) -> void:
	#var action: Action = input_handler.get_action(player)
	#if action:
		#var previous_player_position: Vector2i = player.grid_position
		#action.perform()
		#_handle_enemy_turns()
		#map.update_fov(player.grid_position)

func _physics_process(_delta: float) -> void:
	var action: Action = await input_handler.get_action(player)
	if action:
		var previous_player_position: Vector2i = player.grid_position
		if action.perform():
			_handle_enemy_turns()
			map.update_fov(player.grid_position)

func _handle_enemy_turns() -> void:
	for entity in get_map_data().get_actors():
		if entity.is_alive() and entity != player:
			entity.ai_component.perform()

func get_map_data() -> MapData:
	return map.map_data

func game_over() -> void:
	print("game over, dude")
