extends Node2D

@onready var camera_options : OptionButton = $UI/VBoxContainer/CenterContainer/ButtonContainer/CameraDropdown
@onready var camera : Control = $UI/VBoxContainer/HBoxContainer/CameraContainer/Camera
var feed_options : Array[CameraFeed]

# Resource
var camera_res : CameraData = preload("res://scenes/character_creation/CameraData.tres")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CameraServer.monitoring_feeds = true
	
	feed_options = CameraServer.feeds()
	
	for cam in feed_options:
		camera_options.add_item(cam.get_name())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_camera_dropdown_item_selected(index: int) -> void:
	if (index > 0):
		camera.turn_on_camera_feed(feed_options[index-1])
		camera_res.camera_name = feed_options[index-1].get_name()


##
## On back button, switch to previous scene (Menu?)
##
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/o-test/menus/start_menu.tscn")

##
## On next button, move to character creation scene
##
func _on_next_button_pressed() -> void:
	# Save resource
	ResourceSaver.save(camera_res, "res://scenes/character_creation/CharacterCreationData.tres")
	
	# Change scene
	get_tree().change_scene_to_file("res://scenes/character_creation/camera_capture_default/camera_input.tscn")
