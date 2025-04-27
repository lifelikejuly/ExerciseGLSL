
#iChannel0 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/s909_1306.png"
#iChannel1 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/noise1.jpg"
#iChannel2 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/noise2.png"
#iChannel3 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/noise3.png"

//https://www.shadertoy.com/view/csc3W8 

#define SPEED 0.1

vec3 Effect(float speed, vec2 uv, float time)
{

    float t = mod(time*speed,60.0);
    float rt =0.01*sin(t*0.45);
   
    mat2 m1 = mat2(cos(rt),-sin(rt),-sin(rt),cos(rt));
    vec2 uva=uv*m1;
    float irt = 0.005* cos(t*0.05);
    mat2 m2 = mat2(sin(irt),cos(irt),-cos(irt),sin(irt));
	for(int i=1;i<40;i+=1)
	{	
		float it = float(i);
        uva*=(m2);
        uva.y+=-1.0+(0.6/it) * cos(t + it*uva.x + 0.5*it)
            *float(mod(it,2.0)==0.0);
		uva.x+=1.0+(0.5/it) * cos(t + it*uva.y + 0.5*(it+15.0));
      
        
	}
    //Intensity range from 0 to n;
    float n = 0.5;
    float r = n + n * sin(4.0*uva.x+t);
    float gb = n + n * sin(3.0*uva.y);
	// return vec3(r,gb*0.8*r,gb*r);
    return vec3(r,r,r);
}	


float offset = 5.0  / 128.0;
float strength = 1.0;
// 增加时间律动参数
void main() {
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    // 让noise1采样的y坐标随时间向上偏移，模拟烟雾上升


    // 将noise1的r通道引入动态偏移，增强烟雾扰动感
    // float noiseFactor = noise1.r * 3.5 - 0.3; // [-1,1]区间扰动
    // float dynamicOffset = offset * strength + noiseFactor * 0.01;
    vec4 col = texture(iChannel0, uv);
    if (col.a >= 0.5){
        gl_FragColor = vec4(1.0);
    }else {
        // 只对向下（-Y）采样应用扰动和透明度变化，其他方向不变
        float a_down = texture(iChannel0, vec2(uv.x, uv.y - offset)).a;
        float a_up = texture(iChannel0, vec2(uv.x, uv.y + offset)).a;
        float a_left = texture(iChannel0, vec2(uv.x - offset, uv.y)).a;
        float a_right = texture(iChannel0, vec2(uv.x + offset, uv.y)).a;
        if (col.a < 0.5 && a_down >= 0.0) {
            // // 多重噪声扰动，增强气流的随机性和朦胧感
            float t = iTime;
            uv = 2.0 * uv - 1.0;
            uv.x *= iResolution.x/iResolution.y;
            uv *= (0.9 + 0.1*sin(t*0.01));
            uv.y-=iTime*0.13;
            vec3 col = Effect(SPEED,uv,t);
            gl_FragColor = vec4(col, 1.0);
        }
    }
}