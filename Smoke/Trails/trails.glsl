
#iChannel0 "file://self"
#iChannel1 "file://./res/s909_1306.png"



// 随机干扰


#define SPEED 0.1

vec2 distort(vec2 uv) {
    vec2 a0 = vec2(0.5, 0.2);
    vec2 a1 = vec2(0.6, -0.4);
    vec2 a2 = vec2(0.2, 0.9);
    vec2 a3 = vec2(-0.7, 0.9);
    vec2 d = sin(17.4 * uv + 1.5 * sin(14.7 * uv.yx + 0.5 + a0 * iTime) + a1 * iTime);
    d += sin(16.4 * uv.yx + 1.3 * sin(15.7 * uv + 0.8 + a2 * iTime) - a3 * iTime);
    d.y -= 2.5;
    return uv * 0.995 + d * 0.003;
}


void main(){


    float t = iTime;

    vec2 uv = gl_FragCoord.xy/iResolution.xy;


    vec3 col = texture(iChannel0, distort(uv)).xyz;
    vec3 cam = pow(texture( iChannel1, uv).xyz, vec3(2.2));
    cam = vec3(dot(cam, vec3(.2126, .7152, .0722)));
    cam = smoothstep(0.4, 0.6, cam);
    col = max(col * vec3(0.95, 0.85, 1.0), cam);
    // Output to screen
    vec4 fragColor = vec4(vec3(col),1.0);
    
    // Output to screen
    gl_FragColor = fragColor;
}