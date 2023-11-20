shader_type canvas_item;

uniform sampler2D st : hint_screen_texture, filter_linear_mipmap; // Escrín tecstur
uniform sampler2D sprite : filter_linear; // 
uniform vec2 spriteRes; // Resolucion del sprite
uniform float spriteSize; // Escala del sprite
uniform vec2 posR; // Posicion del raton
uniform vec2 dim; // Dimensiones del area de la caja
uniform float oscuridad; // Pos eso
uniform float desenfoque; // Pos eso tambien


float areafoto(vec2 uv){
	vec2 pos = uv - posR + dim * spriteSize / 2.;
	pos /= dim * spriteSize;
	float sdf = abs(floor(pos.x)) + abs(floor(pos.y));
	return clamp(sdf, 0., 1.);
}

void fragment() {

	float mask = areafoto(SCREEN_UV / SCREEN_PIXEL_SIZE);
	vec4 col;
	if(mask == 0.){
		col = texture(st, SCREEN_UV, desenfoque);
	}
	else{
		col = texture(st, SCREEN_UV) * vec4(vec3(oscuridad), 1.);
	}

	vec2 suv = SCREEN_UV / SCREEN_PIXEL_SIZE - posR + spriteRes * spriteSize / 2.;
	suv /= spriteRes;
	suv /= spriteSize;

	
	vec4 sprt = texture(sprite, suv);
	col.rgb = mix(col.rgb, sprt.rgb, sprt.a);
	
	COLOR = col;
}
