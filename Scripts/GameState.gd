extends Node

signal leveled_up(new_level: int)
signal xp_changed

# var player_str := 5 # base
var pickaxe_dmg := 5
var axe_dmg := 5
var scythe_dmg := 5

var pickaxe_lvl := 1
var axe_lvl := 1
var scythe_lvl := 1

var axe_tier := 0
var pickaxe_tier := 0
var scythe_tier := 0

var coins := 0

var stone_count := 0
var branch_count := 0
var grass_count := 0

# Dictionary to hold HP of stones per scene or ID
var stone_health = {}
var tree_health = {}
var grass_health = {}

var player_xp := 0
var player_level := 0
var player_max_lv := 50
var xp_next_lv := 100

func add_xp(amount: int) -> void:
	if player_level >= player_max_lv:
		player_xp = xp_next_lv  # Optional: fill XP bar
		emit_signal("xp_changed") # <-- still emit to update bar
		return

	player_xp += amount
	emit_signal("xp_changed")  # <-- emit immediately after gain

	while player_xp >= xp_next_lv and player_level < player_max_lv:
		player_xp -= xp_next_lv
		player_level += 1
		axe_dmg += 2
		pickaxe_dmg += 2
		scythe_dmg += 1
		coins += 100
		emit_signal("leveled_up", player_level)
		emit_signal("xp_changed")  # <-- emit again after leveling up
		xp_next_lv = int(xp_next_lv * 1.5)
		print("Level up, ", player_level)

	if player_level == player_max_lv:
		player_xp = xp_next_lv  # Cap XP at max
		coins += 900
		emit_signal("xp_changed")  # <-- update for full bar at max


var scene_entry_cooldown = false
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("move_up"):
		#GameState.scene_entry_cooldown = true
		#get_tree().change_scene_to_file("res://Scenes/main_1.tscn")
	#elif Input.is_action_just_pressed("move_down"):
		#GameState.scene_entry_cooldown = true
		#get_tree().change_scene_to_file("res://Scenes/main_3.tscn")
	#elif Input.is_action_just_pressed("move_left"):
		#GameState.scene_entry_cooldown = true
		#get_tree().change_scene_to_file("res://Scenes/main_2.tscn")
	#elif Input.is_action_just_pressed("move_right"):
		#GameState.scene_entry_cooldown = true
		#get_tree().change_scene_to_file("res://Scenes/main_4.tscn")
