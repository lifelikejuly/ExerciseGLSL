#iChannel0 "file:///Volumes/JulyStudio/AllProjects/GLSL/Stroker/s909_1306.png"
#iChannel1 "file:///Volumes/JulyStudio/AllProjects/GLSL/Stroker/noise1.jpg"
#iChannel2 "file:///Volumes/JulyStudio/AllProjects/GLSL/Stroker/noise2.png"
#iChannel3 "file:///Volumes/JulyStudio/AllProjects/GLSL/Stroker/noise3.png"


#define SPEED 0.1
#define RANGE 0.2



float offset = 5.0  / 128.0;

void main() {

    // float t = mod(iTime,1.0);
    float t = iTime;
    vec2 uv = gl_FragCoord.xy / iResolution.xy;

    vec4 color1 = texture2D(iChannel0, uv);      //current frame
    vec2 uv2 = uv;
    uv2.x -= 0.01 * sin(iTime);
    uv2.y -= 0.01 * sin(iTime);
    vec4 color2 = texture2D(iChannel0, uv2);


    vec3 grayW = vec3(0.299,0.587,0.114);

    float motion = abs(dot(color1.rgb,grayW)-dot(color2.rgb,grayW));
    
    vec3 color = vec3(pow(motion,1.2)*3.0); 

    //筛选运动边缘，使其产生烟雾
    // if(motion > 0.5)
        // maskColor.a = 1.0; 

	// vec4 mergeColor = vec4(color1.rgb*color*pow(clamp(maskColor.r*5.0,0.0,1.0),3.0), 1.0);

    vec4 mergeColor = vec4(color1.rgb*color*pow(clamp(1.0,0.0,1.0),3.0), 1.0);

    //  gl_FragColor = mergeColor;


    vec4 scColor = texture2D(iChannel0,gl_FragCoord.xy);

    float ratio = 1.0;
    vec2 uv1 = vec2(uv.x,1.0-uv.y);
    vec2 noise1 = 	texture2D(iChannel3,uv1*vec2(ratio,1.2) - t*0.55).xy;
	vec2 noise = 	texture2D(iChannel3,uv1*vec2(ratio,1.2) + noise1*0.065 + t*0.15).xy;
		
	noise = noise * 2.0 - 1.0;
    vec4 newVal = texture2D(iChannel0 ,uv+noise*SPEED);
	// vec4 newVal = vec4(vec3(0.95, 0.85, 1.0) ,uv+noise*SPEED); //speed 0.005 0.015 0.045

    // 计算到画面中心的距离
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(uv, center);
    // 涟漪波纹函数，参数可调
    float ripple = 0.5 + 0.5 * sin(30.0 * dist - t * 6.0);
    float rippleFade = smoothstep(0.0, 0.5, 1.0 - dist); // 控制边缘渐隐

	vec4 resultColor = vec4(0.95, 0.85, 1.0, 1.0) * newVal * 0.975 * (1.0 + ripple * rippleFade * 0.7);	//0.975 削弱色彩强度
	// vec2 noise2 = texture2D(iChannel3,uv1*vec2(ratio,1.2)*5.0 - t*1.55).xy;
	// resultColor = resultColor+scColor * length(noise*noise2) * RANGE; //range is 3.5	,0 to 7
     if (color1.a >= 0.1){
        gl_FragColor = vec4(0.0);
    }else{
         gl_FragColor = resultColor;
    }
    

}