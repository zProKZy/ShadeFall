extends CanvasModulate

@export var day_duration_sec := 1200.0  # 20 minutes = 1200 seconds
@onready var fireflies = $"../FireFlies"
@onready var birds_sfx = $"../bird_sfx"
#@onready var god_rays = $"../God_rays"

var cycle_time := 0.0
var bird_playing := false
var bird_tween: Tween = null
#var god_rays_tween: Tween = null
#var god_rays_auto_enabled := true

func _ready():
	pass
	## Make god rays not block mouse input
	#if god_rays.has_method("set_mouse_filter"):
		#god_rays.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#elif god_rays.has_method("set_pickable"):
		#god_rays.set_pickable(false)
#
	## Start with god rays invisible
	#god_rays.visible = false
	#god_rays.modulate.a = 0.0

func _process(delta: float) -> void:
	cycle_time += delta
	if cycle_time > day_duration_sec:
		cycle_time = 0.0
	var current_frame = remap(cycle_time, 0.0, day_duration_sec, 0.0, 24.0)

	# Fireflies at night
	if (current_frame >= 18.0 or current_frame <= 6.0) and GameState.player_level >= 5:
		if not fireflies.visible:
			fireflies.visible = true
		#fade_in_god_rays()
	else:
		if fireflies.visible:
			fireflies.visible = false
		#fade_out_god_rays()

	# Bird sound: 6 AM to 10 AM
	if current_frame >= 6.0 and current_frame < 10.0:
		if not bird_playing:
			birds_sfx.volume_db = -20
			birds_sfx.play()
			bird_playing = true
	else:
		if bird_playing:
			if bird_tween:
				bird_tween.kill()
			bird_tween = create_tween()
			bird_tween.tween_property(birds_sfx, "volume_db", -80, 10.0)
			bird_tween.tween_callback(Callable(self, "_on_bird_fade_done"))
			bird_playing = false

	# Animate the day/night cycle
	$AnimationPlayer.play("day_night_cycle")
	$AnimationPlayer.seek(current_frame, true)
	
	#if god_rays_auto_enabled:
		#if (current_frame >= 18.0 or current_frame <= 6.0) and GameState.player_level >= 5:
			#fade_in_god_rays()
		#else:
			#fade_out_god_rays()
	#else:
		#fade_out_god_rays()

func _on_bird_fade_done():
	birds_sfx.stop()
	birds_sfx.volume_db = 0

#func fade_in_god_rays():
	#if god_rays_tween:
		#god_rays_tween.kill()
	#god_rays.visible = true
	#god_rays_tween = create_tween()
	#var color = god_rays.modulate
	#color.a = 1.0
	#god_rays_tween.tween_property(god_rays, "modulate", color, 2.0)
#
#func fade_out_god_rays():
	#if god_rays_tween:
		#god_rays_tween.kill()
	#god_rays_tween = create_tween()
	#var color = god_rays.modulate
	#color.a = 0.0
	#god_rays_tween.tween_property(god_rays, "modulate", color, 2.0)
	#god_rays_tween.tween_callback(Callable(self, "_on_god_rays_hidden"))
#
#func _on_god_rays_hidden():
	##if god_rays.modulate.a <= 0.01:
	#god_rays.visible = false

func _input(event):
	if event.is_action_pressed("inventory"):
		cycle_time += 60.0  # Skip 1 in-game hour
