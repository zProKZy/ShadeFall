extends Area2D

@export var grass_id: String = "grass_1"
@export var max_hp := 30
var current_hp := max_hp
var can_click := true
var is_mouse_over := false
var is_mouse_held := false

@onready var collision = $CollisionShape2D
@onready var sprite = $AnimatedSprite2D
@onready var bush_collecting = $bush_collect
@onready var particles = $BreakParticles/CPU_particles
@onready var hp_bar = $HPBar
@onready var cooldown_hitting = $Cooldown_hitting
@onready var cooldown_respawn = $Cooldown_respawn
@onready var cooldown_entry = $Cooldown_entry

func _ready():
	GameState.leveled_up.connect(scale_hp)
	if GameState.grass_health.has(grass_id):
		current_hp = GameState.grass_health[grass_id]
	else:
		current_hp = max_hp

	if current_hp <= 0:
		break_grass()

	hp_bar.max_value = max_hp
	hp_bar.value = current_hp

	if GameState.scene_entry_cooldown:
		can_click = false
		cooldown_entry.start()
	else:
		can_click = true

func _process(_delta):
	if is_mouse_over and is_mouse_held and can_click:
		can_click = false
		cooldown_hitting.start()
		take_damage(GameState.scythe_dmg)
		bush_collecting.play()
		particles.global_position = get_global_mouse_position()
		particles.restart()

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and can_click:
			is_mouse_held = true
			can_click = false
			cooldown_hitting.start()
			take_damage(GameState.scythe_dmg)
			bush_collecting.play()
			particles.global_position = get_global_mouse_position()
			particles.restart()
		elif not event.pressed:
			is_mouse_held = false

func _handle_click():
	can_click = false
	cooldown_hitting.start()

	var click_position = get_global_mouse_position()
	particles.global_position = click_position
	particles.restart()
	bush_collecting.play()
	take_damage(GameState.scythe_dmg)

func take_damage(amount: int):
	current_hp -= amount
	GameState.grass_health[grass_id] = current_hp
	hp_bar.value = current_hp
	shake_pop()

	if current_hp <= 0:
		break_grass()

func break_grass():
	sprite.hide()
	hp_bar.hide()
	collision.disabled = true
	set_process_input(false)
	can_click = false

	particles.global_position = global_position
	particles.restart()

	var grass_drop = randi_range(1, 2)
	GameState.grass_count += grass_drop
	GameState.add_xp(5)
	scale_hp(GameState.player_level)

	await bush_collecting.finished
	cooldown_respawn.start()

func shake_pop():
	var original_position = sprite.position
	var tween = create_tween()
	tween.tween_property(sprite, "position", original_position + Vector2(2, 0), 0.03).as_relative()
	tween.tween_property(sprite, "position", original_position - Vector2(2, 0), 0.03).as_relative()
	tween.tween_property(sprite, "position", Vector2.ZERO, 0.03).as_relative()

func _on_cooldown_hitting_timeout() -> void:
	can_click = true

func _on_cooldown_respawn_timeout() -> void:
	current_hp = max_hp
	hp_bar.value = current_hp
	hp_bar.hide()
	sprite.show()
	collision.disabled = false
	set_process_input(true)
	can_click = true
	GameState.grass_health[grass_id] = max_hp

func _on_cooldown_entry_timeout() -> void:
	can_click = true
	GameState.scene_entry_cooldown = false

# Mouse over tracking
func _on_mouse_entered() -> void:
	is_mouse_over = true

func _on_mouse_exited() -> void:
	is_mouse_over = false
	is_mouse_held = false

func scale_hp(level: int):
	var new_max_hp = round(100 + (level - 1) * 1.5)
	var was_damaged = current_hp < max_hp
	max_hp = new_max_hp
	hp_bar.max_value = max_hp

	if not was_damaged:
		current_hp = max_hp
		hp_bar.value = max_hp
