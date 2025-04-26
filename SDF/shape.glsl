vec3 getBackgroundColor(vec2 uv) {
    vec3 gradientStartColor = vec3(1.0, 0.0, 0.0);
    vec3 gradientEndColor = vec3(0., 0., 1.);
    return mix(gradientStartColor, gradientEndColor, uv.y); 
}

float sdfCircle(vec2 uv, float r, vec2 offset) {
  float x = uv.x - offset.x;
  float y = uv.y - offset.y;
  return length(vec2(x, y)) - r;
}

float sdfSquare(vec2 uv, float size, vec2 offset) {
  float x = uv.x - offset.x;
  float y = uv.y - offset.y;
  return max(abs(x), abs(y)) - size;
}

void main() {
    vec2 uv = gl_FragCoord.xy / iResolution.xy;
    vec2 center = uv;
    center -= 0.5; 
    center.x *= iResolution.x/iResolution.y;
    // 背景
    vec3 background = getBackgroundColor(uv);
    // 圆
    float circle = sdfCircle(center, 0.1, vec2(0.));
    // 方形
    float square = sdfSquare(center, 0.1, vec2(0.2));
    //混合结果   
    vec3 col = mix(vec3(0., 0., 1.),background, step(0., circle));
    col = mix(vec3(1, 0, 0), col, step(0., square));
    gl_FragColor = vec4(col,1.0);
}
