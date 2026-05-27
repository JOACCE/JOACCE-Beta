extends "res://scenes/o-test/player/states/state.gd"

var has_kicked = false
# Called when the node enters the scene tree for the first time.
func enter() -> void:
	has_kicked = false
	#trying to pucnh int the correct direction. 
	#if player.sprites.scale.x < 0:
		#player.punch.scale.x = -1
	#else:
		#player.punch.scale.x = 1
	player.kick.attack()
	player.show_frame(player.kick_frame, 1.0)
	
func exit():
	has_kicked = false
	

func physics_update(_delta):
	if not has_kicked:
		has_kicked = true
		return 
	if not player.animation_playing:
		state_machine.change_state("idle")
	
