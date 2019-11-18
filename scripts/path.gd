extends Node2D


var point_count
var points = PoolVector2Array()
export(float) var radius = 20.0
export(bool) var cyclic = false

var total_path_length
var normals
var lengths
var segment_length
var segment_projection
var segment_normal
var local
var chosen


func _ready():
	point_count = get_children().size()
	total_path_length = 0.0
	lengths = PoolRealArray()
	points = PoolVector2Array()
	normals = PoolVector2Array()
	normals.append(Vector2.ZERO)
	lengths.append(0.0)

	for point in get_children():
		add_point(point.global_position.x, point.global_position.y)
	if cyclic:
		point_count += 1
		points.append(points[0])

	for i in range(point_count):
		#var close_cycle = cyclic and i == point_count - 1
		#var j
		#if close_cycle:
		#	j = 0
		#else:
		#	j = i
		#points[i] = points[j]

		if i > 0:
			normals.append(Vector2.ZERO)
			normals[i] = points[i] - points[i-1]
			lengths.append(0.0)
			lengths[i] = normals[i].length()

			normals[i] *= 1 / lengths[i]

			total_path_length += lengths[i]
	
	hide()
	$'/root/Global'.connect('update_nodes', self, '_on_global_update_nodes')


func _draw():
	for point in points:
		draw_circle(point, 2.5, Color.black)
	for i in point_count-1:
		draw_line(points[i], points[i+1], Color.black, 1.0, true)


func add_point(x, y):
	points.append(Vector2(x, y))


func _on_global_update_nodes():
	visible = not visible


func map_point_to_path(point):
	var d
	var min_distance = 9999999.0
	var on_path
	var tangent
	var outside

	for i in range(1, point_count):
		segment_length = lengths[i]
		segment_normal = normals[i]
		d = point_to_segment_distance(point, points[i-1], points[i])
		if d < min_distance:
			min_distance = d
			on_path = chosen
			tangent = segment_normal
	
	outside = on_path.distance_to(point) - radius
	return [on_path, tangent, outside]


func map_point_to_path_distance(point) -> float:
	var d
	var min_distance = 9999999.0
	var segment_length_total = 0.0
	var path_distance = 0.0

	for i in range(1, point_count):
		segment_length = lengths[i]
		segment_normal = normals[i]
		d = point_to_segment_distance(point, points[i-1], points[i])
		if d < min_distance:
			min_distance = d
			path_distance = segment_length_total + segment_projection
		segment_length_total += segment_length

	return path_distance
	

func map_path_distance_to_point(path_distance) -> Vector2:
	var remaining = path_distance
	if cyclic:
		remaining = fmod(path_distance, total_path_length)
	else:
		if path_distance < 0:
			return points[0]
		if path_distance >= total_path_length:
			return points[point_count-1]
	
	var result = Vector2.ZERO
	for i in range(1, point_count):
		segment_length = lengths[i]
		if segment_length < remaining:
			remaining -= segment_length
		else:
			var ratio = remaining / segment_length
			result = points[i-1].linear_interpolate(points[i], ratio)
			break
	return result


func point_to_segment_distance(point, ep0, ep1) -> float:
	local = point - ep0
	segment_projection = segment_normal.dot(local)

	if segment_projection < 0:
		chosen = ep0
		segment_projection = 0
		return point.distance_to(ep0)
	if segment_projection > segment_length:
		chosen = ep1
		segment_projection = segment_length
		return point.distance_to(ep1)

	chosen = segment_normal * segment_projection
	chosen += ep0
	return point.distance_to(chosen)