extends TextureRect

const width : int = 640
const height : int = 480
var image : Image
var tex : ImageTexture


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	image = Image.create_empty(width, height, false, Image.FORMAT_RGB8)
	tex = ImageTexture.create_from_image(image)
	self.texture = tex


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var data_url = JavaScriptBridge.eval("getOpenCVFrame();", true)

	if data_url == null:
		return

	var base64 := String(data_url).split(",")[1]
	var png_bytes := Marshalls.base64_to_raw(base64)

	var new_image := Image.new()
	var err := new_image.load_png_from_buffer(png_bytes)

	if err != OK:
		print("PNG load failed: ", err)
		return

	new_image.convert(Image.FORMAT_RGB8)

	tex.update(new_image)
