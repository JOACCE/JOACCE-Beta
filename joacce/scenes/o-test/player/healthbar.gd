extends TextureProgressBar

# Will be synced to each player later
# : set calls the given function for every value change

var health = 0 : set = _set_health
var _updating := false

func _ready() -> void:
	init_health(100)
	
# Set initial health state for UI
func init_health(in_health: float) -> void:
	max_value = in_health
	health = in_health
	# Set progress bar value (initially matches in damagebar)
	value = health
	
	
# Runs on event health variable changes value
func _set_health(new_health: float) -> void:
	if _updating:
		return
	_updating = true
	health = clamp(new_health, 0, max_value)
	value = health
	_updating = false
	print("current health: ", health)
	
# TEMPORARY FOR TESTING, pressing reduces health by 10
func _on_button_pressed() -> void:
	health -= 10
