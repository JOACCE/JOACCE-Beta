extends State



func enter():
	player.switch_frame("damage")
	
func exit():
	pass
func physics_update(_delta):
	# stop any hitboxes or actions
	pass
