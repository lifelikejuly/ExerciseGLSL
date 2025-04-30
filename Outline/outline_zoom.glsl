
#iChannel0 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/s909_1306.png"


//https://www.shadertoy.com/view/csc3W8 

float offset = 1.0  / 128.0;
float strength = 0.1;

void main() {
    float t = cos(iTime * 1.0) + 2.0;

    vec2 uv = gl_FragCoord.xy / iResolution.xy;

    

     vec2 center = vec2(0.5, 0.5);
    // 向量距离
    float dist = distance(uv, center);
    // 取小数部分算出一个半径信息
    float radius = fract(t * 0.2) * 0.5 + 1.0;
    // float fade = 1.0 + smoothstep(radius - 0.05, radius + 0.05, dist);
    vec2 zoomUv =  uv * radius;

    gl_FragColor = texture(iChannel0,uv);
    offset = offset * strength;
    vec4 col = texture(iChannel0, uv);
    if (col.a > 1.0){
        gl_FragColor = vec4(0.0);
    }else {
        // 透明度信息
        float a = texture(iChannel0, vec2(zoomUv.x + offset, zoomUv.y)).a +
            texture(iChannel0, vec2(zoomUv.x, zoomUv.y - offset)).a +
            texture(iChannel0, vec2(zoomUv.x - offset, zoomUv.y)).a +
            texture(iChannel0, vec2(zoomUv.x, zoomUv.y + offset)).a;
        if (col.a < 1.0 && a > 0.0){
            vec4 c = vec4(1.0, 1.0, 0.0, 1.0);
            gl_FragColor = c;
        }else{
            gl_FragColor = vec4(0.0);
        }  
    }
}