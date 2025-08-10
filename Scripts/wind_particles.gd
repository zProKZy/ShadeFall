extends Line2D

var pf_dict = []
var use_gradient = false
var custom_gradient := Gradient.new()

@export var reverse_direction = false
@export var line_segments = 20
@export var trail_length = 1.0
@export var trail_speed = 0.001
@export var trail_color_gradient: Gradient
@export var random_y_offset = 0.0
@export var wind_amplitude := 10.0
@export var wind_frequency := 2.0
@export var wind_speed := 1.0

func _ready():
	if reverse_direction:
		flip_path()

	if random_y_offset > 0.0:
		randomize_path()

	init_path_followers()

	if trail_color_gradient != null:
		if gradient == null:
			gradient = Gradient.new()
		use_gradient = true


func _process(delta):
	move_path()

	if use_gradient:
		update_path_gradient()

	draw_path()

func flip_path():
	var point_pos = []
	var point_in = []
	var point_out = []
	var curve_points = $Path2D.curve.point_count

	for idx in range(curve_points):
		point_pos.append($Path2D.curve.get_point_position(idx))
		point_in.append($Path2D.curve.get_point_in(idx))
		point_out.append($Path2D.curve.get_point_out(idx))

	$Path2D.curve.clear_points()

	for idx in range(curve_points - 1, -1, -1):
		$Path2D.curve.add_point(point_pos[idx], -point_in[idx], -point_out[idx])

func move_path():
	for pf in pf_dict:
		pf.progress_ratio += trail_speed
		if pf.progress_ratio > 1.0:
			pf.progress_ratio = 0.0

func update_path_gradient():
	for pcnt in range(line_segments + 1):
		var base_color = trail_color_gradient.sample(custom_gradient.offsets[pcnt])
		var alpha_color = trail_color_gradient.sample(pf_dict[pcnt].trail_offset)
		base_color.a *= alpha_color.a
		custom_gradient.colors[pcnt] = base_color

func randomize_path():
	randomize()
	for i in range($Path2D.curve.point_count):
		var curve_point = $Path2D.curve.get_point_position(i)
		curve_point.y += randf_range(-random_y_offset, random_y_offset)
		$Path2D.curve.set_point_position(i, curve_point)

func draw_path():
	clear_points()
	var time = Time.get_ticks_msec() / 1000.0 * wind_speed

	for i in range(pf_dict.size()):
		var pf = pf_dict[i]
		var pos = pf.global_position
		pos.x += sin(time * wind_frequency + i) * wind_amplitude
		add_point(pos)

func init_path_followers():
	custom_gradient = Gradient.new()

	# Proper way to clear all points
	while custom_gradient.get_point_count() > 0:
		custom_gradient.remove_point(0)

	for g_cnt in range(line_segments):
		custom_gradient.add_point(float(g_cnt + 1) / float(line_segments), Color(1.0, 1.0, 1.0, 1.0))
