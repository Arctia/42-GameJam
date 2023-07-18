shader_type canvas_item;

uniform sampler2D noise;
uniform bool damaged = false;
uniform float speed = 12.;

void fragment() {
	float angle = TIME;
	vec2 dist = vec2(.5) - UV;
	float s = sin(angle);
	float c = cos(angle);
	mat2 m = mat2(vec2(c, -s), vec2(s, c));
	dist *= m;
	vec4 coord = texture(noise, dist);
	coord.x -= .5;
	coord.y -= .5;
	vec4 lens_color = texture(TEXTURE, UV + coord.xy);
	vec4 damage_mask = texture(TEXTURE, UV);
	damage_mask.a *= 0.5;
	damage_mask.r += 0.5; 
	if (damaged)
		lens_color = mix(lens_color, damage_mask, sin(angle * speed));
    COLOR = lens_color;
}