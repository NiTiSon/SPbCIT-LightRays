class_name RayMath

static func deg_to_normvector2(deg: float) -> Vector2:
	var _sinus = sin(deg_to_rad(deg))
	var _cosinus = cos(deg_to_rad(deg))

	return Vector2(_sinus, _cosinus)

static func convert_other_environment(deg_a: float, relative_reflect_index: float) -> float:
	var sin_a = sin(deg_to_rad(deg_a)) # Get sinus of alpha
	
	var sin_b = sin_a / relative_reflect_index # Get sinus of betta
	
	return rad_to_deg(asin(sin_b)) # Get betta from it's sinus
