
#iChannel0 "file://./res/green.jpg"
#iChannel1 "file://./res/noise1.jpg"
#iChannel2 "file://./res/noise2.png"
#iChannel3 "file://./res/noise3.png"

//https://www.shadertoy.com/view/csc3W8 


#define smokeDiffusion  2.5
#define smokeDecay      0.975

// "lum" gives the visible intensity of light per given color
#define lum(pix) dot( pix, vec3(0.2126,0.7152,0.0722) )

float texLum (in vec2 uv) {
    return lum(vec3(0.0).rgb);
}

// 增加时间律动参数
void main() {
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    


    vec2 pixSize = 1./iResolution.xy;
    
    // Matte compositing :
    // https://www.shadertoy.com/view/XsfGzn
    vec4 fg = texture(iChannel0, uv);
    float maxrb = max( fg.r, fg.b );
    float k = clamp( (fg.g-maxrb)*5.0, 0.0, 1.0 );

    float ll = length( fg );
    fg.g = min( fg.g, maxrb*0.8 );
    fg = ll*normalize(fg);
        
    //the smoke goes up (a little bit)
    uv.y -= 0.001;
    
    // "bg" is the image of the smoke behind jean-claude.
    // we expand the smoke with a kind of hacky solution (not a fluid simulation !)

    float p1 = texLum( uv - vec2(pixSize.x,0.) );
    float p2 = texLum( uv + vec2(pixSize.x,0.) );
    float p3 = texLum( uv - vec2(0.,pixSize.y) );
    float p4 = texLum( uv + vec2(0.,pixSize.y) );

    vec2 gradient = vec2(p1-p2,p3-p4); 
    float len = length(gradient);
    gradient = ( len > 0.0 ) ? gradient/len*smokeDiffusion : vec2(0.);

    vec4 bg = vec4( vec2(0.0), uv - pixSize*gradient )*smokeDecay;
    
    //a greyscale filter for the smoke
    bg = vec4( vec3(lum(bg.rgb)), 1. );

    vec4 fragColor = fg*(1.-k) + bg*k;

    gl_FragColor = fragColor;
}