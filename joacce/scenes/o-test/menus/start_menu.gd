extends Control

var _valid_os : Array[String] = ["macOS", "Linux", "Android", "iOS"]

func _on_fight_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/o-test/level/arena.tscn")

func _on_create_pressed() -> void:
	if (OS.get_name() in _valid_os):
		get_tree().change_scene_to_file("res://scenes/character_creation/camera_select/camera_select.tscn")
	else:
		print("Character creation not supported on ", OS.get_name())

func _on_quit_pressed() -> void:
	get_tree().quit()
