extends Node2D

# reference to each fighter, needed to track hp
@onready var fighter_1 = $Fighters/Fighter
@onready var fighter_2 = $Fighters/Fighter2

var end_menu_scene := preload("res://scenes/o-test/menus/end_match_menu.tscn")
var end_menu: Node = null

# Each fighter will send a signal when their health reaches 0
var match_ended : bool = false

func _ready():
	# Connect signals to fighter
	fighter_1.health_depleted.connect(_on_health_depleted)
	fighter_2.health_depleted.connect(_on_health_depleted)
	
	# if match end menu existing, remove
	if end_menu:
		end_menu.queue_free()

# runs when either fighter hp reaches 0
# responsible for ending the match
func _on_health_depleted(loser_id: int):
	if match_ended:
		return
	# match end scene already exists
	if end_menu != null:
		return
	
	match_ended = true
	# Set the winner ID
	var winner_id := 2 if loser_id == 1 else 1
	
	# Pause the arena scene in the background
	get_tree().paused = true
	
	# Load in the match end scene
	end_menu = end_menu_scene.instantiate()
	end_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	# Send winner info to the menu before adding it
	end_menu.winner_id = winner_id
	get_tree().root.add_child(end_menu)
