extends Area2D

@onready var campfire_animate = $AnimatedSprite2D
@onready var fire_whoosh = $Fire_whoosh
@onready var light = $PointLight2D
@onready var level_up_text = $level_up
@onready var require_cost = $require

var campfire_level = 0
var max_level := 10
var branches_required := [5, 25, 125, 312, 780, 1950, 2440, 3050, 3810, 9530] # 1 to 10
var upgrade_range := 50.0  # Pixels from center of campfire

func _ready() -> void:
	# update_animation()
	campfire_animate.play()
	start_flicker()
	level_up_text.visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if is_mouse_near():
			try_upgrade()

func start_flicker():
	var tween = create_tween()
	var new_energy = randf_range(0.5, 0.7)
	tween.tween_property(light, "energy", new_energy, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", Callable(self, "start_flicker"))

func is_mouse_near() -> bool:
	var mouse_pos = get_global_mouse_position()
	return global_position.distance_to(mouse_pos) <= upgrade_range

func try_upgrade():
	if campfire_level < max_level:
		var cost = branches_required[campfire_level]
		if GameState.branch_count >= cost:
			GameState.branch_count -= cost
			show_upgrade_popup("LEVEL %d!" % campfire_level)
			campfire_level += 1
			GameState.add_xp(5)
			fire_whoosh.play()
			# update_animation()
			# print("🔥 Campfire upgraded to level %d!" % campfire_level)
		else:
			show_require_popup("Need %d brnachs!" % cost)
	else:
		show_require_popup("Max level!")

func show_upgrade_popup(text: String) -> void:
	level_up_text.text = text
	level_up_text.visible = true
	level_up_text.modulate.a = 0.0
	
	await fade_label(level_up_text, true, 0.2) # fade in
	await get_tree().create_timer(1.0).timeout # wait for 1 sec
	await fade_label(level_up_text, false, 0.2) # fade out

func show_require_popup(text: String) -> void:
	require_cost.text = text
	require_cost.visible = true
	require_cost.modulate.a = 0.0

	await fade_label(require_cost, true, 0.2) # fade in
	await get_tree().create_timer(1.0).timeout
	await fade_label(require_cost, false, 0.2) # fade out

func fade_label(label: Label, fade_in: bool, duration: float) -> void:
	var elapsed := 0.0
	while elapsed < duration:
		var t := elapsed / duration
		var alpha: float
		if fade_in:
			alpha = t
		else:
			alpha = 1.0 - t
		var current_color := label.modulate
		current_color.a = alpha
		label.modulate = current_color
		await get_tree().process_frame
		elapsed += get_process_delta_time()

	var final_color := label.modulate
	if fade_in:
		final_color.a = 1.0
	else:
		final_color.a = 0.0
	label.modulate = final_color

func update_animation():
	match campfire_level:
		# add more animation later
		1: campfire_animate.play("default")
		2: campfire_animate.play("default")
		3: campfire_animate.play("default")
