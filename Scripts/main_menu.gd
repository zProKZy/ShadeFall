extends Control

@onready var cut_in = $fade_cut_scene/AnimationPlayer
@onready var fade = $fade_cut_scene
@onready var setting_gui = $Settings

func _ready() -> void:
	cut_in.play("fade_in")
	await get_tree().create_timer(4.0).timeout
	fade.visible = false

func _on_start_pressed() -> void:
	fade.visible = true
	cut_in.play("fade_out")
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://Scenes/main_1.tscn")

func _on_exit_pressed() -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()
