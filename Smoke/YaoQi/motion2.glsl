#iChannel0 "file:///./res/s909_1306.png"
#iChannel1 "file:///./res/noise3.png"
#iChannel2 "self"


#define SPEED 0.005
#define RANGE 1.5



void main() {

    float t = mod(iTime,1.0);
    //  t = iTime * 0.00015;
    vec2 uv = gl_FragCoord.xy / iResolution.xy;





    vec2 uv1 = vec2(uv.x,1.0-uv.y);

    uv.x -= sin(iTime) * 0.015;
    uv.y -= cos(iTime) * 0.015;

    vec2 scaleuv = uv;

    // float RANGE = smoothstep(0.0,7.0,sin(iTime) * 7.0);

    vec4 scColor = texture2D(iChannel0,scaleuv);

    float ratio = 1.0;

    vec2 noise1 = 	texture2D(iChannel1,uv1*vec2(ratio,1.2) - t*0.55).xy;
	vec2 noise = 	texture2D(iChannel1,uv1*vec2(ratio,1.2) + noise1*0.065 + t*0.15).xy;

	noise = noise * 2.0 - 1.0;
    vec4 newVal = texture2D(iChannel2 ,uv+noise*SPEED);	//speed 0.005 0.015 0.045

	vec4 resultColor = vec4(0.95, 0.85, 1.0, 1.0)  *newVal *  clamp(noise1.x+0.5,0.0,0.955)*0.975;	//0.975 削弱色彩强度
	vec2 noise2 = texture2D(iChannel1,uv1*vec2(ratio,1.2)*5.0 - t*1.55).xy;
	resultColor = resultColor+scColor * length(noise*noise2) * RANGE; //range is 3.5	,0 to 7
    
    if (scColor.a >= 0.1){
        gl_FragColor = scColor;
    }else{
        gl_FragColor = resultColor;
    }
    

}