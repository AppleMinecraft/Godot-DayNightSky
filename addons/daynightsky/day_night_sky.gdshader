shader_type sky;

group_uniforms Colors;
uniform vec3 day_color: source_color;
uniform vec3 sunset_color: source_color;
uniform vec3 night_color: source_color;
uniform vec3 day_horizon_fog_color: source_color;
uniform vec3 sunset_horizon_fog_color: source_color;
uniform vec3 night_horizon_fog_color: source_color;

group_uniforms Sun;
uniform vec3 sun_color: source_color = vec3(1.0, 0.8, 0.0);
uniform vec3 sun_blur_color: source_color;
uniform float sun_disc_size: hint_range(0.9, 1.0, 0.0001) = 0.9994;
uniform float sun_disc_blur: hint_range(0.0, 0.1, 0.000001) = 0.000245;

group_uniforms Moon;
uniform vec3 moon_color: source_color;
uniform float moon_disc_size: hint_range(0.9, 1.0, 0.0001) = 0.9994;
uniform float moon_disc_blur: hint_range(0.0, 0.1, 0.000001) = 0.000065;

group_uniforms Stars;
uniform sampler2D stars_noise_map;
uniform float stars_speed;

void sky() {
	// Top
	float day_amount = clamp(LIGHT0_DIRECTION.y, 0.0, 1.0);
	float sunset_amount = clamp(1.0 - abs(LIGHT0_DIRECTION.y*2.0), 0.0, 1.0);
	float night_amount = clamp(LIGHT1_DIRECTION.y, 0.0, 1.0);
	
	// Horizon
	float clamped_eye_dir = clamp(EYEDIR.y, 0.0, 1.0);
	vec3 day_gradient = mix(day_horizon_fog_color, day_color, clamped_eye_dir) * day_amount;
	vec3 sunset_gradient = mix(sunset_horizon_fog_color, sunset_color, clamped_eye_dir) * sunset_amount;
	vec3 night_gradient = mix(night_horizon_fog_color, night_color, clamped_eye_dir) * night_amount;
	
	// Sun
	float sunEffect = max(dot(LIGHT0_DIRECTION, EYEDIR), 0.0);
	sunEffect = smoothstep(sun_disc_size - sun_disc_blur, sun_disc_size + sun_disc_blur, sunEffect);
	vec3 sun = sunEffect * (sun_color + sunEffect);
	// Moon
	float moonEffect = max(dot(LIGHT1_DIRECTION, EYEDIR), 0.0);
	moonEffect = smoothstep(moon_disc_size - moon_disc_blur, moon_disc_size + moon_disc_blur, moonEffect);
	vec3 moon = moonEffect * moon_color;
	
	vec2 sky_uv = EYEDIR.xz / EYEDIR.y;
	vec3 stars = texture(stars_noise_map, sky_uv + (stars_speed * TIME)).rgb;
	stars *= night_amount;
	
	COLOR = day_gradient + sunset_gradient + night_gradient + sun + moon + stars;
}
