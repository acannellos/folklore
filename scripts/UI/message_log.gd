class_name MessageLog
extends ScrollContainer

var last_message: Message = null

@export var message_list: VBoxContainer

func _ready() -> void:
	Events.message_sent.connect(add_message)

func add_message(text: String, color: Color) -> void:
	if (
		last_message != null and
		last_message.plain_text == text
	):
		last_message.count += 1
	else:
		var message := Message.new(text, color)
		last_message = message
		message_list.add_child(message)
		await get_tree().process_frame
		ensure_control_visible(message)

static func send_message(text: String, color: Color) -> void:
	Events.message_sent.emit(text, color)
