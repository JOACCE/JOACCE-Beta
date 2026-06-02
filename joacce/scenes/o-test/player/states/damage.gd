extends State



func enter():
	player.velocity.x = 0
	await player.switch_frame("damage", 0.7)
	state_machine.change_state("idle")
	
func exit():
	pass
	
func physics_update(_delta):
	# stop any hitboxes or actions
	pass
