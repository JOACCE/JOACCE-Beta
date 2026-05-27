extends "state.gd"

var has_punched = false
# Called when the node enters the scene tree for the first time.
func enter() -> void:
	has_punched = false
	#trying to pucnh int the correct direction. 
	#if player.sprites.scale.x < 0:
		#player.punch.scale.x = -1
	#else:
		#player.punch.scale.x = 1
	player.punch.attack()
	
	player.show_frame(player.punch_frame, 1.0)
	
func exit():
	has_punched = false
	

func physics_update(_delta):
	if not has_punched:
		has_punched = true
		return 
	if not player.animation_playing:
		state_machine.change_state("idle")
	
