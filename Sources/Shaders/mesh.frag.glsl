#version 450

in vec3 norm;
in vec2 tex;

uniform sampler2D image;

out vec4 frag;

void main() {
	frag = texture(image, vec2(tex.x, 1 - tex.y));
}
