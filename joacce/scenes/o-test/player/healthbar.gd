extends TextureProgressBar

func _ready() -> void:
	max_value = 100
	value = max_value

func take_damage(amount: float) -> void:
	value = max(value - amount, 0)

func heal(amount: float) -> void:
	value = min(value + amount, max_value)

# TEMPORARY FOR TESTING, pressing reduces health by 10
func _on_button_pressed() -> void:
	take_damage(10)
