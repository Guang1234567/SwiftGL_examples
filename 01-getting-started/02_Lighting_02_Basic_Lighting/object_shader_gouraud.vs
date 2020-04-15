#version 330 core

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;

out vec3 LightingColor;

uniform vec3 lightPos;
uniform vec3 viewPos;
uniform vec3 lightColor;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
    vec3 FragPos = vec3(model * vec4(aPos, 1.0f));
    vec3 Normal = mat3(transpose(inverse(model))) * aNormal;

    // common
    // ----------
    vec3 lightDir = normalize(lightPos - FragPos);
    vec3 norm = normalize(Normal);

    // 环境光强度
    // ----------
    float ambientStrength = 0.1;
    vec3 ambient = ambientStrength * lightColor;

    // 漫反射光强度
    // -----------
    float diffStrength = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = lightColor * diffStrength;

    // 镜面反射光强度
    // ------------
    float specularStrength = 0.5;
    vec3 viewDir = normalize(viewPos - FragPos);
    // reflect函数要求第一个向量是从光源指向片段位置的向量
    vec3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 256);
    vec3 specular = specularStrength * spec * lightColor;


    LightingColor = ambient + diffuse + specular;

    gl_Position = projection * view * model * vec4(aPos, 1.0f);
}