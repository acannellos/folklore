extends MarginContainer

@export var hp_bar: ProgressBar
@export var hp_label: Label

var registerd_player: Entity

func change_player_hp(hp: int, max_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	hp_label.text = "HP: %d/%d" % [hp, max_hp]

func change_fighter_hp(fighter: Entity, hp: int, max_hp: int) -> void:
	if fighter == registerd_player:
		hp_bar.max_value = max_hp
		hp_bar.value = hp
		hp_label.text = "HP: %d/%d" % [hp, max_hp]

func initialize(player: Entity) -> void:
	await ready
	
	#Events.player_hp_changed.connect(change_player_hp)
	Events.fighter_hp_changed.connect(change_fighter_hp)
	
	var player_hp: int = player.fighter_component.hp
	var player_max_hp: int = player.fighter_component.max_hp
	#change_player_hp(player_hp, player_max_hp)
	
	registerd_player = player
	change_fighter_hp(player, player_hp, player_max_hp)
