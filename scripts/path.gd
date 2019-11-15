extends Node2D


var points = PoolVector2Array([])
export(float) var radius = 20.0


func _ready():
	$'/root/Global'.connect('update_nodes', self, 'on_global_update_nodes')
	for point in get_children():
		add_point(point.global_position.x, point.global_position.y)
	hide()


func _draw():
	for point in get_children():
		draw_circle(point.position, 2.5, Color.black)
	for i in get_child_count()-1:
		draw_line(get_child(i).position, get_child(i+1).position, Color.black, 1.0, true)


func add_point(x, y):
	points.append(Vector2(x, y))


func get_normal_point(point, a, b):
	var ap = point - a
	var ab = b - a
	return a + ap.project(ab)


func get_target(point):
	var target = null
	var world_record = 1000000
	for i in points.size() - 1:
		var a = points[i]
		var b = points[i+1]
		var normal_point = get_normal_point(point, a, b)
		if normal_point.x < min(a.x, b.x) or normal_point.x > max(a.x, b.x):
			normal_point = b
		
		var distance = point.distance_to(normal_point)

		if distance < world_record:
			world_record = distance
			target = normal_point + (b-a).normalized() * 25
	
	return target


func on_global_update_nodes():
	visible = not visible
