extends Node2D

@onready var music_player = $MusicPlayer
@onready var ambience_player = $AmbiencePlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if music_player:
		music_player.play()
	if ambience_player:
		ambience_player.play()
