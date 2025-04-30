// #iChannel0 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/noise1.jpg"
#iChannel0 "self"
#iChannel1 "file://./res/s909_1306.png"
// #iChannel1 "file://./res/dance.mov"
#iChannel2 "file://./res/noise3.png"

#define SPEED 0.008

vec2 distort(vec2 uv,float t) {
    vec2 a0 = vec2(0.5, 0.2);
    vec2 a1 = vec2(0.6, -0.4);
    vec2 a2 = vec2(0.2, 0.9);
    vec2 a3 = vec2(-0.7, 0.9);
    vec2 d = sin(17.4 * uv + 1.5 * sin(14.7 * uv.yx + 0.5 + a0 * t) + a1 * t);
    d += sin(16.4 * uv.yx + 1.3 * sin(15.7 * uv + 0.8 + a2 * t) - a3 * t);
    d.y -= 2.5;
    return uv * 0.995 + d * 0.003;
}


float offset = 10.0  / 128.0;
float strength = 1.0;

void main(){


    float t = iTime;//mod(iTime,1.0);

    vec2 uv = gl_FragCoord.xy/iResolution.xy;

    uv.x -= 0.01 * sin(t);
    uv.y -= 0.01 * sin(t);

    vec4 textRgba = texture(iChannel1, uv);
    // vec4 noise1 = texture(iChannel2, vec2(uv.x, uv.y - t * 0.1));
    // // 将noise1的r通道引入动态偏移，增强烟雾扰动感
    // float noiseFactor = noise1.r * 3.5 - 0.3; // [-1,1]区间扰动
    // float dynamicOffset = offset * strength + noiseFactor * 0.01;

    vec3 col = texture(iChannel0, distort(uv,t)).xyz;
    vec3 cam = pow(texture(iChannel1, uv).xyz, vec3(.2));
    cam = vec3(dot(cam, vec3(.2126, .7152, .0722)));
    cam = smoothstep(0.4, 0.6, cam);
    col = max(col * vec3(0.95, 0.85, 1.0), cam);

    // float a = smoothstep(0.001,1.0,dynamicOffset);
    vec4 fragColor = vec4(vec3(col),1.0);
    // gl_FragColor = fragColor;



    // gl_FragColor = mix(col.rgb,fragColor.rgb,fragColor.a);

    if (textRgba.a > 0.5){
        gl_FragColor = textRgba;
    }else { 
       gl_FragColor = fragColor;
    }
        
    // }
}