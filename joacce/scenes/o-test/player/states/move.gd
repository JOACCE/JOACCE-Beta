extends "State.gd"

func enter():
	
	player.get_sprite("idle").visible = false
	player.get_sprite("walk").visible = true
	player.get_sprite("walk").play()
	
func exit():
	player.get_sprite("walk").visible = false
	player.get_sprite("walk").stop()
func physics_update(_delta):
	
	var direction = Input.get_axis(
		"p"+str(player.id)+"_left",
		"p"+str(player.id)+"_right"
	)
	player.velocity.x = direction * player.SPEED
	
	#flip
	if direction != 0:
		player.walk.flip_h = direction < 0
		
	if direction == 0:
		state_machine.change_state("idle")
	#if Input.is_action_just_pressed("p"+str(player.id)+"_jump"):
		#state_machine.change_state("jump")
