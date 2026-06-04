extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _process_frame() -> ImageTexture:
	var window = JavaScriptBridge.get_interface("window")
	var data_url = window.captureWebcamFrame()
	
	var base64_data = data_url.get_slice(",", 1)
	
	var raw_buffer = Marshalls.base64_to_raw(base64_data)
	
	var img = Image.new()
	img.load_jpg_from_buffer(raw_buffer)
	
	var tex = ImageTexture.create_from_image(img)
	return tex
	
