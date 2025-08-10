extends Control

@onready var settings : Panel = $Panel
@onready var god_rays = $"../God_rays"
func _ready() -> void:
	settings.visible = false

func _on_back_pressed() -> void:
	settings.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		if settings.visible:
			settings.visible = false
		else:
			settings.visible = true

func _on_exit_game_pressed() -> void:
	get_tree().quit()
