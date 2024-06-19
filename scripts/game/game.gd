class_name Game
extends Node2D

const player_data = preload("res://data/entities/entity_data_player.tres")

@export var input_handler: InputHandler
@export var map: Map
@export var camera: Camera2D

var player: Entity

func _ready() -> void:
	player = Entity.new(null, Vector2i.ZERO, player_data)
	remove_child(camera)
	player.add_child(camera)
	map.generate(player)
	map.update_fov(player.grid_position)

func _physics_process(_delta: float) -> void:
	var action: Action = input_handler.get_action(player)
	if action:
		var previous_player_position: Vector2i = player.grid_position
		action.perform()
		#_handle_enemy_turns()
		map.update_fov(player.grid_position)

func _handle_enemy_turns() -> void:
	for entity in get_map_data().entities:
		if entity == player:
			continue
		print("The %s wonders when it will get to take a real turn." % entity.get_entity_name())

func get_map_data() -> MapData:
	return map.map_data
