extends HBoxContainer

@export var max_charges : int = 5
var current_charges : int = 0

func _ready() -> void:
	# Init charges
	update_charges(0)



func update_charges(value: int) -> void:
	current_charges = value
	
	# Reference each charge
	for i in get_child_count():
		var charge : TextureRect = get_child(i)
		if !charge:
			return
		# Fill in charge color for each charge slot until current charges reached
		if i < current_charges:
			charge.modulate = Color(1, 1, 1, 1)
		else:
			charge.modulate = Color(0, 0, 0, 0.092)
