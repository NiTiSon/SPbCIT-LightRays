extends Node2D

const ray_length: float = 430

var _deg: float = 30
var _n1: float = 1
var _n2: float = 1
var _n21: float = 1
var _deg_betta: float = 30
var _ignore_update_slct: bool = false

# All ouf them normalized
var _cache_vec_alpha: Vector2
var _cache_vec_gamma: Vector2
var _cache_vec_betta: Vector2


var _n_values = [0, 1.0, 1.003, 1.33, 1.36, 1.5, 1.54] # Cached values bounded with "Slct" boxies

func _ready():
	_update_state()
	pass

func _process(delta):
	queue_redraw()
	pass

func _draw():
	_draw_markup()
	_draw_alpha()
	_draw_betta()
	_draw_gamma()


func _draw_alpha():
	draw_line(Vector2(0, 0), _normalize(_cache_vec_alpha, ray_length), Color.WHITE, 2)

func _draw_gamma():
	
	draw_dashed_line(Vector2(0, 0), _normalize(_cache_vec_gamma, ray_length), Color.from_hsv(0, 0, 1, 0.5), 2, 10)
	
func _draw_betta():

	if floor(_cache_vec_betta.x) < 0.96:
		draw_line(Vector2(0, 0), _normalize(_cache_vec_betta, ray_length), Color.YELLOW, 2)

func _draw_markup():
	draw_line(Vector2(2000, 0), Vector2(-2000, 0), Color.RED)
	draw_dashed_line(Vector2(0, 2000), Vector2(0, -2000), Color.GREEN, 1, 5)
	# draw_outline_curcle(Vector2(0,0), Vector2(ray_length, ray_length), Color.BLUE_VIOLET, 1) 

func _update_state():
	var alpha: float
	var betta: float
	var gamma: float
	
	alpha = deg_to_rad(_deg)
	
	var sin_alpha = sin(alpha)
	
	_n21 = _n2 / _n1
	
	var sin_betta = sin_alpha * _n1 / _n2
	
	betta = asin(sin_betta)
	
	gamma = alpha
	
	_deg_betta = rad_to_deg(betta)
	
	_cache_vec_alpha = RayMath.deg_to_normvector2(_deg + 180)
	
	_cache_vec_gamma = RayMath.deg_to_normvector2(180 - rad_to_deg(gamma))
	
	_cache_vec_betta = RayMath.deg_to_normvector2(_deg_betta)
	
	var text: RichTextLabel 
	
	text = get_node("Control/Control/HBoxContainer/VBoxContainer/RichTextLabel")
	
	text.text = str("sin(α) = ", sin_alpha, "\nsin(β) = ", sin_betta, \
		"\nn₁ = ", _n1, "\nn₂ = ", _n2, \
		"\nn₂₁ = ", _n21, \
		)
	
	# Debug
	print(_cache_vec_alpha, _cache_vec_betta, _cache_vec_gamma)
	print("====== Update state ======")

func draw_outline_curcle(circle_center: Vector2, circle_radius: Vector2, color: Color, resolution: int):
	var draw_counter = 1
	var line_origin = Vector2()
	var line_end = Vector2()
	line_origin = circle_radius + circle_center

	while draw_counter <= 360:
		line_end = circle_radius.rotated(deg_to_rad(draw_counter)) + circle_center
		draw_line(line_origin, line_end, color)
		draw_counter += 1 / resolution
		line_origin = line_end

	line_end = circle_radius.rotated(deg_to_rad(360)) + circle_center
	draw_line(line_origin, line_end, color)


func _on_angle_box_value_changed(value: float):
	_deg = value
	_update_state()

func _on_spin_box_value_changed(value: float, extra_arg: int):
	var x: OptionButton
	
	match extra_arg:
		1: 
			_n1 = value
			x = get_node("Control/HBoxContainer/VBoxContainer/_1/Slct")
		2:
			_n2 = value
			x = get_node("Control/HBoxContainer/VBoxContainer/_2/Slct")
		_: print("Invalid argument 'extra_arg'")
	
	if (!_ignore_update_slct):
		x.select(0)
	
	_update_state()

func _on_slct_item_selected(index: int, extra_arg: int):
	var x: SpinBox
	var value: float = _n_values[index]
	
	match extra_arg:
		1: 
			_n1 = value
			x = get_node("Control/HBoxContainer/VBoxContainer/_1/SpinBox")
		2:
			_n2 = value
			x = get_node("Control/HBoxContainer/VBoxContainer/_2/SpinBox")
		_: print("Invalid argument 'extra_arg'")
	
	x.value = value
	_ignore_update_slct = true
	
	_update_state()

func _normalize(vec: Vector2, r: float) -> Vector2:
	var len = vec.length()
	vec.x = vec.x / len * r
	vec.y = vec.y / len * r
	return vec
