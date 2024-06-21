extends Control

@export var info: VBoxContainer
var is_info_closed: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("log"):
		if is_info_closed:
			var tween = get_tree().create_tween()
			tween.tween_property(info, "size_flags_stretch_ratio", 1, 1).set_trans(Tween.TRANS_SINE)
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(info, "size_flags_stretch_ratio", 0, 1).set_trans(Tween.TRANS_SINE)
		is_info_closed = !is_info_closed
		#info.size_flags_stretch_ratio = 0

