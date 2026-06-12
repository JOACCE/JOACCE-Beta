extends State

var has_punched = false

const grounded_dmg = 10
const jumping_dmg = 7

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	if not player.lock():
		return
	has_punched = false
	player.current_damage = jumping_dmg
	if player.is_on_floor_only():
		player.current_damage = grounded_dmg
	player.punch.attack()
	await player.switch_frame("punch", 1.0)
	player.unlock()

func exit():
	player.current_damage = 0

func physics_update(_delta):
	if player.is_on_floor_only():
		player.velocity.x = 0
		if player.current_damage != grounded_dmg:
			player.current_damage = grounded_dmg
			print("damage is grounded")
	else:
		player.get_movement()
		if player.current_damage == grounded_dmg:
			player.current_damage = jumping_dmg
			print("damage is jumping")
		
	if player.lock():
		player.unlock()
		state_machine.change_state("idle")
