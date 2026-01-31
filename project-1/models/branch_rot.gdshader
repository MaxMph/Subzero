shader_type spatial;
render_mode cull_disabled;
//uniform sampler2D albedoTexture : source_color;
uniform sampler2D screentexture : hint_screen_texture;

void fragment() {
	vec2 uv = UV;
	
	uv = vec2(1.0 - uv.y, uv.x);

	//ALBEDO = texture(TEXTURE, uv).rgb;
	//ALBEDO = texture(albedoTexture, uv).rgb;
	ALBEDO = texture(screentexture, uv).rgb;
}
