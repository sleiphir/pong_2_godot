shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

uniform sampler2D displace: source_color;
uniform float dispAmt: hint_range(0,0.1);
uniform vec2 abberationAmtXR = vec2(0,0);
uniform vec2 abberationAmtXG =  vec2(0,0);
uniform vec2 abberationAmtXB =  vec2(0,0);
uniform float dispSize: hint_range(0.1, 2.0);
uniform float maxAlpha : hint_range(0.1,1.0);

void fragment()
{
	vec4 disp = texture(displace, SCREEN_UV * dispSize);
	vec2 newUV = SCREEN_UV + disp.xy * dispAmt;
	COLOR.r = texture(SCREEN_TEXTURE, newUV - abberationAmtXR).r; 
	COLOR.g = texture(SCREEN_TEXTURE, newUV + abberationAmtXG).g; 
	COLOR.b = texture(SCREEN_TEXTURE, newUV + abberationAmtXB).b;
	COLOR.a = texture(SCREEN_TEXTURE, newUV).a * maxAlpha;
}