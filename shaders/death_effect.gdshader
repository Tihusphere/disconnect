shader_type canvas_item;
render_mode blend_add;

uniform sampler2D noise;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float progress: hint_range(0.0, 1) = 0.0;

void fragment(){
	//I'M A WIZARD NOW!!!
	vec4 c = texture(screen_texture, (vec2(sin(TIME),cos(TIME))*0.1*progress) + SCREEN_UV + ((0.5-texture(noise,UV).xy) * progress/2.0));
	c.a *= 1.0-5.0*(distance(vec2(0.5,.5),UV)*progress);
	c.a *= 1.0-progress;
	
	COLOR *= c;
}
