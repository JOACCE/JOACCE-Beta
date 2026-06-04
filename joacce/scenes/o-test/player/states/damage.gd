extends State

const x_speed = 500
const target_y = -100
const hitstun = 0.2
var hit_done = 0
var fighter
var target_x = x_speed

func enter():
	fighter = state_machine.get_parent()
	player.velocity.x = 0
	await player.switch_frame("damage", 20)
	
func exit():
	pass
	
func physics_update(delta):
	hit_done += delta
	
	# stop any hitboxes or actions
	if fighter.get_parent().facing_left == fighter:
		target_x = x_speed
	else:
		target_x = -x_speed
	
	if hit_done <= hitstun:
		fighter.velocity = Vector2(target_x, target_y)
	else:
		fighter.velocity.x = move_toward(fighter.velocity.x, 0, 300*delta)
	
	if fighter.velocity.x == 0 or fighter.velocity.y == 0:
		hit_done = 0
		state_machine.change_state("idle")
		
