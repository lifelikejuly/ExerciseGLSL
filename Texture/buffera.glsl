
#iChannel0 "file://./res/640_640.jpg"
#iChannel1 "self"

// 帧模糊运动

float num = 0.0;

void main() {

    vec2 uv = gl_FragCoord.xy / iResolution.xy;

    uv.x -= sin(iTime) * 0.015;
    uv.y -= cos(iTime) * 0.015;
    vec4 col1 = texture(iChannel0,uv);


    // vec2 moveUv = uv;
    // moveUv.x -= sin(iTime) * 0.015;
    // moveUv.y -= sin(iTime) * 0.015;
    // moveUv.x *= 1.5;
    // moveUv.y *= 1.5;
    vec4 col2 = texture(iChannel1,uv);
    col2.a = 0.01;
    vec4 mixCol =vec4(mix(col1.xyz,col2.xyz,0.5),1.0);
     gl_FragColor = mixCol;
    // num +=1.0;
    // float n = mod(num , 3.0);
    // if(n == 2.0 || n == 0.0){
    //     gl_FragColor = mixCol;
    // }else{
    //     gl_FragColor = col1;
    // }
    

}