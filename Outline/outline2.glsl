
#iChannel0 "file:///Volumes/JulyStudio/AllProjects/GLSL/Stroker/s909_1306.png"


//https://www.shadertoy.com/view/csc3W8 

float offset = 1.0  / 128.0;
float strength = 0.1;
void main() {
    float t = sin(iTime * 1.0);
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    gl_FragColor = texture(iChannel0,uv);
    offset = offset * strength;
    vec4 col = texture(iChannel0, uv);
    if (col.a > 1.0){
        gl_FragColor = vec4(0.0);
    }else {
        float a = texture(iChannel0, vec2(uv.x + offset, uv.y)).a +
            texture(iChannel0, vec2(uv.x, uv.y - offset)).a +
            texture(iChannel0, vec2(uv.x - offset, uv.y)).a +
            texture(iChannel0, vec2(uv.x, uv.y + offset)).a;
        if (col.a < 1.0 && a > 0.0){
            vec2 center = vec2(0.5, 0.5);
            float dist = distance(uv, center);
            float radius = fract(iTime * 0.2) * 0.5;
            float fade = 1.0 - smoothstep(radius - 0.05, radius + 0.05, dist);
            vec4 c = vec4(1.0, 1.0, 0.0, fade);
            gl_FragColor = c;
        }else{
            gl_FragColor = vec4(0.0);
        }  
    }
}