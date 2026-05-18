extends Node2D

"""

"""


# Importing:
const imageProcessing = preload("res://scenes/character_creation/imageProcessing.gd")

# Camera
var camera_name : String = "FaceTime HD Camera" # Hard-coding this for now
var camera : CameraFeed
@onready var display : TextureRect = $UI/CameraContainer/Camera

# Buttons
@onready var button_container : HBoxContainer = $UI/ButtonContainer
@onready var ready_button : Button = $UI/ButtonContainer/ReadyButton
@onready var plus_button : Button = $UI/ButtonContainer/PlusButton
@onready var minus_button : Button = $UI/ButtonContainer/MinusButton

# Directories
const CHARACTER_DIR : String = "res://assets/characters/"
const STENCIL_DIR : String = "res://assets/stencils/"

func _ready() -> void:
	# Allow CameraServer to monitor feeds
	CameraServer.monitoring_feeds = true
	
	var cam: CameraFeed = null
	
	# Get currently connected camera feeds
	# Will need player to choose from these options	
	for feed in CameraServer.feeds():
		var feed_name : String = feed.get_name()
		print(feed_name)
		# Right now just picking a set camera
		if (cam == null and feed_name == camera_name):
			cam = feed
	
	_turn_on_camera_feed(cam)


##
## Turn on/switch active camera input
##
## @param cam The camera to turn on/switch to
##
func _turn_on_camera_feed(cam: CameraFeed):
	# Turn off existing camera if exists
	if (camera):
		camera.feed_is_active = false

	# If no camera, do nothing
	if (!cam):
		return

	# Set and turn on camera feed
	camera = cam
	camera.feed_is_active = true
	
	print("Using Camera: ", camera.get_name())
	
	var cam_tex_y = display.material.get_shader_parameter("camera_y")
	var cam_tex_CbCr = display.material.get_shader_parameter("camera_CbCr")
	
	cam_tex_y.camera_feed_id = camera.get_id()
	cam_tex_CbCr.camera_feed_id = camera.get_id()
	
	display.material.set_shader_parameter("camera_y", cam_tex_y)
	display.material.set_shader_parameter("camera_CbCr", cam_tex_CbCr)


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
