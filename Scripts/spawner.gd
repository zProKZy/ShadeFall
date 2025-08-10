extends Node

@export var stone_scene: PackedScene
@export var tree_scene: PackedScene

func _ready():
	for spawn_point in get_tree().get_nodes_in_group("spawn_points"):
		var scene: PackedScene
		match spawn_point.type:
			"stone":
				scene = stone_scene
			"tree":
				scene = tree_scene
			_:
				continue

		var instance = scene.instantiate()
		instance.global_position = spawn_point.global_position
		spawn_point.get_parent().add_child(instance)
