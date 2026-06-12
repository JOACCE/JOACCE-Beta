extends "state.gd"


func enter():
	player.get_sprite("idle").visible = false
	if not player.is_on_floor() and player.kick:
		player.kick.visible = true
	
func exit():
	pass
	
func update_physics():
	pass
