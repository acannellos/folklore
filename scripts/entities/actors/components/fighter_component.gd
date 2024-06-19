class_name FighterComponent
extends Component

var max_hp: int
var hp: int:
	set(value):
		hp = clampi(value, 0, max_hp)
var defense: int
var power: int

func _init(data: FighterData) -> void:
	max_hp = data.max_hp
	hp = data.max_hp
	defense = data.defense
	power = data.power
