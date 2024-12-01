// NOTE: Shader automatically converted from Godot Engine 4.3.stable's CanvasItemMaterial.

shader_type canvas_item;
render_mode blend_mix;
uniform sampler2D noise: repeat_disable;
uniform float brokenness: hint_range(0.0, 1);


void fragment() {
	vec4 c = texture(TEXTURE, UV + vec2(0,-0.5*texture(noise,UV).y)*brokenness, 0.0);
	c.a *= 1.0-(clamp(texture(noise,UV).x * brokenness * 4.0 + 0.5,0.5,1.5)-0.5);
	COLOR = c;
}