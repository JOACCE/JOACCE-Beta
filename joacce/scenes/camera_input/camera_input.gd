extends Node2D

# Hard-coding this for now
var camera_name : String = "FaceTime HD Camera"
var camera: CameraFeed
@onready var display: Sprite2D = $Sprite2D

func _ready() -> void:
	# Allow CameraServer monitor feeds
	CameraServer.monitoring_feeds = true
	
	# Get currently connected camera feeds
	# Will need player to choose from these options
	for feed in CameraServer.feeds():
		var name = feed.get_name()
		
		if (camera == null and name == camera_name):
			camera = feed
			break
	
	print("Using camera: ", camera.get_name())
	camera.feed_is_active = true
	
	var cam_tex_y = display.material.get_shader_parameter("camera_y")
	var cam_tex_CbCr = display.material.get_shader_parameter("camera_CbCr")
	
	cam_tex_y.camera_feed_id = camera.get_id()
	cam_tex_CbCr.camera_feed_id = camera.get_id()
	
	display.material.set_shader_parameter("camera_y", cam_tex_y)
	display.material.set_shader_parameter("camera_CbCr", cam_tex_CbCr)
