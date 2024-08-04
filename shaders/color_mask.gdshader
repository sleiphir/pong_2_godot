shader_type canvas_item;

uniform vec3 mask_color:source_color;
uniform vec3 new_color:source_color;
uniform float threshold:hint_range(0.01, 0.5) = 0.05;

void fragment() {
	vec4 p = texture(TEXTURE, UV);
	vec3 mask = p.rgb - mask_color;
	float diff = (mask.r + mask.g + mask.b) / 3.0;
	if (diff < .0) {
		diff *= -1.0;
	}
	if (diff < threshold) {
		p.rgb = new_color * (mask + vec3(1.0));
	}
	COLOR = p;
}