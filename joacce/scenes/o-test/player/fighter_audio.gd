extends Node2D

# Reference to each SFX to play
@onready var punch_sfx : AudioStreamPlayer2D = $Punch
@onready var impact_sfx : AudioStreamPlayer2D= $Impact
@onready var kick_sfx : AudioStreamPlayer2D = $Kick
@onready var fireball_sfx : AudioStreamPlayer2D = $Fireball
@onready var charge_sfx : AudioStreamPlayer2D = $Charge

var sfx_table = {}

func _ready() ->void:
	sfx_table = {
		"punch" : punch_sfx,
		"impact" : impact_sfx,
		"kick" : kick_sfx,
		"fireball" : fireball_sfx,
		"charge" : charge_sfx
	}

func play_sfx(sfx: String) -> void:
	var sfx_to_play = sfx_table.get(sfx)
	if (!sfx_to_play):
		print("SFX NOT FOUND!")
		return
	
	# Will overlap with preexisting audio
	sfx_to_play.play()

func stop_sfx(sfx: String) -> void:
	var sfx_to_stop = sfx_table.get(sfx)
	if (!sfx_to_stop):
		print("SFX NOT FOUND!")
		return
	
	# Will overlap with preexisting audio
	sfx_to_stop.stop()
