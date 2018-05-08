#version 450

in vec3 pos;
in vec2 texcoord;

uniform float time;

out vec2 tex;

void main() {
	tex = texcoord;

	float sinus = sin(time);
	float cosinus = cos(time);
	float x = cosinus * pos.x - sinus * pos.z;
	float y = pos.y;
	float z = cosinus * pos.z + sinus * pos.x;
	x /= (z + 5) / 5;
	y /= (z + 5) / 5;
	
	gl_Position = vec4(x / 5.0, y / 5.0, z / 5.0, 1.0);
}
