
#iChannel0 "file://./res/green.jpg"
#iChannel1 "file://./res/s909_1306.png"

//https://github.com/rbaltrusch/smoke_shader/blob/master/smoke_shader.frag


// gives funny-looking shader but not very random
float random2(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

const float u_colour_decay_rate = 10.95;
const float u_decay_rate = 0.002;
const float PHI = 1.61803398874989484820459;  // Golden Ratio   
float random3(in vec2 xy, in float seed) {
    return fract(tan(distance(xy * PHI, xy) * seed) * xy.x);
}

float sum(vec4 rgb) {
    return rgb.r + rgb.g + rgb.b;
}


void main()
{
    vec2 uvs = gl_FragCoord.xy/iResolution.xy;
    vec4 col = vec4(0.0);

    float t = iTime;


    vec4 texture1 = texture(iChannel1, uvs);
    vec2 random_offset = vec2(random3(uvs, t) - 0.5, random3(uvs, t + 1.0));
    vec4 below = texture(iChannel1, uvs + 0.01 * random_offset);
    vec4 tex = sum(below) > sum(texture1) ? (below * u_colour_decay_rate) : texture1;

    vec4 fragColor = vec4(tex.rgb - u_decay_rate,  texture1.a);
    gl_FragColor = fragColor;
}