class_name Game
extends Node2D

@export var event_handler: EventHandler
@export var map: Map
@export var entities: Node2D
@export var camera: Camera2D

var player: Entity

func _ready() -> void:
	var player_start_pos: Vector2i = Utils.world_to_grid(get_viewport_rect().size.floor() / 2)
	player = Entity.new(player_start_pos, Global.player_data)
	entities.add_child(player)
	map.generate(player)
	map.update_fov(player.grid_position)
	remove_child(camera)
	player.add_child(camera)
	
	var npc := Entity.new(player_start_pos + Vector2i.RIGHT, Global.player_data)
	npc.modulate = Color.ORANGE_RED
	entities.add_child(npc)

func _physics_process(_delta: float) -> void:
	var action: Action = event_handler.get_action()
	#if action:
		#action.perform(self, player)
	if action:
		var previous_player_position: Vector2i = player.grid_position
		action.perform(self, player)
		if player.grid_position != previous_player_position:
			map.update_fov(player.grid_position)

func get_map_data() -> MapData:
	return map.map_data
