// chromatic aberration
//---------------------------------

shader_type canvas_item;

uniform vec2 r_displacement = vec2(1.0, 0.0);
uniform vec2 g_displacement = vec2(0.0, 0.0);
uniform vec2 b_displacement = vec2(-1.0, 0.0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

void fragment()
{
	COLOR.r = texture(SCREEN_TEXTURE, UV - r_displacement).r;
	COLOR.g = texture(SCREEN_TEXTURE, UV - g_displacement).g;
	COLOR.b = texture(SCREEN_TEXTURE, UV - b_displacement).b;
}