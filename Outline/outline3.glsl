
#iChannel0 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/s909_1306.png"


//https://www.shadertoy.com/view/csc3W8 

float offset = 0.1;//10.0  / 128.0;
float strength = 0.1;

float duration = 0.7;
float maxAlpha = 0.5;
float maxScale = 1.8;


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
            float progress = mod(iTime, duration) / duration;
            float currentAlpha = maxAlpha*(1.0-progress);
            float currentScale = 1.0 + (maxScale-1.0) * progress;
            vec2 weakedUv = 0.5 + (uv - 0.5)/currentScale;

            vec4 weakMask = vec4(vec2(1.0),weakedUv);//texture(iChannel0, weakedUv);
            vec4 origin = vec4(vec2(1.0),uv);//texture(iChannel0, uv);
            gl_FragColor = origin* (1.0-currentAlpha) + weakMask*currentAlpha;
            gl_FragColor = vec4(1.0,0.0,0.0,1.0);
        }else{
            gl_FragColor = vec4(0.0);
        }  
    }
}