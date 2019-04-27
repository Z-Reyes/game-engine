1
#shader vertex
#version 330 core

layout(location = 0) in vec4 position;


//out vec2 v_TexCoord;


uniform mat4 u_MVP; //model view projection-matrix
out vec4 varyingColor;
void main()
{
  gl_Position = u_MVP * position;
  varyingColor = position * 0.5 + vec4(0.5, 0.5, 0.5, 0.5);

};

#shader fragment
#version 330 core
in vec4 varyingColor;
layout(location = 0) out vec4 color;

uniform vec4 u_Color;

void main()
{
	color = varyingColor;
};