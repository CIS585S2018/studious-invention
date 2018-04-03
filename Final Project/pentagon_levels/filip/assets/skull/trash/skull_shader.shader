shader_type spatial;

uniform float normalMapDepth = 1.0; 
uniform sampler2D my_albedo : hint_albedo; 
uniform sampler2D normalMapTexture  : hint_normal;
varying flat vec3 some_color;

void vertex() {
    VERTEX.y += sin(TIME*2.5)/8.0; // offset vertex x by sine function on time elapsed
}

void fragment(){
	NORMALMAP = texture (normalMapTexture, UV).xyz * vec3(2.0,2.0,1.0) - vec3(1.0,1.0,0.0); 
	//NORMALMAP_DEPTH = normalMapDepth; //float
	ALBEDO = texture (my_albedo,UV).rgb; // use red for material albedo	
}
