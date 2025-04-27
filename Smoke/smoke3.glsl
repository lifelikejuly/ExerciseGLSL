
#iChannel1 "file:///Volumes/JulyStudio/AllProjects/GLSL/Stroker/noise1.jpg"
#iChannel0 "file:///Volumes/JulyStudio/AllProjects/GLSL/Stroker/s909_1306.png"

#define TEX(uv) texture(iChannel0, uv).r

// fbm gyroid cyclic noise
float gyroid (vec3 seed) { return dot(sin(seed),cos(seed.yzx)); }
float fbm (vec3 seed) {
    float result = 0.;
    float a = .5;
    for (int i = 0; i < 4; ++i) {
        result += sin(gyroid(seed/a)*3.14+iTime/a)*a;
        a /= 2.;
    }
    return result;
}

// the fluidish simulacre
void main()
{
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
    vec2 p = (gl_FragCoord.xy-iResolution.xy/2.)/iResolution.y;
    vec3 blue = texture(iChannel1, gl_FragCoord.xy/1024.).rgb;
    
    float dt = iTimeDelta;
    float current = 1.0;//texture(iChannel0, uv).r;
    
    // shape
    float shape = p.y+.5;
    
    
    // masks
    float shade = smoothstep(.01,.0,shape);
    float smoke = pow(uv.y,.5);
    float flame = 1.-uv.y;
    float steam = pow(current, 0.2);
    float cycle = .5 + .5 * sin(iTime-uv.x*3.);
    
    vec2 offset = vec2(0);
    
    // gravity
    offset += vec2(0,-1) * flame * cycle * steam;
    
    // wind
    //offset.x += sin(iTime*.2);
    //offset += 3.*normalize(p*rot(.1)-p) * smoothstep(.1,.0,abs(length(p)-.5));
    
    // expansion
    vec4 data = vec4(1.0,1.0,1.0,1.0); // texture(iChannel0, uv);
    vec3 unit = vec3(20.*blue.x/iResolution.xy,0);
    vec3 normal = normalize(vec3(
        TEX(uv - unit.xz)-TEX(uv + unit.xz),
        TEX(uv - unit.zy)-TEX(uv + unit.zy),
        data.x*data.x*data.x)+.001);
    offset -= normal.xy * (smoke + cycle) * steam;
    
    // turbulence
    vec3 seed = vec3(p*2.,p.y);
    float angle = fbm(seed)*6.28*2.;
    offset += vec2(cos(angle),sin(angle)) * flame;
    
    // energy loss
    vec4 frame = vec4(1.0,1.0,1.0,1.0); //texture(iChannel0, uv+offset/iResolution.xy);
    shade = max(shade, frame.r-dt*.2);
    vec4 fragColor = vec4(shade);
    gl_FragColor = fragColor;
}