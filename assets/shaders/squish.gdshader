shader_type canvas_item;
render_mode unshaded;

uniform bool uv_mode = false;
uniform float x_factor = 2.0;
uniform float bulge : hint_range(-1.0, 1.0);

void vertex() {
	// Expand geometry horizontally
	VERTEX.x *= x_factor;
}

float bulge_function(float y) {
	return sqrt(max(0.0, 1.0 - y * y));
}

void fragment() {
	// Remap UV from [0,1] → [-1,1]
	vec2 uv = UV * 2.0 - 1.0;

	// Counteract vertex stretch
	uv.x *= x_factor;

	// Bulge distortion
	float displacement = 1.0 + bulge * bulge_function(uv.y);
	uv.x /= displacement;

	// Remap back to [0,1]
	uv = (uv + 1.0) * 0.5;

	bool inside_uv = (
		uv.x >= 0.0 && uv.x <= 1.0 &&
		uv.y >= 0.0 && uv.y <= 1.0
	);

	if (uv_mode) {
		if (inside_uv) {
			COLOR = vec4(uv, 0.0, 1.0);
		} else {
			COLOR = vec4(0.0);
		}
	} else {
		if (inside_uv) {
			COLOR = texture(TEXTURE, uv);
		} else {
			COLOR = vec4(0.0);
		}
	}
}
