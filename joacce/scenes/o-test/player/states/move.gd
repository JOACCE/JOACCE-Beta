extends State

var anim

func enter():
	if not player.lock():
		return
	anim = player.switch_frame("walk")
	anim.play()
	
func exit():
	anim.stop()
	player.unlock()

func physics_update(_delta):
	player.get_movement()
	
	if Input.is_action_just_pressed("p"+str(player.id)+"_punch"):
		state_machine.change_state("punch")
	if Input.is_action_just_pressed("p"+str(player.id)+"_kick"):
		state_machine.change_state("kick")
