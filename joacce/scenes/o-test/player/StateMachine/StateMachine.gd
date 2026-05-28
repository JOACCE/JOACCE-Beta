extends Node


var current_state
var states = {}



func _ready():
	states ={
		"idle": preload("res://scenes/o-test/player/states/idle_state.gd").new(),
		"walk": preload("res://scenes/o-test/player/states/move.gd").new(),
		"charge": preload("res://scenes/o-test/player/states/charge.gd").new(),
		"punch" : preload("res://scenes/o-test/player/states/punch.gd").new(),
		"kick" : preload("res://scenes/o-test/player/states/kick.gd").new(),
		"special_1": preload("res://scenes/o-test/player/states/special.gd").new(),
		"special_2": preload("res://scenes/o-test/player/states/special.gd").new(),
		"damage" : preload("res://scenes/o-test/player/states/damage.gd").new()
	}
	print(states)
	print(get_parent())
	states["special_1"].special_number =1
	states["special_2"].special_number =2

	
	for state in states.values():
		state.player = get_parent()
		state.state_machine =self
		print("state", state, " | Player ",state.player)
	
	call_deferred("change_state","idle")	
	
	#Looks for states in the dict
func change_state(state_name):
	if current_state:
		current_state.exit()
	current_state = states[state_name]
	current_state.enter()
	
func physics_update(delta):
	if current_state:
		current_state.physics_update(delta)
