extends Control

@export var game_scene: PackedScene

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("log"):
		if game_scene:
			start_game()
			#get_tree().change_scene_to_packed(game_scene)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var is_info_open: bool = false
@export var is_closing: bool = false
@onready var info: PanelContainer = $HBoxContainer/info

@onready var title: Label = %title
@onready var start: Label = %start

func start_game() -> void:
	if not is_closing:
		is_closing = true
		if not is_info_open:
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property(info, "size_flags_stretch_ratio", 1, 1).set_trans(Tween.TRANS_SINE)
			tween.tween_property(title, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_SINE)
			tween.tween_property(start, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_SINE)
			await (tween.finished)
			is_closing = false
			get_tree().change_scene_to_packed(game_scene)
		#else:
			#var tween = get_tree().create_tween().set_parallel(true)
			#tween.tween_property(info, "size_flags_stretch_ratio", 0, 1).set_trans(Tween.TRANS_SINE)
			#await (tween.finished)
			#is_closing = false

		is_info_open = !is_info_open

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
