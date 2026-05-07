extends Node2D

# Hard-coding this for now
var camera_name : String = "FaceTime HD Camera"
var camera : CameraFeed
@onready var display : Sprite2D = $Sprite2D

@onready var button : Button = $Button

func _ready() -> void:
	# Allow CameraServer to monitor feeds
	CameraServer.monitoring_feeds = true
	
	var cam: CameraFeed = null
	
	# Get currently connected camera feeds
	# Will need player to choose from these options	
	for feed in CameraServer.feeds():
		var name : String = feed.get_name()
		
		# Right now just picking a set camera
		if (cam == null and name == camera_name):
			cam = feed
	
	_turn_on_camera_feed(cam)
	
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
func _hide_ui() -> void:
	button.visible = false
	
##
## Shows desired UI elements 
##
func _show_ui() -> void:
	button.visible = true

##
## Capture and save screenshot to given path
##
func _capture_screen(path : String):
	# Hide desired UI elements (Button for now)
	_hide_ui()
	
	await RenderingServer.frame_post_draw
	
	# Capture screen
	get_viewport().get_texture().get_image().save_png(path)
	
	# Show UI elements again
	_show_ui()

func _on_button_pressed() -> void:
	_capture_screen("test.png")
