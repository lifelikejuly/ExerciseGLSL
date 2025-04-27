#define MAX_STEPS 64
#define MAX_DIST  100.
#define SURF_DIST .01

mat2 rot(float a)
{
return mat2(
  cos(a), sin(a),
  -sin(a), cos(a)
  );
}

//from iq https://iquilezles.org/articles/distfunctions
float sdLink( vec3 p, float le, float r1, float r2 )
{
  vec3 q = vec3( p.x, max(abs(p.y)-le,0.0), p.z );
  return length(vec2(length(q.xy)-r1,q.z)) - r2;
}

float getDist(vec3 p){

  vec3 rotPos = p;
  rotPos.xz*=rot(-p.y*0.8+iTime);
  rotPos.x+=cos(p.x*1.  +iTime*0.5);
  rotPos.x+=cos(p.x*.5  +iTime*0.2);
  rotPos.x+=sin(p.x*.25 +iTime*0.1);

  rotPos = mix(rotPos,p,0.2+sin(iTime)*0.1);

  float shape = sdLink(rotPos,10.,p.y*0.2+1.,abs(sin(p.y+iTime)*0.05+0.01));
  shape*=0.5;

  return shape;
}

float rayMarch(vec3 ro, vec3 rd){
  float dO = 0.;
  float dS;

  for(int i = 0; i < MAX_STEPS; i++){
    vec3 p = ro + dO * rd;
    dS = getDist(p);
    dO += dS;
    //if(dS < 0.01 || dO > MAX_DIST) break; //slightly cheaper but with some artefacts
    if(abs(dS) < SURF_DIST || dO > MAX_DIST) break;
	
  }//for

  return dO;
}

vec3 getNormal(vec3 p){
  vec2 e = vec2(0.01, 0.);

  vec3 n = getDist(p) - vec3(
    getDist(p-e.xyy),
    getDist(p-e.yxy),
    getDist(p-e.yyx)
  );

  return normalize(n);
}


void main()
{    
    vec2 uv = gl_FragCoord.xy/iResolution.xy;    

    
    uv*=rot(iTime*0.334);
    
    vec3 ro = vec3(0.,0.,-3.);

      
    vec3 rd = normalize(vec3(uv,1.));

	float d = rayMarch(ro,rd);

    vec4 col = vec4(0.);
    
    if(d < MAX_DIST){

	  vec3 p = ro + rd *d;
	  vec3 n = getNormal(p);
			  
	  col.rgb = mix(vec3(0.5,0.3,0.),vec3(0.1,0.3,.3),n.z);

	}
    
    gl_FragColor = col;
}