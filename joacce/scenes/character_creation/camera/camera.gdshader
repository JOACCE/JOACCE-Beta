
shader_type canvas_item;

uniform sampler2D camera_y;
uniform sampler2D camera_CbCr;

uniform float visibility : hint_range(0.0, 1.0) = 0.0;
uniform float zoom = 0.5;

void fragment() {
	vec2 flipped_uv = vec2(1.0 - UV.x, UV.y);
	
	vec2 center = vec2(0.5, 0.5);
	vec2 zoomed_uv = vec2(center.x + (flipped_uv.x - center.x) / zoom, flipped_uv.y);
	
	if (zoomed_uv.x < 0.0 || zoomed_uv.x > 1.0 ||
		zoomed_uv.y < 0.0 || zoomed_uv.y > 1.0) 
	{
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	}
	else
	{
		vec3 color;
		color.r = texture(camera_y, zoomed_uv).r;
		color.gb = texture(camera_CbCr, zoomed_uv).rg - vec2(0.5, 0.5);
		
		// YCbCr -> SRGB conversion
		// Using BT.709 which is the standard for HDTV
		color.rgb = mat3(
							vec3(1.00000, 1.00000, 1.00000),
							vec3(0.00000, -0.18732, 1.85560),
							vec3(1.57481, -0.46813, 0.00000)) *
					color.rgb;
		
		COLOR = vec4(color * visibility, 1.0);
	}
}