
#iChannel0 "file:///Volumes/JulyStudio/AllProjects/GLSL/Stroker/s909_1306.png"
#iChannel1 "file:///Volumes/JulyStudio/AllProjects/GLSL/Stroker/noise1.jpg"
#iChannel2 "file:///Volumes/JulyStudio/AllProjects/GLSL/Stroker/noise2.png"

//https://www.shadertoy.com/view/csc3W8 

float offset = 1.0  / 128.0;
float strength = 1.0;
// 增加时间律动参数
void main() {
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    // 让noise1采样的y坐标随时间向上偏移，模拟烟雾上升
    vec4 noise1 = texture(iChannel1, vec2(uv.x, uv.y - iTime * 0.08));
    // 将noise1的r通道引入动态偏移，增强烟雾扰动感
    float noiseFactor = noise1.r * 2.0 - 0.5; // [-1,1]区间扰动
    float dynamicOffset = offset * strength + noiseFactor * 0.01;
    vec4 col = texture(iChannel0, uv);
    if (col.a > 0.5){
        gl_FragColor = col;
    }else {
        // 只对向下（-Y）采样应用扰动和透明度变化，其他方向不变
        float a_down = texture(iChannel0, vec2(uv.x, uv.y - dynamicOffset)).a;
        float a_up = texture(iChannel0, vec2(uv.x, uv.y + offset)).a;
        float a_left = texture(iChannel0, vec2(uv.x - offset, uv.y)).a;
        float a_right = texture(iChannel0, vec2(uv.x + offset, uv.y)).a;
        if (col.a < 0.5 && a_down > 0.0) {
            // 只对下方边缘应用烟雾扰动和消散
            gl_FragColor = vec4(0.7, 0.5, 1.0, 0.8 * uv.y * (1.0 - uv.y));
        } else if (col.a < 0.5 && (a_up > 0.0 || a_left > 0.0 || a_right > 0.0)) {
            // 其他方向边缘不做扰动，保持原状
            gl_FragColor = col;
        } else {
            gl_FragColor = col;
        }
    }
}