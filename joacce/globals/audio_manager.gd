extends Node2D

@onready var fight_music: AudioStreamPlayer = $FightMusic
@onready var menu_music: AudioStreamPlayer = $MenuMusic
@onready var ambience_player: AudioStreamPlayer = $AmbiencePlayer
@onready var ui_click_sfx : AudioStreamPlayer = $UIClick
@onready var ui_hover_sfx : AudioStreamPlayer = $UIHover

var currently_playing: AudioStreamPlayer

const MUSIC_FADE_TIME := 0.6
const MUTED_VOLUME_DB := -80.0

var song_contexts : Dictionary = {}
var volume_contexts : Dictionary = {}

func _ready() -> void:
	# Assign contexts
	song_contexts = {
		"fight" : fight_music,
		"menu" : menu_music
	}
	
	# Assign volume contexts (as each song has a different volume
	volume_contexts = {
		"fight" : -10.5,
		"menu" : -8.0
	}
	
	if menu_music:
		menu_music.volume_db = volume_contexts.get("menu")
		menu_music.play()
		currently_playing = menu_music

	if fight_music:
		fight_music.volume_db = MUTED_VOLUME_DB

	if ambience_player:
		ambience_player.play()
	
	

func play_music(new_song: String) -> void:
	var next_song: AudioStreamPlayer = song_contexts.get(new_song)
	if !next_song:
		return

	var music_volume_db : float = volume_contexts.get(new_song)
	if !music_volume_db:
		return
	crossfade_music(next_song, music_volume_db)


func crossfade_music(next_song: AudioStreamPlayer, music_volume_db : float) -> void:
	# If songs match, don't switch
	if currently_playing == next_song:
		return

	# Cross fade between two songs
	var old_song : AudioStreamPlayer= currently_playing
	next_song.volume_db = MUTED_VOLUME_DB

	if not next_song.playing:
		next_song.play()

	currently_playing = next_song

	var tween := create_tween()
	tween.set_parallel(true)

	if old_song:
		tween.tween_property(old_song, "volume_db", MUTED_VOLUME_DB, MUSIC_FADE_TIME)

	tween.tween_property(next_song, "volume_db", music_volume_db, MUSIC_FADE_TIME)

	tween.set_parallel(false)

	if old_song:
		tween.tween_callback(old_song.stop)

func play_click_sfx() -> void:
	if (ui_click_sfx):
		ui_click_sfx.play()

func play_hover_sfx() -> void:
	if(ui_hover_sfx):
		ui_hover_sfx.pitch_scale = randf_range(0.7, 1.3)
		ui_hover_sfx.play()
