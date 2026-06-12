extends Node2D

# reference to each fighter, needed to track hp
@onready var fighter_1 = $Fighters/Fighter
@onready var fighter_2 = $Fighters/Fighter2

@onready var match_countdown: ColorRect = $Fighters/Fighter2/Canvas/MatchCountdown

var end_menu_scene := preload("res://scenes/o-test/menus/end_match_menu.tscn")
var end_menu: Node = null

# Each fighter will send a signal when their health reaches 0
var match_ended : bool = false
# Used to track when to play countdown
var match_started: bool = false

# Slow motion constants
@export var end_slow_motion_scale: float = 0.25
@export var end_slow_motion_duration: float = 2.0

var fighter_mapping : Dictionary = {}

func _ready():
	# Reset match state
	Engine.time_scale = 1.0
	get_tree().paused = false
	
	# Connect signals to fighter
	fighter_1.health_depleted.connect(_on_health_depleted)
	fighter_2.health_depleted.connect(_on_health_depleted)
	
	fighter_1.set_sprites()
	fighter_2.set_sprites()
	
	# if match end menu existing, remove
	if end_menu:
		end_menu.queue_free()
	
	get_tree().paused = false
	match_ended = false
	match_started = false
	
	# Block player input until countdown finished
	_set_fighters_match_enabled(false)
	
	if (!match_countdown):
		return
	# Connect countdown signal
	match_countdown.countdown_finished.connect(_on_countdown_finished)
	# Start countdown
	match_countdown.start_countdown()
	
	# Player dictionary
	fighter_mapping = {
		1: fighter_1,
		2: fighter_2
	}

# runs when either fighter hp reaches 0
# responsible for ending the match
func _on_health_depleted(loser_id: int):
	if match_ended:
		return
	# match end scene already exists
	if end_menu != null:
		return
	
	match_ended = true
	match_started = false
	
	# Set the winner ID
	var winner_id := 2 if loser_id == 1 else 1
	
	# Dramatic slow motion before pausing
	Engine.time_scale = end_slow_motion_scale
	await get_tree().create_timer(
		end_slow_motion_duration,
		true,
		false,
		true
	).timeout
	
	# Stop both players from continuing to control characters.
	_set_fighters_match_enabled(false)
	
	# Set poses
	var loser = fighter_mapping.get(loser_id)
	if !loser:
		return
	var winner = fighter_mapping.get(winner_id)
	if !winner:
		return
	loser.switch_frame("loss")
	winner.switch_frame("win")

	# Reset before pausing for menus/restarts to be at normal speed
	Engine.time_scale = 1.0
	
	# Pause the arena scene in the background one player in poses
	get_tree().paused = true
	
	
	# Load in the match end scene
	end_menu = end_menu_scene.instantiate()
	end_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	# Send winner info to the menu before adding it
	end_menu.winner_id = winner_id
	get_tree().root.add_child(end_menu)

func _set_fighters_match_enabled(enabled: bool) -> void:
	fighter_1.set_match_enabled(enabled)
	fighter_2.set_match_enabled(enabled)

# Runs on signal countdown end
func _on_countdown_finished() -> void:
	match_started = true
	# Unblock player input
	_set_fighters_match_enabled(true)
