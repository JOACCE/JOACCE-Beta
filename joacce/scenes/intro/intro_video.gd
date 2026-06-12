extends Control

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer

func _ready() -> void:
	video_player.finished.connect(_on_video_finished)
	video_player.play()

func _on_video_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/o-test/menus/start_menu.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/o-test/menus/start_menu.tscn")
