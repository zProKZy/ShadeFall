extends Node2D

@onready var rain_particles = $GPUParticles2D
@onready var rain_sound = $RainSound
@onready var rain_timer = $RainTimer
@onready var rain_duration = $RainDuration

@export var rain_chance := 0.3  # 30% chance to rain
@export var cooldown_time := 600.0  # 10 minutes
@export var rain_min_duration := 60.0  # seconds
@export var rain_max_duration := 120.0

var rain_tween: Tween = null

func _ready():
	rain_particles.emitting = false
	rain_sound.stop()
	rain_sound.volume_db = -80  # Start silent

	rain_timer.wait_time = cooldown_time
	rain_timer.start()

func _on_rain_timer_timeout():
	if randf() <= rain_chance:
		start_rain()
	else:
		rain_timer.start()

func start_rain():
	rain_particles.emitting = true
	rain_sound.play()

	# Fade in rain sound
	if rain_tween:
		rain_tween.kill()
	rain_tween = create_tween()
	rain_tween.tween_property(rain_sound, "volume_db", -10, 5.0)  # Fade in over 5 seconds

	var rain_time = randf_range(rain_min_duration, rain_max_duration)
	rain_duration.wait_time = rain_time
	rain_duration.start()

func _on_rain_duration_timeout():
	stop_rain()

func stop_rain():
	rain_particles.emitting = false

	# Fade out rain sound
	if rain_tween:
		rain_tween.kill()
	rain_tween = create_tween()
	rain_tween.tween_property(rain_sound, "volume_db", -80, 5.0)
	rain_tween.tween_callback(Callable(self, "_on_rain_fade_done"))

func _on_rain_fade_done():
	rain_sound.stop()
	rain_sound.volume_db = -80  # Reset volume
