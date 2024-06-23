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
		"Legends speak of a sacred pool..",
		GameColors.base2
	).call_deferred()
	
	#Audio.play("assets/audio/winds_trim.wav")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("torch_1"):
		map.fov_radius = 4
		map.update_fov(player.grid_position)
		MessageLog.send_message("torch 1 equipped", GameColors.INVALID)
		Events.torch_equipped.emit(1)
	if Input.is_action_just_pressed("torch_2"):
		map.fov_radius = 8
		map.update_fov(player.grid_position)
		MessageLog.send_message("torch 2 equipped", GameColors.INVALID)
		Events.torch_equipped.emit(2)
	if Input.is_action_just_pressed("torch_3"):
		map.fov_radius = 12
		map.update_fov(player.grid_position)
		MessageLog.send_message("torch 3 equipped", GameColors.INVALID)
		Events.torch_equipped.emit(3)
	if Input.is_action_just_pressed("torch_4"):
		map.fov_radius = 24
		map.update_fov(player.grid_position)
		MessageLog.send_message("torch 4 equipped", GameColors.INVALID)
		Events.torch_equipped.emit(4)


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
	Global.death_flag = true
	%retry.show()
	print("game over, dude")
