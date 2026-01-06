shader_type spatial;

uniform float metal : hint_range(0.0, 1.0, 0.0) = 0.0;
uniform float roughness : hint_range(0.0, 1.0, 0.0) = 0.0;

uniform float gridSize = 60;
uniform float gridThick = 1;

uniform vec4 tint : source_color = vec4(1.0);
void fragment() 
{
	float verticalLines = round(clamp(sin((UV.y - 0.5) * gridSize) + gridThick, 0.0, 1.0));
	float horizontalLines = round(clamp(sin((UV.x - 0.5) * gridSize) + gridThick, 0.0, 1.0));
	ALBEDO = vec3(min(verticalLines, horizontalLines)) * tint.rgb;
	METALLIC = metal;
	ROUGHNESS = roughness;
}
