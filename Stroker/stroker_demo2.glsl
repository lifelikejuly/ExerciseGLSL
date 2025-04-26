
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
    vec4 noise2 = texture(iChannel2,uv);
    // 将noise1的r通道引入动态偏移，增强烟雾扰动感
    float noiseFactor = noise1.r * 3.5 - 0.3; // [-1,1]区间扰动
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
            // 多重噪声扰动，增强气流的随机性和朦胧感
            float t = iTime * 0.18;
            float flowNoise1 = texture(iChannel2, uv * 2.2 + vec2(t * 0.5, t * 0.2)).r;
            float flowNoise2 = texture(iChannel1, uv * 3.1 - vec2(t * 0.13, t * 0.21)).g;
            float flowNoise3 = texture(iChannel2, uv * 4.5 + vec2(-t * 0.18, t * 0.09)).b;
            float flowShape = smoothstep(0.0, 0.22 + flowNoise1 * 0.12 + flowNoise2 * 0.09 + flowNoise3 * 0.07, uv.y);

            // 颜色渐变：底部淡蓝紫，顶部淡青白
            vec3 baseColor = mix(vec3(0.7, 0.75, 1.0), vec3(0.85, 0.95, 1.0), uv.y + flowNoise1 * 0.15);

            // 透明度更柔和，朦胧感更强
            float mistAlpha = 0.45 * uv.y * (1.0 - uv.y);
            float disturb = (flowNoise1 + flowNoise2 + flowNoise3 - 1.5) * 0.18;
            float alpha = mistAlpha * flowShape * (0.9 + disturb);

            // 叠加淡淡的的高光气流点，增加流动感
            float mistHighlight = step(0.92, flowNoise1) * smoothstep(0.0, 0.08, uv.y) * smoothstep(1.0, 0.92, uv.y);
            vec3 mistColor = mix(baseColor, vec3(0.95, 1.0, 1.0), mistHighlight * 0.7);
            float outAlpha = clamp(alpha + mistHighlight * 0.18, 0.0, 1.0);

            gl_FragColor = vec4(mistColor, outAlpha);
        } else if (col.a < 0.5 && (a_up > 0.0 || a_left > 0.0 || a_right > 0.0)) {
            gl_FragColor = col;
        } else {
            gl_FragColor = col;
        }
    }
}