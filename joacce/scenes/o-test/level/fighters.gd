extends Node2D

@onready var fighter: CharacterBody2D = $Fighter
@onready var fighter_2: CharacterBody2D = $Fighter2


var facing_left
func _ready() -> void:
	call_deferred("set_p2")

func set_p2():
	fighter_2.scale.x = -1
	facing_left = fighter_2
	
func _process(_delta: float) -> void:
	
	if fighter.global_position.x > fighter_2.global_position.x and facing_left == fighter_2:
		flip_children()
	if fighter.global_position.x < fighter_2.global_position.x and facing_left != fighter_2:
		flip_children()
	

func flip_children():
	fighter.scale.x *= -1
	fighter_2.scale.x *= -1
	if facing_left == fighter_2:
		facing_left = fighter
	else:
		facing_left = fighter_2
