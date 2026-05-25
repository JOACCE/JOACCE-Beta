extends "state.gd"

class_name IdleState

func enter():
	
	print(player)
	print(player.idle)
	print(player.walk)
	if player.animation_playing:
		return
	player.get_sprite("idle").visible = true
	player.get_sprite("walk").visible = false
	player.velocity.x =0
func exit():
	pass
func physics_update(_delta):
	
	var direction = Input.get_axis(
	"p"+str(player.id)+"_left",
	"p"+str(player.id)+"_right"
	)
	if direction != 0:
		state_machine.change_state("walk")
	
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

		
	
