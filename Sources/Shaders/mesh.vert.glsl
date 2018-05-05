#version 450

in vec3 pos;
in vec2 texcoord;

void main() {
	float x = pos.x;
	float y = pos.y;
	float z = pos.z;

	gl_Position = vec4(x / 5.0, y / 5.0, z / 5.0, 1.0);
}
