#iChannel0 "file://self"
#define BOUNCE_GROUND 0.5
#define BOUNCE 0.2
#define MAX_SPEED 800.0
#define GRAVITY vec2(0.0, -5.0)
#define ATTRACTION 60.0


// Random function from https://www.shadertoy.com/view/4ssXRX
// note: uniformly distributed, normalized rand, [0;1[
float nrand( vec2 n )
{
	return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 pixelSize = 1.0 / iResolution.xy;
    
    // Initialize the texture on the first frame with random positions and null velocity.
    if (iFrame == 1)
    {
		fragColor = vec4(vec2(nrand(uv), nrand(uv.yx)), 0.0 , 0.0);
        return;
    }
    
    // The texture stores the particle position in xy and the velocity in zw.
    vec4 previousFrameValues = texture2D(iChannel0, uv);
    vec2 position = previousFrameValues.xy;
    vec2 velocity = previousFrameValues.zw;
 
    // Gravity.
    velocity += GRAVITY;
    
    //Mouse attraction.
    if (iMouse.w>0.01)
    {
    	vec2 attractionVector = (iMouse.xy/iResolution.xy) - position;
    	velocity += ATTRACTION * (normalize(attractionVector));
    }
    
    float randValue = nrand(uv.yx * iTime) * 0.5;
    
    // Collisions
    if (position.x < 0.0)
    {	
        velocity = vec2(abs(velocity.x) * (BOUNCE+randValue), velocity.y);
    }

    if (position.x > 1.0)
    {	
        velocity = vec2(-abs(velocity.x) * (BOUNCE+randValue), velocity.y);
    }

    if (position.y < 0.0)
    {
        velocity = vec2(velocity.x, abs(velocity.y) * (BOUNCE_GROUND+randValue));
    }

    if (position.y > 1.0)
    {
        velocity = vec2(velocity.x, -abs(velocity.y) * (BOUNCE+randValue));
    }
    
    // Update position.
    position.xy += velocity * iTimeDelta * 0.001;
    
    if ( length(velocity) > MAX_SPEED)
        velocity = normalize(velocity) * MAX_SPEED;
    
    
    fragColor = vec4(position.xy, velocity.xy);
}