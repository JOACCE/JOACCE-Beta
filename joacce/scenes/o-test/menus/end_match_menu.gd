extends Control

# Reference to label text
@onready var text : Label = $CanvasLayer/Text

# fetch the winning player and update text
var winner_id : int

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if winner_id:
		text.text = "Fighter " + str(winner_id) + " Wins!"

func _on_rematch_pressed() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false
	queue_free()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/o-test/menus/start_menu.tscn")
	get_tree().paused = false
	queue_free()
