3
#shader vertex
#version 430

layout(location = 0) in vec4 position;
layout(location = 1) in vec2 texCoord;
layout(location = 2) in vec4 vertNormal;

out vec3 varyingNormal;
//out vec3 varyingLightDir;
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

struct DirLight {
	vec3 direction;

	vec4 ambient;
	vec4 diffuse;
	vec4 specular;
};


struct Material
{
	vec4 ambient;
	vec4 diffuse;
	vec4 specular;
	float shininess;
};
//uniform vec4 globalAmbient;
//uniform PositionalLight light;
uniform Material material;
uniform mat4 m_matrix;
uniform sampler2D u_Texture;
uniform vec3 viewPos;
//uniform mat4 proj_matrix;

//uniform mat4 norm_matrix; //for transforming normals.

uniform mat4 u_MVP;

uniform DirLight dirLight;
#define NR_POINT_LIGHTS 4  
uniform PositionalLight pointLights[NR_POINT_LIGHTS];
//uniform mat4 shadowMVP2;


void main()
{

	varyingVertPos = (m_matrix * position).xyz;
	//varyingLightDir = light.position - varyingVertPos;
	//varyingNormal = (norm_matrix * vertNormal).xyz;
	varyingNormal = ((transpose(inverse(m_matrix))) * vertNormal).xyz;
	//shadow_coord = shadowMVP2 * position;
	//gl_Position = proj_matrix * m_matrix * position;
	gl_Position = u_MVP * position;
	v_TexCoord = texCoord;
};


////////////////////////////////////////////////////////////

#shader fragment
#version 430

in vec3 varyingNormal;
//in vec3 varyingLightDir;
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

struct DirLight {
	vec3 direction;

	vec4 ambient;
	vec4 diffuse;
	vec4 specular;
};
//uniform vec4 globalAmbient;
//uniform PositionalLight light;
uniform Material material;
uniform mat4 m_matrix;
uniform vec3 viewPos;
// mat4 proj_matrix;

uniform DirLight dirLight;
#define NR_POINT_LIGHTS 4  
uniform PositionalLight pointLights[NR_POINT_LIGHTS];
uniform sampler2D u_Texture;
//The CalcDirLight function implementation is mostly a direct copy of the shader in the "Multiple Lights" tutorial of LearnOpenGL.com
vec4 CalcDirLight(DirLight light, vec3 normal, vec3 viewDir);

vec4 CalcDirLight(DirLight light, vec3 normal, vec3 viewDir)
{
	vec3 lightDir = normalize(-light.direction);
	// diffuse shading
	float diff = max(dot(normal, lightDir), 0.0);
	// specular shading
	vec3 reflectDir = reflect(-lightDir, normal);
	float testSpec = dot(viewDir, reflectDir);
	float spec = 0.0;
	if (testSpec > 0.0) {
		spec = pow(testSpec, material.shininess);
	}
	// combine results
	vec4 ambient = light.ambient  * material.ambient;
	vec4 diffuse = light.diffuse  * material.diffuse;
	vec4 specular = light.specular * spec * material.specular;
	return (ambient + diffuse + specular);
}
//The CalcPointLight function implementation is mostly a direct copy of the shader in the "Multiple Lights" tutorial of LearnOpenGL.com
vec4 CalcPointLight(PositionalLight light, vec3 normal, vec3 fragPos, vec3 viewDir);

vec4 CalcPointLight(PositionalLight light, vec3 normal, vec3 fragPos, vec3 viewDir)
{
	vec3 lightDir = normalize(light.position - fragPos);
	// diffuse shading
	float diff = max(dot(normal, lightDir), 0.0);
	// specular shading
	vec3 reflectDir = reflect(-lightDir, normal);
	float testSpec = dot(viewDir, reflectDir);
	float spec = 0.0;
	if (testSpec > 0.0) {
		spec = pow(testSpec, material.shininess);
	}
		// attenuation
	float distance = length(light.position - fragPos);
	float attenuation = 1.0 / (light.constant + light.linearVal * distance +
		light.quadratic * (distance * distance));
	// combine results
	vec4 ambient = light.ambient  * material.ambient;
	vec4 diffuse = light.diffuse  * diff * material.diffuse;
	vec4 specular = light.specular * spec * material.specular;
	ambient *= attenuation;
	diffuse *= attenuation;
	specular *= attenuation;
	return (ambient + diffuse + specular);
}
void main()
{ // normalize the light, normal, and view vectors:
	vec4 texColor = texture(u_Texture, v_TexCoord);
	vec3 norm = normalize(varyingNormal);
	vec3 viewDir = normalize(viewPos - varyingVertPos);
	vec4 result = CalcDirLight(dirLight, norm, viewDir);
	for (int i = 0; i < NR_POINT_LIGHTS; i++)
		result += CalcPointLight(pointLights[i], norm, varyingVertPos, viewDir);
	fragColor = result + 0.3 * texColor;
};