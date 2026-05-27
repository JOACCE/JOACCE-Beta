extends "res://scenes/o-test/player/states/state.gd"
class_name chargeState
var stack_inputted : bool = false

func enter():
	player.get_sprite("charge").visible = true
	player.get_sprite("idle").visible = false
	player.charge.play()
	player.velocity.x =0
	stack_inputted = false
func exit():
	player.charge_bar.visible = false
	player.charge_time =0
	player.current_charge = 0
	player.charge_bar.value =0
	player.get_sprite("charge").visible = false
	player.get_sprite("idle").visible = true

	player.charge.stop()
	stack_inputted = true
	
func physics_update(delta):
	if Input.is_action_pressed("p"+str(player.id)+"_charge") and player.is_on_floor():
		if player.current_charge < player.max_charge:
			player.charge_bar.visible = true
			player.charge_time += delta
			if player.charge_time >= 0.5:
				player.current_charge += player.charge_speed * delta
				player.charge_bar.value = player.current_charge
				player.charge.visible = true
				player.idle.visible = false
		elif player.current_charge >= player.max_charge and stack_inputted == false:
			# Update the stack count
			var new_charge_stack = min(player.charge_stack + 1, player.max_stack)
			player.charge_stack = new_charge_stack
			player.meter_bar.update_charges(new_charge_stack)
			stack_inputted = true
	else:
		state_machine.change_state("idle")
		
	
	
