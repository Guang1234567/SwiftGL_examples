#version 330 core

in vec3 FragPos;
in vec3 Normal;

out vec4 FragColor;


uniform vec3 lightPos;
uniform vec3 viewPos;
uniform vec3 objectColor;
uniform vec3 lightColor;

void main()
{
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
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
    vec3 specular = specularStrength * spec * lightColor;

    vec3 result = (ambient + diffuse) * objectColor;
    FragColor = vec4(result, 1.0);
}
