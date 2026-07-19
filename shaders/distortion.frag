#ifdef GL_ES
precision mediump float;
#endif

uniform float iTime;
uniform vec2 openfl_TextureSize;
uniform sampler2D bitmap;
varying vec2 openfl_TextureCoordv;

uniform bool vignetteOn;
uniform bool perspectiveOn;
uniform bool distortionOn;
uniform bool scanlinesOn;
uniform bool vignetteMoving;
uniform float glitchModifier;

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float onOff(float a, float b, float c) {
    return step(c, sin(iTime + a * cos(iTime * b)));
}

vec4 getVideo(vec2 uv) {
    vec2 look = uv;
    if(distortionOn) {
        float window = 1.0 / (1.0 + 20.0 * (look.y - mod(iTime / 4.0, 1.0)) * (look.y - mod(iTime / 4.0, 1.0)));
        look.x = look.x + (sin(look.y * 10.0 + iTime) / 50.0 * onOff(4.0, 4.0, 0.3) * (1.0 + cos(iTime * 80.0)) * window) * (glitchModifier * 2.0);
        float vShift = 0.4 * onOff(2.0, 3.0, 0.9) * (sin(iTime) * sin(iTime * 20.0) + (0.5 + 0.1 * sin(iTime * 200.0) * cos(iTime)));
        look.y = mod(look.y + vShift * glitchModifier, 1.0);
    }
    return texture2D(bitmap, look);
}

void main() {
    vec2 uv = openfl_TextureCoordv;

    vec2 curUV = uv;
    if(perspectiveOn) {
        curUV = (uv - 0.5) * 2.0;
        curUV *= 1.1;
        curUV.x *= 1.0 + pow((abs(curUV.y) / 5.0), 2.0);
        curUV.y *= 1.0 + pow((abs(curUV.x) / 4.0), 2.0);
        curUV = (curUV / 2.0) + 0.5;
        curUV = curUV * 0.92 + 0.04;
    }

    // Chromatic aberration mas fuerte cerca de los bordes
    float edgeDist = length(curUV - 0.5);
    float aberration = 0.0015 + edgeDist * 0.004;
    float rgbGlitch = 1.0 + glitchModifier * 3.0;

    vec4 video = getVideo(curUV);
    video.r = getVideo(vec2(curUV.x + aberration * rgbGlitch, curUV.y)).r;
    video.g = getVideo(vec2(curUV.x, curUV.y - aberration * 0.5 * rgbGlitch)).g;
    video.b = getVideo(vec2(curUV.x - aberration * rgbGlitch, curUV.y)).b;

    // Scanlines horizontales
    if(scanlinesOn) {
        float scanline = sin(curUV.y * openfl_TextureSize.y * 1.4 - iTime * 40.0) * 0.5 + 0.5;
        video.rgb *= 0.85 + 0.15 * scanline;

        // Roll bar ocasional
        float rollSpeed = 0.15;
        float rollPos = mod(iTime * rollSpeed, 1.5) - 0.25;
        float rollBar = smoothstep(0.0, 0.05, abs(curUV.y - rollPos)) ;
        rollBar = 1.0 - (1.0 - rollBar) * onOff(1.0, 3.0, 0.7) * glitchModifier;
        video.rgb *= rollBar;
    }

    // Ruido estatico tipo TV
    float noise = rand(curUV * iTime * 0.001 + iTime);
    float noiseAmt = 0.04 + glitchModifier * 0.15;
    video.rgb += (noise - 0.5) * noiseAmt;

    // Flicker de brillo general
    float flicker = 1.0 + 0.03 * sin(iTime * 50.0) * onOff(3.0, 6.0, 0.85);
    video.rgb *= flicker;

    // Vignette con curvatura tipo tubo
    float vigAmt = vignetteMoving ? (3.0 + 0.3 * sin(iTime + 5.0 * cos(iTime * 5.0))) : 1.0;
    float vignette = (1.0 - vigAmt * (curUV.y - 0.5) * (curUV.y - 0.5)) * (1.0 - vigAmt * (curUV.x - 0.5) * (curUV.x - 0.5));
    if(vignetteOn) video.rgb *= vignette;

    // Bordes negros duros del tubo (fuera del area visible)
    if(perspectiveOn) {
        float edgeFade = smoothstep(0.0, 0.02, curUV.x) * smoothstep(1.0, 0.98, curUV.x)
                        * smoothstep(0.0, 0.02, curUV.y) * smoothstep(1.0, 0.98, curUV.y);
        video.rgb *= edgeFade;
    }

    video.a = texture2D(bitmap, openfl_TextureCoordv).a;
    gl_FragColor = video;
}