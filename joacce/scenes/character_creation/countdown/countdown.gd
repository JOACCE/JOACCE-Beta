extends Node

@onready var label = $Label
@onready var timer = $Timer

@export var timer_length : float = 5.0

signal timer_expired()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = timer_length

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (!timer.is_stopped()):
		label.text = "%d" % time_left_to_live()

##
## Start timer and show label
##
func start() -> void:
	timer.start()
	label.show()

##
## Calculate time left in seconds
##
func time_left_to_live() -> int:
	# Time left in seconds
	var time_left = timer.time_left
	
	var second = int(time_left) % 60 + 1 # +1 so range is [1, N]
	
	return second

##
## Stop timer and hide label
##
func _on_timer_timeout() -> void:
	timer.stop()
	label.hide()
	
	timer_expired.emit()
