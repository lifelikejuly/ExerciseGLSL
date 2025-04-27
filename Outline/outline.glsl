
#iChannel0 "file:///Volumes/JulyStudio/AllProjects/GLSL/Stroker/s909_1306.png"


//https://www.shadertoy.com/view/csc3W8 

float offset = 1.0  / 128.0;
float strength = 1.0;
void main() {

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
        if (col.a < 1.0 && a > 0.0)
            gl_FragColor = vec4(1.0, 0.0, 0.0, 0.8);
        else
            gl_FragColor = vec4(0.0);
    }
}