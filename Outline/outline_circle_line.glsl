
#iChannel0 "file://./res/s909_1306.png"


//https://www.shadertoy.com/view/csc3W8 

float offset = 1.0  / 128.0;
float strength = 0.1;

vec4 circleColorFill(vec2 uv){
    // 中心点
    vec2 center = vec2(0.5, 0.5);
    // 向量距离
    float dist = distance(uv, center);
    // 取小数部分算出一个半径信息
    float radius = fract(iTime * 0.2) * 0.5;
    // 距离长在半径范围内变化 0.1
    float fade = 1.0 - smoothstep(radius - 0.05, radius + 0.05, dist);
    // 填充透明度信息 
    vec4 c = vec4(1.0, 1.0, 0.0, fade);
    return c;
}

void main() {
    float t = sin(iTime * 1.0);
    vec2 uv = gl_FragCoord.xy / iResolution.xy;

    gl_FragColor = texture(iChannel0,uv);
    offset = offset * strength;
    vec4 col = texture(iChannel0, uv);
    if (col.a > 1.0){
        gl_FragColor = vec4(0.0);
    }else {
        // 透明度信息
        float a = texture(iChannel0, vec2(uv.x + offset, uv.y)).a +
            texture(iChannel0, vec2(uv.x, uv.y - offset)).a +
            texture(iChannel0, vec2(uv.x - offset, uv.y)).a +
            texture(iChannel0, vec2(uv.x, uv.y + offset)).a;
        if (col.a < 1.0 && a > 0.0){
            vec4 c = circleColorFill(uv);
            gl_FragColor = c;// mix(c,c2,c2.a);
        }else{
            gl_FragColor = vec4(0.0);
        }  
    }
}