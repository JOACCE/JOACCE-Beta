extends State
class_name IdleState

func enter():
	if not player.lock():
		return 
	player.switch_frame("idle")
	player.velocity.x = 0

func exit():
	player.unlock()
	pass

func physics_update(_delta):
	player.get_movement()
	
	if player.velocity.x:
		state_machine.change_state("walk")
		
	if Input.is_action_just_pressed("p"+str(player.id)+"_jump") and player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY
		
	if Input.is_action_just_pressed("p"+str(player.id)+"_charge") and player.is_on_floor():
		state_machine.change_state("charge")
	if Input.is_action_just_pressed("p"+str(player.id)+"_punch"):
		state_machine.change_state("punch")
	if Input.is_action_just_pressed("p"+str(player.id)+"_kick"):
		state_machine.change_state("kick")
	if Input.is_action_just_pressed("p"+str(player.id)+"_special1"):
		state_machine.change_state("special_1")
	if Input.is_action_just_pressed("p"+str(player.id)+"_special2"):
		state_machine.change_state("special_2")
		
	
