#define M_PI 3.14159265359
#define M_TWOPI 6.28318530718

mat2 rot(float a)
{
return mat2(
  cos(a), sin(a),
  -sin(a), cos(a)
  );
}

float hash11(float n)
{
	return fract(sin(n)*43758.5453);
}

float noise31(in vec3 n)
{
	vec3 p = floor(n);
    vec3 f = fract(n);
    f = f*f*(3.-2.*f);
    float q = p.x+p.y*57.+p.z*113.;
    float r = mix(mix(mix(hash11(q+0.),hash11(q+1.),f.x),
                      mix(hash11(q+57.),hash11(q+58.),f.x),f.y),
                  mix(mix(hash11(q+113.),hash11(q+114.),f.x),
                      mix(hash11(q+170.),hash11(q+171.),f.x),f.y),f.z);
    return r;
}

float fbm(vec3 x, in float H ){//iq's fbm    
    float G = exp2(-H);
    float f = 1.0;
    float a = 1.0;
    float t = 0.0;
    for( int i=0; i<6; i++ )
    {
        x.xy*=rot(0.2*M_PI);
        t += a*noise31(f*x);
        f *= 2.0;
        a *= G;
    }
    return t;
}

vec2 poltocar(float magnitude, float angle) {
	float x = magnitude * cos(angle);
	float y = magnitude * sin(angle); 
	return vec2(x, y);
}

//from https://www.shadertoy.com/view/XljGzV
vec3 rgb2hsl( vec3 c ){
  float h = 0.0;
	float s = 0.0;
	float l = 0.0;
	float r = c.r;
	float g = c.g;
	float b = c.b;
	float cMin = min( r, min( g, b ) );
	float cMax = max( r, max( g, b ) );

	l = ( cMax + cMin ) / 2.0;
	if ( cMax > cMin ) {
		float cDelta = cMax - cMin;
        
        //s = l < .05 ? cDelta / ( cMax + cMin ) : cDelta / ( 2.0 - ( cMax + cMin ) ); Original
		s = l < .0 ? cDelta / ( cMax + cMin ) : cDelta / ( 2.0 - ( cMax + cMin ) );
        
		if ( r == cMax ) {
			h = ( g - b ) / cDelta;
		} else if ( g == cMax ) {
			h = 2.0 + ( b - r ) / cDelta;
		} else {
			h = 4.0 + ( r - g ) / cDelta;
		}

		if ( h < 0.0) {
			h += 6.0;
		}
		h = h / 6.0;
	}
	return vec3( h, s, l );
}

vec3 hsl2rgb(vec3 c )
{
    vec3 rgb = clamp( abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0, 1.0 );

    return c.z + c.y * (rgb-0.5)*(1.0-abs(2.0*c.z-1.0));
}

void main( )
{
    vec2 oUv = gl_FragCoord.xy /iResolution.xy;
    vec2 uv = (gl_FragCoord.xy *2.0 - iResolution.xy) /iResolution.y;    
    
    vec4 s = texture(iChannel1,oUv);
    
    float scale = 7.;
    vec3  p = vec3(uv*scale,iTime);
    float n = fbm(p,1.);
    
    float mag =  1.5;
    vec2 v = poltocar(n*mag,n*M_TWOPI)/iResolution.xy;
    oUv+=v;    

    
    float feedback = 0.923;
    vec4 t = texture(iChannel0,oUv);
    vec4 oT = t;
    t.rgb = rgb2hsl(t.rgb);
    //shift color
    t.rgb+=vec3(0.33,0.9,0.01);
    
    t.rgb = mix(hsl2rgb(t.rgb),oT.rgb,0.93);
   

    
    gl_FragColor = s+t*feedback;
}