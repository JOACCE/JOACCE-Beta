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
@onready var camera : Control = $UI/CameraCaptureContainer/HBoxContainer/CameraContainer/OpencvCamera

# Stencil
@onready var stencil : TextureRect = $UI/CameraCaptureContainer/HBoxContainer/CameraContainer/Stencil
@onready var stencil_label : Label = $UI/CameraCaptureContainer/StencilLabel

# Buttons
@onready var button_container : HBoxContainer = $UI/CameraCaptureContainer/CenterContainer/ButtonContainer
@onready var ready_button : Button = $UI/CameraCaptureContainer/CenterContainer/ButtonContainer/ReadyButton
@onready var plus_button : Button = $UI/CameraCaptureContainer/CenterContainer/ButtonContainer/PlusButton
@onready var minus_button : Button = $UI/CameraCaptureContainer/CenterContainer/ButtonContainer/MinusButton

# Countdown
@onready var countdown = $UI/CountdownContainer/Countdown

# Capture Popup
@onready var capture_popup : CenterContainer = $UI/CenterPopup
@onready var sprite_preview : TextureRect = $UI/CenterPopup/CapturePopup/PreviewSprite

# Capture Vbox
@onready var capture_vbox : VBoxContainer = $UI/CameraCaptureContainer

# Save Character Popup
@onready var name_popup : CenterContainer = $UI/SaveCharacterPopup
@onready var name_input : LineEdit = $UI/SaveCharacterPopup/VBoxContainer/LineEdit

# Resource
var camera_res : CameraData = preload("res://scenes/character_creation/CameraData.tres")

# Stencil queue
var stencils : Array = []
var curr_stencil : String = ""

func _ready() -> void:
	# Setup stencil queue
	stencils = Array(DirAccess.get_files_at(camera_res.STENCIL_DIR))
	stencils = stencils.filter(func(x): return !x.ends_with(".import"))

	if (len(stencils) > 0):
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


func _hide_camera() -> void:
	capture_vbox.hide()

func _show_camera() -> void:
	capture_vbox.show()


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
	
	imageProcessing.extractPlayer(imgRaw, imgMask, boundary).save_png(camera_res.CHARACTER_DIR + "_tmp/" + curr_stencil)


##
## Capture a screenshot on button press
##
func _on_ready_pressed() -> void:
	countdown.start()
	
	await countdown.timer_expired
	
	await _capture_player()
	
	_hide_camera()
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
	ResourceSaver.save(camera_res, "res://scenes/character_creation/CharacterCreationData.tres")


##
## Shows the sprite preview to allow for retakes
##
func _show_sprite_preview() -> void:
	await get_tree().create_timer(1.0).timeout
	
	# Sorry, this is an ugly line
	sprite_preview.texture = ImageTexture.create_from_image(Image.load_from_file(camera_res.CHARACTER_DIR + "_tmp/"+ curr_stencil))
	capture_popup.show()


##
## While there are more stencils to take, load the next one
##
func _on_confirm_button_pressed() -> void:
	if (len(stencils) > 0):
		_swap_stencil(stencils.pop_front())
		
		capture_popup.hide()
		_show_camera()
		_show_ui()
	else:
		# No more pictures to take, prompt name
		capture_popup.hide()
		name_popup.show()


##
## If retake is pressed, don't load next stencil
##
func _on_retake_button_pressed() -> void:
	capture_popup.hide()
	_show_camera()
	_show_ui()


func _on_name_confirm_button_pressed() -> void:
	var character_name : String = name_input.text
	
	if (!_is_name_taken(character_name)):
		var dir_name = _create_character_dir(character_name)
		_move_tmp_files(dir_name)
		
		get_tree().change_scene_to_file("res://scenes/o-test/menus/start_menu.tscn")
	else:
		print("Character name is already taken.")


func _is_name_taken(character_name : String) -> bool:
	var dir_name : String = camera_res.CHARACTER_DIR + "/" + character_name.replace(" ", "_")
	
	return DirAccess.dir_exists_absolute(dir_name);


func _create_character_dir(character_name : String) -> String:
	var dir_name : String = camera_res.CHARACTER_DIR + "/" + character_name.replace(" ", "_")
	DirAccess.make_dir_absolute(dir_name)
	
	return dir_name


func _move_tmp_files(dest: String) -> void:
	var tmp_files = Array(DirAccess.get_files_at(camera_res.CHARACTER_DIR + "_tmp/"))
	
	# Filter to only tmp files and remove .imports
	tmp_files = tmp_files.filter(func(x : String) : return !x.ends_with(".import"))
	
	for f in tmp_files:
		var old_path = camera_res.CHARACTER_DIR + "_tmp/" + f
		var new_path = dest + "/" + f
		
		DirAccess.rename_absolute(old_path, new_path)
