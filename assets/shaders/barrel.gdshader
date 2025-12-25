shader_type canvas_item;

uniform float distortion_strength : hint_range(-2.0, 2.0) = 0.5;
uniform float curvature : hint_range(1.0, 4.0) = 2.0; // Higher = more curved

void fragment() {
	vec2 uv = UV - vec2(0.5);
	float dist = length(uv);
	
	// Use power function for more natural curvature
	float amount = pow(dist, curvature);
	
	// Apply distortion
	float scale = 1.0 + amount * distortion_strength;
	vec2 distorted_uv = uv * scale + vec2(0.5);

	if (distorted_uv.x < 0.0 || distorted_uv.x > 1.0 || distorted_uv.y < 0.0 || distorted_uv.y > 1.0){
		// Set to transparent
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
	else{
		COLOR = texture(TEXTURE, distorted_uv);
	}
}