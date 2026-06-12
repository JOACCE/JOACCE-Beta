extends Control

# Popup
@onready var popup : CenterContainer = $CenterContainer

# Menu Buttons
@onready var fight_button : Button = $VBoxContainer/Fight
@onready var create_button : Button = $VBoxContainer/Create
@onready var quit_button : Button = $VBoxContainer/Quit

func _on_fight_pressed() -> void:
	AudioManager.play_music("fight")
	get_tree().change_scene_to_file("res://scenes/o-test/level/arena.tscn")

func _on_create_pressed() -> void:
	if (OS.get_name() == "Web"):
		get_tree().change_scene_to_file("res://scenes/character_creation/camera_capture_web/camera_input.tscn")
	elif (OS.get_name() == "Windows"):
		get_tree().change_scene_to_file("res://scenes/character_creation/camera_capture_windows/camera_input.tscn")
	elif (OS.get_name() in ["macOS", "Linux", "Android", "iOS"]):
		# Camera selection works with Goot CameraServer
		get_tree().change_scene_to_file("res://scenes/character_creation/camera_select/camera_select.tscn")
	else:
		print("Character creation not supported on ", OS.get_name())
		_disable_menu_buttons()
		popup.show()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_dismiss_button_pressed() -> void:
	_enable_menu_buttons()
	popup.hide()


func _enable_menu_buttons() -> void:
	fight_button.disabled = false
	create_button.disabled = false
	quit_button.disabled = false


func _disable_menu_buttons() -> void:
	fight_button.disabled = true
	create_button.disabled = true
	quit_button.disabled = true
