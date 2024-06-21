extends Control
#
#@export var info: VBoxContainer
#@export var stats: PanelContainer
#@export var log: PanelContainer
#var is_info_closed: bool = false
#
#func _unhandled_input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("log"):
		#if is_info_closed:
			#var tween = get_tree().create_tween().set_parallel(true)
			#tween.tween_property(info, "size_flags_stretch_ratio", 1, 1).set_trans(Tween.TRANS_SINE)
			##tween.tween_property(info, "modulate", Color(1,1,1,1), 1).set_trans(Tween.TRANS_SINE)
			#tween.tween_property(stats, "modulate", Color(1,1,1,1), 1).set_trans(Tween.TRANS_SINE)
			#tween.tween_property(log, "modulate", Color(1,1,1,1), 1).set_trans(Tween.TRANS_SINE)
		#else:
			#var tween = get_tree().create_tween().set_parallel(true)
			#tween.tween_property(info, "size_flags_stretch_ratio", 0, 1).set_trans(Tween.TRANS_SINE)
			##tween.tween_property(info, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_SINE)
			#tween.tween_property(stats, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_SINE)
			#tween.tween_property(log, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_SINE)
#
		#is_info_closed = !is_info_closed
