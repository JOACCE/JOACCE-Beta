extends Node2D

@onready var fight_music = $FightMusic
@onready var menu_music = $MenuMusic
@onready var ambience_player = $AmbiencePlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if menu_music:
		menu_music.play()
	if ambience_player:
		ambience_player.play()
