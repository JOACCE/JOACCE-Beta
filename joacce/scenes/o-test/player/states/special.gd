extends "res://scenes/o-test/player/states/state.gd"


# Called when the node enters the scene tree for the first time.
var special_number = 1

func enter() -> void:
	var sprite = player.special_1 if special_number == 1 else player.special_2
	player.play_special(sprite)
func exit():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta):
	if not player.animation_playing:
		state_machine.change_state("idle")
