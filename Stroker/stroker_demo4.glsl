
#iChannel0 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/s909_1306.png"
#iChannel1 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/noise1.jpg"
#iChannel2 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/noise2.png"
#iChannel3 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/noise3.png"

//https://www.shadertoy.com/view/csc3W8 

#define SPEED 0.1
#define RANGE 0.5


float offset = 1.0  / 128.0;
float strength = 1.0;
// 增加时间律动参数
void main() {


    float t = mod(iTime,1.0);
    vec2 uv = gl_FragCoord.xy / iResolution.xy;

    // vec2 uv1 = uv;
    vec2 uv1 = vec2(uv.x,1.0-uv.y);

    


    // 
    // vec4 color1 = texture2D(iChannel0, uv);      //current frame
    // vec2 uv2 = uv;
    // uv2.x -= 0.01 * sin(iTime);
    // uv2.y -= 0.01 * sin(iTime);
    // vec4 color2 = texture2D(iChannel0, uv2);


    // vec3 grayW = vec3(0.299,0.587,0.114);

    // float motion = abs(dot(color1.rgb,grayW)-dot(color2.rgb,grayW));
    
    // vec3 color = vec3(pow(motion,1.2)*3.0); 

    //筛选运动边缘，使其产生烟雾
    // if(motion > 0.5)
    //     maskColor.a = 1.0; 

	// vec4 mergeColor = vec4(color1.rgb*color*pow(clamp(maskColor.r*5.0,0.0,1.0),3.0), 1.0);
    // vec4 mergeColor = vec4(color1.rgb*color, 1.0);
    

    vec2 newUv = uv;
    // newUv.x -= 0.01 * sin(iTime);
    // newUv.y -= 0.01 * sin(iTime);

    vec4 scColor = texture2D(iChannel0,newUv);
    float ratio = 1.0;
    vec2 noise1 = texture2D(iChannel3,uv1*vec2(ratio,1.2) - t*0.55).xy;
	vec2 noise = texture2D(iChannel3,uv1*vec2(ratio,1.2) + noise1*0.065 + t*0.15).xy;
    noise = noise * 2.0 - 1.0;
	// vec4 newVal = vec4(mergeColor.rgb ,uv+noise*SPEED);	//speed 0.005 0.015 0.045
    vec4 newVal = texture2D(iChannel0 ,uv+noise*SPEED);
	vec4 resultColor = vec4(0.95, 0.85, 1.0, 1.0) * newVal * clamp(noise1.x+0.5,0.0,0.955)*0.975;	//0.975 削弱色彩强度
	vec2 noise2 = texture2D(iChannel3,uv1*vec2(ratio,1.2)*5.0 - t*1.55).xy;
	
    
    vec4 maskColor = resultColor+scColor * length(noise*noise2) * RANGE; //range is 3.5	,0 to 7
	   maskColor.rgb = vec3(1.0); 
   

    vec4 noiseRange = texture(iChannel3, vec2(uv.x, uv.y - iTime * 0.1));
    // 将noise1的r通道引入动态偏移，增强烟雾扰动感
    float noiseFactor = noiseRange.r * 3.5 - 0.3; // [-1,1]区间扰动
    float dynamicOffset = offset * strength + noiseFactor * 0.01;
    if (scColor.a >= 0.1){
        gl_FragColor = vec4(0.0);
    }else{
        float a_down = texture(iChannel0, vec2(uv.x, uv.y - dynamicOffset)).a;
        if(scColor.a < 0.5 && a_down >= 0.0){
             gl_FragColor = maskColor;
        }
    }
   
    // gl_FragColor = maskColor;
}