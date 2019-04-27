1
#shader vertex
#version 330 core
//This code is a transcription of the one in ThinMatrix's OpenGL animation tutorials on YouTube
const int MAX_JOINTS = 50;//max joints allowed in a skeleton
const int MAX_WEIGHTS = 3;//max number of joints that can affect a vertex

layout(location = 0) in vec3 in_position;
layout(location = 1) in vec3 in_weights;
layout(location = 2) in ivec3 in_jointIndices;


uniform mat4 jointTransforms[MAX_JOINTS];

uniform mat4 u_VP; // view projection-matrix
out vec4 varyingColor;
void main()
{
	vec4 totalLocalPos = vec4(0.0);

	for (int i = 0; i<MAX_WEIGHTS; i++) {
		mat4 jointTransform = jointTransforms[in_jointIndices[i]];
		vec4 posePosition = jointTransform * vec4(in_position, 1.0);
		totalLocalPos += posePosition * in_weights[i];

	}

	gl_Position = u_VP * totalLocalPos;
	//gl_Position = u_VP * vec4(in_position, 1.0);
	varyingColor = totalLocalPos * 0.5 + vec4(0.5, 0.5, 0.5, 0.5);

};

#shader fragment
#version 330 core
in vec4 varyingColor;
layout(location = 0) out vec4 color;

void main()
{
	color = varyingColor;
};

