extends Area2D

@export var stone_id: String = "stone_1"
@export var max_hp := 100
var current_hp := max_hp
var can_click := true
var is_mouse_over := false
var is_mouse_held := false

@onready var collision = $CollisionShape2D
@onready var sprite = $AnimatedSprite2D
@onready var rock_hitting = $RockHitting
@onready var rock_destroyed = $RockDestroyed
@onready var particles = $BreakParticles/CPU_particles
@onready var hp_bar = $HPBar
@onready var cooldown_hitting = $Cooldown_hitting
@onready var cooldown_respawn = $Cooldown_respawn

func _ready():
	GameState.leveled_up.connect(scale_hp)
	if GameState.stone_health.has(stone_id):
		current_hp = GameState.stone_health[stone_id]
	else:
		current_hp = max_hp
		if current_hp <= 0:
			break_stone()

	hp_bar.max_value = max_hp
	hp_bar.value = current_hp

	if GameState.scene_entry_cooldown:
		can_click = false
		$Cooldown_entry.start()
	else:
		can_click = true

func _process(_delta):
	if is_mouse_over and is_mouse_held and can_click:
		can_click = false
		cooldown_hitting.start()
		take_damage(GameState.pickaxe_dmg)
		rock_hitting.play()
		particles.global_position = get_global_mouse_position()
		particles.restart()

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and can_click:
			is_mouse_held = true
			can_click = false
			cooldown_hitting.start()
			take_damage(GameState.pickaxe_dmg)
			rock_hitting.play()
			particles.global_position = get_global_mouse_position()
			particles.restart()
		elif not event.pressed:
			is_mouse_held = false

func _on_mouse_entered():
	is_mouse_over = true

func _on_mouse_exited():
	is_mouse_over = false
	is_mouse_held = false

func take_damage(amount):
	current_hp -= amount
	GameState.stone_health[stone_id] = current_hp
	hp_bar.value = current_hp
	zoom_pop()
	print(current_hp)

	if current_hp <= 0:
		break_stone()

func break_stone():
	rock_destroyed.play()
	sprite.hide()
	hp_bar.hide()
	collision.disabled = true
	set_process_input(false)
	can_click = false
	particles.global_position = global_position
	particles.restart()
	GameState.stone_count += randi_range(1, 3)
	GameState.add_xp(15)
	scale_hp(GameState.player_level)

	await rock_destroyed.finished
	cooldown_respawn.start()

func zoom_pop():
	sprite.scale = Vector2.ONE
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.2, 1.2), 0.05)
	tween.tween_property(sprite, "scale", Vector2.ONE, 0.1)

func _on_cooldown_timeout():
	can_click = true

func _on_cooldown_respawn_timeout():
	current_hp = max_hp
	hp_bar.value = current_hp
	hp_bar.hide()
	sprite.show()
	collision.disabled = false
	set_process_input(true)
	can_click = true

func _on_cooldown_entry_timeout():
	can_click = true
	GameState.scene_entry_cooldown = false

func scale_hp(level: int):
	var new_max_hp = round(100 + (level - 1) * 1.5)
	var was_damaged = current_hp < max_hp
	max_hp = new_max_hp
	hp_bar.max_value = max_hp

	if not was_damaged:
		current_hp = max_hp
		hp_bar.value = max_hp
