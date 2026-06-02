extends State


# Called when the node enters the scene tree for the first time.
var special_number = 1

func enter() -> void:
	if not player.is_on_floor():
		return
	if not player.lock():
		return
	var sprite = player.special_1 if special_number == 1 else player.special_2
	await player.play_special(sprite)
	player.unlock()
	
func exit():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	if special_number == 1:
		player.velocity.x = 0
	if player.lock():
		player.unlock()
		state_machine.change_state("idle")
