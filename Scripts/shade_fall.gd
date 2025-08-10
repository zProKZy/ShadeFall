extends Sprite2D

@export var float_speed := 2.0  # how fast it bounces
@export var float_height := 5.0  # how high it bounces

var original_position: Vector2

func _ready():
	original_position = position

func _process(delta):
	var y_offset = sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_height
	position.y = original_position.y + y_offset
