
#iChannel0 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/s909_1306.png"
#iChannel1 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/noise1.jpg"
#iChannel2 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/noise2.png"

//https://www.shadertoy.com/view/csc3W8 

float offset = 1.0  / 128.0;
float strength = 1.0;
// 增加时间律动参数
void main() {
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    // 让noise1采样的y坐标随时间向上偏移，模拟烟雾上升
    vec4 noise1 = texture(iChannel1, vec2(uv.x, uv.y - iTime * 0.1));
    // 将noise1的r通道引入动态偏移，增强烟雾扰动感
    float noiseFactor = noise1.r * 3.5 - 0.3; // [-1,1]区间扰动
    float dynamicOffset = offset * strength + noiseFactor * 0.01;
    vec4 col = texture(iChannel0, uv);
    if (col.a > 0.5){
        gl_FragColor = vec4(0.0);
    }else {
        // 只对向下（-Y）采样应用扰动和透明度变化，其他方向不变
        float a_down = texture(iChannel0, vec2(uv.x, uv.y - dynamicOffset)).a;
        if (col.a < 0.5 && a_down > 0.0) {
            vec3 mistColor = vec3(1.0);
            gl_FragColor = vec4(mistColor, 1.0);
        }
    }
}