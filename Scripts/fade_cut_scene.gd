extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("fade_in")
	await get_tree().create_timer(3.0).timeout
	
	#$AnimationPlayer.play("fade_out")
	#await get_tree().create_timer(3.0).timeout
