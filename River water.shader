shader_type canvas_item;

//uniform vec3 color = vec3(0.2, 0.2, 0.7);
uniform vec4 color1 : hint_color;
uniform vec4 color2 : hint_color;

uniform int OCTAVES = 4;


float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(56.78357373,78.66347858)) * 1000.0 ) * 1000.0);
}

float noise(vec2 coord){
	vec2 floored = floor(coord);
	vec2 fracted = fract(coord);
	
	float a = rand(floored);
	float b = rand(floored + vec2(1.0,0.0));
	float c = rand(floored + vec2(0.0,1.0));
	float d = rand(floored + vec2(1.0,1.0));
	
	vec2 cubic = (fracted *fracted*(3.0 - 2.0* fracted) );
	return  (mix(a,b,cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y);

}


float fbm(vec2 coord){
	float value = 0.0;
	float scale = 0.3;
	
	for(int i = 0; i<OCTAVES; i++){
		value += noise(coord)*scale;
		coord *= 2.0;
		scale *=0.9;
		
	}
	return value;
}

void fragment(){
	vec2 coord = UV * 8.0;
	vec2 motion = vec2(fbm(coord + sin(TIME * 0.2))  , fbm(coord - cos(TIME * 0.2)));
	vec2 motion2 = vec2(fbm(coord) - cos(TIME * 0.2) , fbm(coord) + sin(TIME * 0.2) );
	vec2 motion3 = vec2(fbm(coord), fbm(coord) - 0.33 * TIME );
	float final = fbm(motion + motion2 + motion3 + 2.0*(coord) );
	COLOR.a = final;
	
	if(COLOR.a > 0.3){
		COLOR = color2;
		
	}
	else if (COLOR.a > 0.25){COLOR = vec4(1.0,1.0,1.0,1.0);}
	else{COLOR = color2;}
	
	
	
	
	
}