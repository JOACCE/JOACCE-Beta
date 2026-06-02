extends State

var has_punched = false

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	if not player.lock():
		return
	has_punched = false
	player.punch.attack()
	await player.switch_frame("punch", 1.0)
	player.unlock()

func exit():
	pass

func physics_update(_delta):
	if player.is_on_floor_only():
		player.velocity.x = 0
	else:
		player.get_movement()
		
	if player.lock():
		player.unlock()
		state_machine.change_state("idle")
