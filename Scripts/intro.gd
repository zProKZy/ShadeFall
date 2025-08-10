extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("fade_in")
	await get_tree().create_timer(6.0).timeout
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
