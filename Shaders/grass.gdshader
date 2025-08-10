shader_type canvas_item;
render_mode blend_mix;

// Subtle wind settings.
uniform float speed : hint_range(0.0, 2.0) = 0.15;
uniform float strength : hint_range(0.0, 5.0) = 0.5; // Very subtle sway
uniform float frequency = 1.5;
uniform float heightFade : hint_range(0.0, 1.0) = 0.2;

void vertex() {
    float time = TIME * speed;
    
    // Wind based on UV.y — less movement at the bottom
    float sway = sin(time + UV.x * frequency) * strength * (1.0 - UV.y) * heightFade;

    VERTEX.x += sway;
}
