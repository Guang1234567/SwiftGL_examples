#version 330 core
in vec2 TexCoord;

out vec4 color;

uniform sampler2D ourTexture1;
uniform sampler2D ourTexture2;

void main()
{
	// Linearly interpolate between both textures
    // using alpha channel from second texture
    vec4 tex1 = texture(ourTexture1, TexCoord);
    vec4 tex2 = texture(ourTexture2, TexCoord);
    color = mix(tex1, tex2, 0.2);
}
