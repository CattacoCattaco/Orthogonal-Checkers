shader_type canvas_item;

uniform sampler2D palette: filter_nearest, repeat_disable;

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);

	if(input_color.a > 0.8)
	{
		COLOR = texture(palette, vec2(input_color.r, input_color.g));
	}
	else
	{
		COLOR = vec4(0, 0, 0, 0);
	}
}
