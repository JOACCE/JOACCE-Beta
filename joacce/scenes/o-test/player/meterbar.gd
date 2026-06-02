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
		var charge : Panel = get_child(i)
		if !charge:
			return
		# Fill in charge color for each charge slot until current charges reached
		var style : StyleBoxFlat = charge.get_theme_stylebox("panel")
		# Ensure not every panel references the same stylebox
		style = style.duplicate()
		charge.add_theme_stylebox_override("panel", style)
		if i < current_charges:
			style.bg_color = Color(0.2, 1, 1, 1)
		else:
			style.bg_color = Color(0, 0, 0, 0.092)
