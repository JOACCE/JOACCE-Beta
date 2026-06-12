extends ColorRect

signal countdown_finished

@onready var countdown_label: Label = $CenterContainer/CountdownText
@onready var countdown_sfx: AudioStreamPlayer = $CountdownSFX

@export var countdown_start: int = 3
@export var seconds_per_number: float = 1.0
@export var fight_text_duration: float = 0.6

# Signal for arena

var is_counting_down: bool = false


func _ready() -> void:
	start_countdown()

func start_countdown() -> void:
	if is_counting_down:
		return
	# update as countdown active state
	is_counting_down = true
	show()
	visible = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Play SFX
	countdown_sfx.play()
	
	# Decending countdown and display
	for number in range(countdown_start, 0, -1):
		countdown_label.text = str(number)
		_play_pop_animation()
		# Pause tree per second
		await get_tree().create_timer(seconds_per_number).timeout

	# Display FIGHT with desired time
	countdown_label.text = "FIGHT!"
	_play_pop_animation()
	await get_tree().create_timer(fight_text_duration).timeout
	
	# Update as countdown inactive state
	hide()
	is_counting_down = false
	countdown_finished.emit()

# Animation for each number
func _play_pop_animation() -> void:
	countdown_label.scale = Vector2(0.6, 0.6)
	# Centers scaling
	countdown_label.pivot_offset = countdown_label.size / 2.0

	var tween := create_tween()
	# Scale up
	tween.tween_property(countdown_label, "scale", Vector2(2.0, 2.0), 0.12)
	# Scale down
	tween.tween_property(countdown_label, "scale", Vector2.ONE, 0.12)
