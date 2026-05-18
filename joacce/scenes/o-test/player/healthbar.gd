extends ProgressBar

@onready var timer = $DamageTimer
@onready var damage_bar = $DamageBar

# Will be synced to each player later
# : set calls the given function for every value change
var health = 0 : set = _set_health

func _ready() -> void:
	init_health(100)

# Set initial health state for UI
func init_health(in_health: float) -> void:
	health = in_health
	max_value = health
	# Set progress bar value (initially matches in damagebar)
	value = health
	damage_bar.max_value = max_value
	damage_bar.value = health

# Runs on event health variable changes value
func _set_health(new_health: float) -> void:
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health < prev_health:
		timer.start()
	else:
		# Case of added health
		damage_bar.value = value

# Once timer ends set bar behind healthbar
func _on_damage_timer_timeout() -> void:
	damage_bar.value = health

# TEMPORARY FOR TESTING, pressing reduces health by 10
func _on_button_pressed() -> void:
	health -= 10
