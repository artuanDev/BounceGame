shader_type spatial;

uniform float metal : hint_range(0.0, 1.0, 0.0) = 0.0;
uniform float roughness : hint_range(0.0, 1.0, 0.0) = 0.0;

uniform float gridSize = 60;
uniform float gridThick = 1;

uniform vec4 tint : source_color = vec4(1.0);

varying vec3 world_normal;
varying vec3 local_position; // holds WORLD vertex position

// original grid logic
float grid_lines(vec2 uv) {
	float v = round(clamp(sin((uv.y - 0.5) * gridSize) + gridThick, 0.0, 1.0));
	float h = round(clamp(sin((uv.x - 0.5) * gridSize) + gridThick, 0.0, 1.0));
	return v * h;
}

void vertex() {
	// already handled in your base
	local_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	world_normal = (INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
}

void fragment() {
	// normalize world normal for blending
	vec3 n = normalize(world_normal);

	// triplanar blend weights
	vec3 w = abs(n);
	w /= (w.x + w.y + w.z);

	// generate planar UVs from WORLD position
	vec2 uv_x = local_position.yz; // X-facing plane
	vec2 uv_y = local_position.xz; // Y-facing plane
	vec2 uv_z = local_position.xy; // Z-facing plane

	// sample grid on each plane
	float gx = grid_lines(uv_x);
	float gy = grid_lines(uv_y);
	float gz = grid_lines(uv_z);

	// blend by normal
	float grid = gx * w.x +
	             gy * w.y +
	             gz * w.z;

	ALBEDO = grid * tint.rgb;
	METALLIC = metal;
	ROUGHNESS = roughness;
}
