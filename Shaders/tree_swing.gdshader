shader_type canvas_item;
render_mode blend_mix;

// Wind settings
uniform float speed = 1.0;
uniform float minStrength : hint_range(0.0, 1.0) = 0.05;
uniform float maxStrength : hint_range(0.0, 1.0) = 0.01;
uniform float strengthScale = 100.0;
uniform float interval = 3.5;
uniform float detail = 1.0;
uniform float distortion : hint_range(0.0, 1.0);
uniform float heightOffset : hint_range(0.0, 1.0);
uniform float offset = 0.0;

float getWind(vec2 vertex, vec2 uv, float time) {
    float diff = pow(maxStrength - minStrength, 2.0);
    float strength = clamp(minStrength + diff + sin(time / interval) * diff, minStrength, maxStrength) * strengthScale;

    // Smooth fade from 0 at base (UV.y == 0) to 1 at top (UV.y == 1)
    float vertical_fade = smoothstep(heightOffset, 1.0, uv.y);

    float wind = (sin(time) + cos(time * detail)) * strength * vertical_fade;
    return wind;
}

void vertex() {
    float time = TIME * speed + offset;
    VERTEX.x += getWind(VERTEX.xy, UV, time);
}
