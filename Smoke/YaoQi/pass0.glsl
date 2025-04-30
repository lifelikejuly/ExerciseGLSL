#iChannel0 "file:///./res/s909_1306.png"
#iChannel3 "file:///./res/noise3.png"



void main() {

    vec2 uv = gl_FragCoord.xy / iResolution.xy;

    vec4 color1 = texture2D(iChannel0, uv);      //current frame
    vec2 uv2 = uv;
    uv2.x -= 0.015 * sin(iTime);
    uv2.y -= 0.015 * cos(iTime);
    vec4 color2 = texture2D(iChannel0, uv2);

    // vec4 maskColor = texture2D(iChannel0, uv);

    vec3 grayW = vec3(0.299,0.587,0.114);

    float motion = abs(dot(color1.rgb,grayW)-dot(color2.rgb,grayW));
    vec3 color = vec3(pow(motion,1.2)*3.0); 

    vec4 mergeColor = vec4(color1.rgb*color*pow(clamp( 0.1 * 5.0,0.0,1.0),3.0), 1.0);

    gl_FragColor = mergeColor;
}