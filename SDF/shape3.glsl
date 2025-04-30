


void main(){

    float t = sin(iTime * 1.0);
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(uv, center);
    float radius = fract(iTime * 0.2) * 0.5;
    float fade = 1.0 - smoothstep(radius - 0.05, radius + 0.05, dist);
    vec4 c = vec4(1.0, 1.0, 0.0, fade);
    gl_FragColor = c;
}