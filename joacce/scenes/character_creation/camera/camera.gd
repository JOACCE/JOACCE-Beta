extends Control

var camera : CameraFeed
@onready var display : TextureRect = $Camera
@onready var mat : Material = $Camera.material


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mat.set_shader_parameter("visibility", 0.0)


##
## Turn on/switch active camera input
##
## @param cam The camera to turn on/switch to
##
func turn_on_camera_feed(cam: CameraFeed):
	# Turn off existing camera if exists
	if (camera):
		camera.feed_is_active = false
		mat.set_shader_parameter("visibility", 0.0)
		

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
	
	await RenderingServer.frame_post_draw
	
	mat.set_shader_parameter("visibility", 1.0)

func update_crop():
	var full_size = Vector2(640, 480)
	
	var zoom = display.material.get_shader_parameter("zoom")
	var visible_size = full_size * zoom
	var offset = (full_size - visible_size) / 2.0
	
	display.size = visible_size
	display.position = offset
