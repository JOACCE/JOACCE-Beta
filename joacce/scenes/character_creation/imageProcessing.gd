extends Node

"""
Script for image processing

Uses a packed PNG byte array and applies a mask to
extract the player from the image.

"""

static var TARGET_WIDTH : int = 2048
static var TARGET_HEIGHT : int = 2048

##
## Extract the player from the raw image using a stencil mask
##
## Param raw The raw image from camera input
## Param mask The mask for the stencil
## Param boundary The Rect2 of the stencil
##
static func extractPlayer(raw: Image, mask: Image, boundary: Rect2) -> Image:
	# Verify raw image supports RGBA format
	if (raw.get_format() != Image.FORMAT_RGBA8):
		raw.convert(Image.FORMAT_RGBA8)
		
	# Remove margins
	raw = raw.get_region(boundary)
	
	var width : int = raw.get_width()
	var height : int = raw.get_height()
	
	# Resize mask to fit the raw image
	mask.resize(width, height)
	var transparent : Color = Color(0.0, 0.0, 0.0, 0.0)
	
	# For each (x,y) in raw image, only keep area in mask
	for x in range(width):
		for y in range(height):
			var maskC : Color = mask.get_pixel(x, y)
			
			if (maskC.a != 0.0):
				raw.set_pixel(x, y, transparent)
	
	raw.resize(TARGET_WIDTH, TARGET_HEIGHT)
	return raw
