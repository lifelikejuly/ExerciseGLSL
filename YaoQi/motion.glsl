#iChannel0 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/s909_1306.png"
#iChannel1 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/noise1.jpg"
#iChannel2 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/noise2.png"
#iChannel3 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/noise3.png"


#define SPEED 0.1
#define RANGE 0.5

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
	// vec4 newVal = vec4(vec3(1.0) ,uv+noise*SPEED);	//speed 0.005 0.015 0.045

	vec4 resultColor = vec4(0.95, 0.85, 1.0, 1.0) * newVal *0.975;	//0.975 削弱色彩强度
	// vec2 noise2 = texture2D(iChannel3,uv1*vec2(ratio,1.2)*5.0 - t*1.55).xy;
	// resultColor = resultColor+scColor * length(noise*noise2) * RANGE; //range is 3.5	,0 to 7
     if (color1.a >= 0.1){
        gl_FragColor = vec4(0.0);
    }else{
        gl_FragColor = resultColor;
    }
    

}