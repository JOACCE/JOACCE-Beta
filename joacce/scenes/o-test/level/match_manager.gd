extends Node2D

# reference to each fighter, needed to track hp
@onready var fighter_1 = $Fighters/Fighter
@onready var fighter_2 = $Fighters/Fighter2

# Each fighter will send a signal when their health reaches 0

#func _ready():
	#fight
