extends Control
#
@export var info: VBoxContainer
@export var stats: Control
@export var log: Control
var is_info_open: bool = true
@export var is_closing: bool = false

var post_flag: bool = true
@onready var post: ColorRect = %post

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("log"):
		toggle_close()
	
	if Input.is_action_just_pressed("quit") and Global.is_game_paused:
		get_tree().quit()
	
	if Input.is_action_just_pressed("crt") and Global.is_game_paused:
		if post_flag:
			post.hide()
			print("hide")
		else:
			post.show()
			print("show")
		post_flag = !post_flag
	
	if Input.is_action_just_pressed("retry") and Global.death_flag:
		Global.death_flag = false
		get_tree().reload_current_scene()

func toggle_close() -> void:
	if not is_closing:
		is_closing = true
		if not is_info_open:
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property(info, "size_flags_stretch_ratio", 1, 1).set_trans(Tween.TRANS_SINE)
			
			tween.chain().tween_property(stats, "visible", true, 0.0)
			tween.tween_property(log, "visible", true, 0.0)
			
			tween.tween_property(stats, "modulate", Color(1,1,1,1), 1).set_trans(Tween.TRANS_SINE)
			tween.tween_property(log, "modulate", Color(1,1,1,1), 1).set_trans(Tween.TRANS_SINE)
			await (tween.finished)
			is_closing = false
		else:
			var tween = get_tree().create_tween().set_parallel(true)
			tween.tween_property(stats, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_SINE)
			tween.tween_property(log, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_SINE)
			
			tween.chain().tween_property(stats, "visible", false, 0.0)
			tween.tween_property(log, "visible", false, 0.0)
			
			tween.tween_property(info, "size_flags_stretch_ratio", 0, 1).set_trans(Tween.TRANS_SINE)
			await (tween.finished)
			is_closing = false

		is_info_open = !is_info_open

func _ready() -> void:
	Events.game_paused.connect(_on_game_paused)
	Events.game_unpaused.connect(_on_game_unpaused)
	Events.torch_equipped.connect(select_torch)
	select_torch(2)

@onready var pause: Control = %pause

func _on_game_paused() -> void:
	pause.show()

func _on_game_unpaused() -> void:
	pause.hide()

@onready var torch_1: NinePatchRect = %torch_1
@onready var torch_2: NinePatchRect = %torch_2
@onready var torch_3: NinePatchRect = %torch_3
@onready var torch_4: NinePatchRect = %torch_4

@export var torch_active: Color = Color(1,1,1,1)
@export var torch_nonactive: Color = Color(1,1,1,1)

func clear_torches() -> void:
	torch_1.modulate = torch_nonactive
	torch_2.modulate = torch_nonactive
	torch_3.modulate = torch_nonactive
	torch_4.modulate = torch_nonactive

func select_torch(i: int) -> void:
	clear_torches()
	match i:
		1:
			torch_1.modulate = torch_active
		2:
			torch_2.modulate = torch_active
		3:
			torch_3.modulate = torch_active
		4:
			torch_4.modulate = torch_active

