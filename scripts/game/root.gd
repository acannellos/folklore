extends Control
#
@export var info: VBoxContainer
@export var stats: Control
@export var log: Control
var is_info_closed: bool = false
@export var is_closing: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("log"):
		if not is_closing:
			is_closing = true
			if is_info_closed:
				var tween = get_tree().create_tween().set_parallel(true)
				tween.tween_property(info, "size_flags_stretch_ratio", 1, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				
				tween.chain().tween_property(stats, "visible", true, 0.0)
				tween.tween_property(log, "visible", true, 0.0)
				
				tween.tween_property(stats, "modulate", Color(1,1,1,1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				tween.tween_property(log, "modulate", Color(1,1,1,1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
				await (tween.finished)
				is_closing = false
			else:
				var tween = get_tree().create_tween().set_parallel(true)
				tween.tween_property(stats, "modulate", Color(1,1,1,0), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
				tween.tween_property(log, "modulate", Color(1,1,1,0), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
				
				tween.chain().tween_property(stats, "visible", false, 0.0)
				tween.tween_property(log, "visible", false, 0.0)
				
				tween.tween_property(info, "size_flags_stretch_ratio", 0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
				await (tween.finished)
				is_closing = false

			is_info_closed = !is_info_closed
