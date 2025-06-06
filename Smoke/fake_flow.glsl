
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

vec3 Effect2(float speed, vec2 uv, float time)
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

void main() {
    float t = iTime;
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    vec3 col = Effect2(SPEED,uv,t);
    gl_FragColor = vec4(col, 1.0); 
}

