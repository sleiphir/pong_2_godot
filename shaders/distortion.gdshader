shader_type canvas_item;

uniform vec2 center = vec2(.5, .5);
uniform float force = -.05;
uniform float size = .25;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

void fragment()
{
	float actual_force = force - (sin(TIME) / 2.0 + .5) / 600.0;
	float mask = 1.0 - smoothstep(.0, size, length(UV - center));
	vec2 disp = normalize(UV - center) * actual_force * mask; 
	COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV - disp, 0.0);
	//COLOR.rgb = vec3(mask);
	//COLOR = vec4(UV - disp, 0.0, 1.0);
}