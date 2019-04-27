3
#shader vertex
#version 430

layout(location = 0) in vec4 position;
layout(location = 1) in vec2 texCoord;
layout(location = 2) in vec4 vertNormal;

out vec3 varyingNormal;
out vec3 varyingLightDir;
out vec3 varyingVertPos;
//out vec4 shadow_coord;

out vec2 v_TexCoord;

struct PositionalLight
{
	vec4 ambient;
	vec4 diffuse;
	vec4 specular;
	vec3 position;
	float constant;
	float linearVal;
	float quadratic;
};
struct Material
{
	vec4 ambient;
	vec4 diffuse;
	vec4 specular;
	float shininess;
};
uniform vec4 globalAmbient;
uniform PositionalLight light;
uniform Material material;
uniform mat4 m_matrix;
//uniform mat4 proj_matrix;

//uniform mat4 norm_matrix; //for transforming normals.

uniform mat4 u_MVP;
//uniform mat4 shadowMVP2;


void main()
{

	varyingVertPos = (m_matrix * position).xyz;
	varyingLightDir = light.position - varyingVertPos;
	//varyingNormal = (norm_matrix * vertNormal).xyz;
	varyingNormal = ((transpose(inverse(m_matrix))) * vertNormal).xyz;
	//shadow_coord = shadowMVP2 * position;
	//gl_Position = proj_matrix * m_matrix * position;
	gl_Position = u_MVP * position;
	v_TexCoord = texCoord;
};

#shader fragment
#version 430

in vec3 varyingNormal;
in vec3 varyingLightDir;
in vec3 varyingVertPos;
in vec2 v_TexCoord;
//in vec4 shadow_coord;
//layout(location = 0) out vec4 color;
out vec4 fragColor;


struct PositionalLight
{
	vec4 ambient; //last component for ambient, diffuse, specular are the intensities?
	vec4 diffuse;
	vec4 specular;
	vec3 position;
	float constant;
	float linearVal;
	float quadratic;

};
struct Material
{
	vec4 ambient;
	vec4 diffuse;
	vec4 specular;
	float shininess;
};
uniform vec4 globalAmbient;
uniform PositionalLight light;
uniform Material material;
uniform mat4 m_matrix;
// mat4 proj_matrix;

//mat4 norm_matrix; //for transforming normals.
//uniform sampler2DShadow shTex; //This may need to be set to layout (binding = 0).
//layout(binding = 0) uniform sampler2DShadow shTex;
//uniform vec4 u_Color;
uniform sampler2D u_Texture;
void main()
{ // normalize the light, normal, and view vectors:
	vec3 L = normalize(varyingLightDir);
	vec3 N = normalize(varyingNormal);
	vec3 V = normalize(-varyingVertPos);

	//float inShadow = textureProj(shTex, shadow_coord);
	// compute light reflection vector with respect to N:
	vec3 R = normalize(reflect(-L, N));
	// get the angle between the light and surface normal:
	float cosTheta = dot(L, N);
	// angle between the view vector and reflected light:
	float cosPhi = dot(V, R);

	float distance = length(light.position - varyingVertPos);
	float attenuation = 1.0 / (light.constant + light.linearVal * distance + light.quadratic * (distance * distance));

	// compute ADS contributions (per pixel), and combine to build output color:
	vec3 ambient = ((globalAmbient * material.ambient) + (light.ambient * material.ambient)).xyz;
	vec3 diffuse = light.diffuse.xyz * material.diffuse.xyz * max(cosTheta, 0.0);
	vec3 specular =
		light.specular.xyz * material.specular.xyz * pow(max(cosPhi, 0.0), material.shininess);

	ambient *= attenuation;
	diffuse *= attenuation;
	specular *= attenuation;
	vec4 texColor = texture(u_Texture, v_TexCoord);

	//fragColor = 0.5 * texColor + 0.05 * vec4((ambient), 1.0);

	fragColor = 0.5 * texColor + 0.5 * vec4((ambient + diffuse + specular), 1.0);
	//fragColor = texColor;
	//Gonna need to add stuff

	//if (inShadow != 0.0)
	//{
	//	fragColor = 0.5 * texColor + 5.0 * vec4((ambient + diffuse + specular), 1.0);
	//}

};