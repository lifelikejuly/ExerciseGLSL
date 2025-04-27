
#iChannel1 "file:///Volumes/JulyStudio/AllProjects/GLSL/Stroker/noise1.jpg"
#iChannel0 "file:///Volumes/JulyStudio/AllProjects/GLSL/Stroker/s909_1306.png"

#define ST 0.1
#define PI 3.141592

vec4 colrat(vec2 uv){
	return texture(iChannel0,uv);
}
float noise(vec2 n){
    return texture(iChannel1,vec2(n.x*5.0,0.0)).x;
}

float atan2(float y, float x){
    if(x>0.0){
        return atan(y,x);
    }
    else if (y>0.0){
    	return PI/2.0-atan(x,y);
    }
    else if (y<0.0){
    	return -PI/2.0-atan(x,y);
    }
    else if (x==0.0 && y==0.0){
        return 0.0;
    }
}


// the fluidish simulacre
void main()
{
    vec2 uv = gl_FragCoord.xy/iResolution.xy;
   vec4 col = vec4(0.0);
    
    // vec2 mid = vec2(iResolution.x/2.0,iResolution.y/2.0);
    vec2 mid = vec2(iMouse.x,iMouse.y);
    
    float thet = (atan2(gl_FragCoord.y-mid.y,gl_FragCoord.x-mid.x));
    float dist = distance(gl_FragCoord.xy,mid);
    float rad = noise(vec2(cos(thet+float(iFrame)/100.0),sin(thet+float(iFrame)/20.0)));
    
    float r = 2.0*sin(float(iFrame)/30.0);
    //float r = 0.5;
    
    float t = 0.0;
    for(float a0 = 0.0; a0<PI; a0+=ST){
    	col += colrat(uv+vec2(cos(thet),sin(thet))*r*0.0002*dist*dist*0.006*rad*(cos(a0)));
    	t ++;
    }
       
    col /= t;
    
    // Output to screen
    vec4 fragColor = vec4(col.xyz,1.0);
    gl_FragColor = fragColor;
}