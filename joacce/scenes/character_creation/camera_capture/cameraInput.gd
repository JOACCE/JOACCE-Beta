extends Node2D

"""

"""


# Importing:
const imageProcessing = preload("res://scenes/character_creation/imageProcessing.gd")

# Camera
var camera_name : String
@onready var camera : Control = $UI/VBoxContainer/HBoxContainer/CameraContainer/Camera

# Buttons
@onready var button_container : HBoxContainer = $UI/VBoxContainer/CenterContainer/ButtonContainer
@onready var ready_button : Button = $UI/VBoxContainer/CenterContainer/ButtonContainer/ReadyButton
@onready var plus_button : Button = $UI/VBoxContainer/CenterContainer/ButtonContainer/PlusButton
@onready var minus_button : Button = $UI/VBoxContainer/CenterContainer/ButtonContainer/MinusButton

# Directories
var CHARACTER_DIR : String
var STENCIL_DIR : String

# Resource
var camera_res = preload("res://scenes/character_creation/CharacterCreationData.tres")

func _ready() -> void:
	# Setup resources
	camera_name = camera_res.camera_name
	CHARACTER_DIR = camera_res.CHARACTER_DIR
	STENCIL_DIR = camera_res.STENCIL_DIR
	
	# Allow CameraServer to monitor feeds
	CameraServer.monitoring_feeds = true
	
	# Get currently connected camera feeds
	var cam = null
	
	# Will need player to choose from these options	
	for feed in CameraServer.feeds():
		var feed_name : String = feed.get_name()
		print(feed_name)
		# Right now just picking a set camera
		if (cam == null and feed_name == camera_name):
			cam = feed
	
	camera.turn_on_camera_feed(cam)


##
## Hides desired UI elements
##  
## Primary use: Capturing Screenshots
##
func _hide_ui() -> void:
	button_container.visible = false


##
## Shows desired UI elements 
##
func _show_ui() -> void:
	button_container.visible = true


##
## Capture and save screenshot and return image
##
func _capture_screen() -> Image:
	# Hide desired UI elements (Buttons for now)
	_hide_ui()
	
	await RenderingServer.frame_post_draw
	
	# Capture screen
	var img : Image = get_viewport().get_texture().get_image()
	
	# Show UI elements again
	_show_ui()
	
	return img


##
## Capture a screenshot of the player and extracts
## the character from the screenshot
##
func _capture_player() -> void:
	# Capture raw image from webcam
	var imgRaw : Image = await _capture_screen()
	
	# Load mask from a file (temporary)
	var imgMask : Image = Image.load_from_file("res://assets/stencils/tmp_mask.png")
	
	# Mask MUST be resized to mat˙
	imgMask.resize(imgRaw.get_width(), imgRaw.get_height())
	
	imageProcessing.extractPlayer(imgRaw, imgMask).save_png(CHARACTER_DIR + "test.png")


##
## Capture a screenshot on button press
##
func _on_ready_pressed() -> void:
	_capture_player()


##
## Zoom out the camera on button press
##
func _on_minus_pressed() -> void:
	pass # Replace with function body.


##
## Zoom in the camera on button press
##
func _on_plus_pressed() -> void:
	pass # Replace with function body.
