// #iChannel0 "file:///Volumes/JulyStudio/AllProjects/GLSL/Stroker/s909_1306.png"
#iChannel0 "file:///Volumes/JulyKit/AllProjects/ExerciseGLSL/Stroker/s909_1306.png"

void main(){


     vec2 uv = gl_FragCoord.xy / iResolution.xy;
     vec4 color = texture(iChannel0,uv);
     gl_FragColor = color;
}