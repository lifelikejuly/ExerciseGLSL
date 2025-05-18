#iChannel0 "file:///./pass1.glsl"
#iChannel1 "self"
#iChannel2 "file:///./res/s909_1306.png"



void main() {

    vec2 uv = gl_FragCoord.xy / iResolution.xy;

    // vec2 uv2 = uv;
    // uv2.x -= 0.015 * sin(iTime);
    // uv2.y -= 0.015 * cos(iTime);
    // vec4 scColor = texture2D(iChannel2,uv2);

    vec2 uv1 = vec2(uv.x,1.0-uv.y);
    vec4 color1 = texture2D(iChannel0, uv);
	vec4 color2 = texture2D(iChannel1, uv);
	// vec4 maskColor = texture2D(bgMask, uv1);

	vec4 tempColor = color2*color2*0.85*(1.0-pow(clamp(0.05*1.1,0.0,1.0),1.35));

	vec4 resultColor = color1 + tempColor;
	
	resultColor.a = color1.a + dot(tempColor.rgb, vec3(0.33333));

    // if (scColor.a >= 0.1){
    //     gl_FragColor = scColor;
    // }else{
    //     gl_FragColor = resultColor;
    // }
    gl_FragColor = resultColor;
}