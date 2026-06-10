shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform sampler2D screen_texture : hint_screen_texture;
uniform float fuerza = 0.01;

void fragment() {
    vec2 uv = SCREEN_UV;

    uv.y += sin(uv.x * 20.0 + TIME * 2.0) * fuerza;
    uv.x += cos(uv.y * 15.0 + TIME * 1.5) * fuerza;

    COLOR = texture(screen_texture, uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
