2
#shader vertex
#version 330 core

layout(location = 0) in vec4 position;
layout(location = 1) in vec2 texCoord;

out vec2 v_TexCoord;

uniform mat4 u_MVP; //model view projection-matrix
					//uniform mat4 u_M; //model matrix.
					//uniform mat4 u_V; //View matrix.
					//uniform mat4 u_P; //perspective matrix.

					//out vec4 varyingColor;
void main()
{

	gl_Position = u_MVP * position;
	//gl_Position = position;
	//varyingColor = position * 0.5 + vec4(0.5, 0.5, 0.5, 0.5);
	v_TexCoord = texCoord;
};

#shader fragment
#version 330 core

layout(location = 0) out vec4 color;
in vec2 v_TexCoord;

//uniform vec4 u_Color;
uniform sampler2D u_Texture;
void main()
{
	//color = varyingColor;
	vec4 texColor = texture(u_Texture, v_TexCoord);
	color = texColor;
};