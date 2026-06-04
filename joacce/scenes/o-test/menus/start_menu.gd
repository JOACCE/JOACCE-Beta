extends Control

func _on_fight_pressed() -> void:
	AudioManager.play_music("fight")
	get_tree().change_scene_to_file("res://scenes/o-test/level/arena.tscn")

func _on_create_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
