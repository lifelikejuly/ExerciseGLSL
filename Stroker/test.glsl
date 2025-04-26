#iChannel0 "file:///Volumes/JulyStudio/AllProjects/GLSL/Stroker/s909_1306.png"



// PERLIN

const int firstOctave = 3;
const int octaves = 8;
const float persistence = 0.6;

float noise(int x,int y)
{   
    float fx = float(x);
    float fy = float(y);
    
    return 2.0 * fract(sin(dot(vec2(fx, fy) ,vec2(12.9898,78.233))) * 43758.5453) - 1.0;
}

float smoothNoise(int x,int y)
{
    return noise(x,y)/4.0+(noise(x+1,y)+noise(x-1,y)+noise(x,y+1)+noise(x,y-1))/8.0+(noise(x+1,y+1)+noise(x+1,y-1)+noise(x-1,y+1)+noise(x-1,y-1))/16.0;
}

float COSInterpolation(float x,float y,float n)
{
    float r = n*3.1415926;
    float f = (1.0-cos(r))*0.5;
    return x*(1.0-f)+y*f;
    
}

float InterpolationNoise(float x, float y)
{
    int ix = int(x);
    int iy = int(y);
    float fracx = x-float(int(x));
    float fracy = y-float(int(y));
    
    float v1 = smoothNoise(ix,iy);
    float v2 = smoothNoise(ix+1,iy);
    float v3 = smoothNoise(ix,iy+1);
    float v4 = smoothNoise(ix+1,iy+1);
    
   	float i1 = COSInterpolation(v1,v2,fracx);
    float i2 = COSInterpolation(v3,v4,fracx);
    
    return COSInterpolation(i1,i2,fracy);
    
}

float PerlinNoise2D(float x,float y)
{
    float sum = 0.0;
    float frequency =0.0;
    float amplitude = 0.0;
    for(int i=firstOctave;i<octaves + firstOctave;i++)
    {
        frequency = pow(2.0,float(i));
        amplitude = pow(persistence,float(i));
        sum = sum + InterpolationNoise(x*frequency,y*frequency)*amplitude;
    }
    
    return sum;
}

// FOG


vec3 CalculateOutlineColor(in vec2 fragCoord, in float outer){
    vec2 uv = fragCoord.xy / iResolution.xy;
            
			float t = iTime + 100.0;
            
            float x = uv.x;
			//float x = ((uv.x - 0.5) * (0.4 + 0.4 * uv.y));
            
            //layer1
			float x1 = x+t*0.01;
			//float y1 = uv.y+3.0+0.05*cos(t*2.0)+t*0.01;
			float noise1 = 0.5+2.0*PerlinNoise2D(x1,uv.y);
            
            //layer2
			float x2 = x+t*0.2;
			//float y2 = uv.y+3.0+0.1*cos(t);
			float noise2 = 0.5+2.0*PerlinNoise2D(x2,uv.y);
                        
			float noise = 1.2*noise1+0.6*noise2;
            
            //round noise
			float a = floor(noise*10.0)/10.0;

			float b = floor(noise*50.)/50.;
			float c = floor(noise2*50.0);
            
			float final = a;
            
            //Add shine
			if((b==0.7||b==0.9||b==0.5||b==1.1||b==0.5)
			   &&noise2>0.50
			){
				final=0.2+0.2*noise2;
			}
    		final -= outer*0.1;
			return vec3(2.0-2.0*final,1.0-1.0*final,0.0-2.0*final);
}





// MAIN



void mainImage(out vec4 result, in vec2 fragCoord)
{
    // float r = min(iResolution.x, iResolution.y);
    float r = iResolution.y;
	// vec2 uv = fragCoord / r;

    vec2 uv = gl_FragCoord.xy / iResolution.xy;

    uv.x /= 8.0;
    uv.y = 1.0 - uv.y;
    
    vec3 c = texture(iChannel0, uv-vec2(1.0*0.03,0)).rgb;
    
    float a = texture(iChannel0, uv-vec2(1.0*0.03,0)).a;
    bool i = bool(step(0.5, a) == 1.0);
    
    const int md = 20;
    const int h_md = md / 2;
    
    float d = float(md);
    
    for (int x = -h_md; x != h_md; ++x)
    {
        for (int y = -h_md; y != h_md; ++y)
        {
            vec2 o = vec2(float(x), float(y));
            vec2 s = (fragCoord + o) / r;
    		s.x /= 8.0;
    		s.y = 1.0 - s.y;
            
            float o_a = texture(iChannel0, s-vec2(1.0*0.03,0)).a;
            bool o_i = bool(step(0.5, o_a) == 1.0);
            
            if (!i && o_i || i && !o_i)
                d = min(d, length(o));
        }
    }
    
    d = clamp(d, 0.0, float(md)) / float(md);
    
    if (i)
        d = -d;
    
    d = d * 0.5 + 0.5;
    d = 1.0 - d;
    
    
    float border_fade_outer = 0.1;
    float border_fade_inner = 0.01;
    float border_width = 0.25;
    vec3 border_color = vec3(1.0, 0.3, 0.0);
    
    float outer = smoothstep(0.5 - (border_width + border_fade_outer), 0.5, d);
    
    vec3 temp = vec3(0.0, 0.0, 0.0);
    vec4 border = mix(vec4(temp, 0.0), vec4(CalculateOutlineColor(fragCoord, outer), 1.0), outer);
    
    float inner = smoothstep(0.5, 0.5 + border_fade_inner, d);
    
    vec4 color = mix(border, vec4(c, 1.0), inner);
    
    result = color;
}


