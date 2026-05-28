extends Node2D

"""
Character Creation Scene

Fetches all stencils, showing them, and allowing for capture from the 
camera feed.

These captures are saved to individual files for use in arena
"""


# Image Processing Script
const imageProcessing = preload("res://scenes/character_creation/imageProcessing.gd")

# Camera
@onready var camera : Control = $UI/VBoxContainer/HBoxContainer/CameraContainer/Camera

# Stencil
@onready var stencil : TextureRect = $UI/VBoxContainer/HBoxContainer/CameraContainer/Stencil
@onready var stencil_label : Label = $UI/VBoxContainer/StencilLabel

# Buttons
@onready var button_container : HBoxContainer = $UI/VBoxContainer/CenterContainer/ButtonContainer
@onready var ready_button : Button = $UI/VBoxContainer/CenterContainer/ButtonContainer/ReadyButton
@onready var plus_button : Button = $UI/VBoxContainer/CenterContainer/ButtonContainer/PlusButton
@onready var minus_button : Button = $UI/VBoxContainer/CenterContainer/ButtonContainer/MinusButton

# Countdown
@onready var countdown = $UI/CountdownContainer/Countdown

# Capture Popup
@onready var capture_popup : CenterContainer = $UI/CenterPopup
@onready var sprite_preview : TextureRect = $UI/CenterPopup/CapturePopup/PreviewSprite

# Resource
var camera_res = preload("res://scenes/character_creation/CharacterCreationData.tres")

# Stencil queue
var stencils : Array = []
var curr_stencil : String = ""

func _ready() -> void:
	# Setup stencil queue
	stencils = Array(DirAccess.get_files_at(camera_res.STENCIL_DIR))
	stencils = stencils.filter(func(x): return !x.ends_with(".import"))
	
	# Allow CameraServer to monitor feeds
	CameraServer.monitoring_feeds = true
	
	# Get currently connected camera feeds
	var cam = null
	
	# Will need player to choose from these options	
	for feed in CameraServer.feeds():
		var feed_name : String = feed.get_name()
		print(feed_name)
		# Right now just picking a set camera
		if (cam == null and feed_name == camera_res.camera_name):
			cam = feed
	
	camera.turn_on_camera_feed(cam)

	_swap_stencil(stencils.pop_front())
	
func _swap_stencil(path : String) -> void:
	curr_stencil = path
	stencil.texture = load(camera_res.STENCIL_DIR + path)
	stencil_label.text = path.rstrip(".png")


##
## Hides desired UI elements
##  
## Primary use: Capturing Screenshots
##
func _hide_ui() -> void:
	for child in button_container.get_children():
		if child is Button:
			child.hide()


##
## Shows desired UI elements 
##
## Primary use: Restoring UI elements after screenshot
##
func _show_ui() -> void:
	for child in button_container.get_children():
		if child is Button:
			child.show()


##
## Capture and save screenshot and return image
##
func _capture_screen() -> Image:
	# Hide desired UI elements (Buttons for now)
	_hide_ui()
	
	await RenderingServer.frame_post_draw
	
	# Capture screen
	var img : Image = get_viewport().get_texture().get_image()
	
	return img


##
## Capture a screenshot of the player and extracts
## the character from the screenshot
##
func _capture_player() -> void:
	# Capture raw image from webcam
	var imgRaw : Image = await _capture_screen()
	
	# Load mask from a file
	var imgMask : Image = Image.load_from_file(camera_res.STENCIL_DIR + curr_stencil)
	
	# Get stencil boundary relative to scene (used to resize)
	var boundary : Rect2 = stencil.get_global_rect()
	
	
	imageProcessing.extractPlayer(imgRaw, imgMask, boundary).save_png(camera_res.CHARACTER_DIR + curr_stencil)


##
## Capture a screenshot on button press
##
func _on_ready_pressed() -> void:
	countdown.start()
	
	await countdown.timer_expired
	
	await _capture_player()
	
	_show_sprite_preview()


##
## Zoom out the camera on button press
##
func _on_minus_pressed() -> void:
	_change_zoom(-0.1)


##
## Zoom in the camera on button press
##
func _on_plus_pressed() -> void:
	_change_zoom(0.1)


##
## Change zoom by delta amount
## 
## Limited to values from 0.2 to 3.0
##
func _change_zoom(delta: float) -> void:
	var zoom = camera_res.zoom
	camera_res.zoom = clamp(zoom + delta, 0.2, 3.0)
	
	camera.display.material.set_shader_parameter("zoom", camera_res.zoom)


##
## Shows the sprite preview to allow for retakes
##
func _show_sprite_preview() -> void:
	await get_tree().create_timer(1.0).timeout
	
	# Sorry, this is an ugly line
	sprite_preview.texture = ImageTexture.create_from_image(Image.load_from_file(camera_res.CHARACTER_DIR + curr_stencil))
	capture_popup.show()


##
## While there are more stencils to take, load the next one
##
func _on_confirm_button_pressed() -> void:
	if (len(stencils) > 0):
		_swap_stencil(stencils.pop_front())
		
		capture_popup.hide()
		_show_ui()


##
## If retake is pressed, don't load next stencil
##
func _on_retake_button_pressed() -> void:
	capture_popup.hide()
