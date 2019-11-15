extends Node2D


var points = PoolVector2Array([])
export(float) var radius = 10.0


func _process(_delta):
	update()


func add_point(x, y):
	points.append(Vector2(x, y))


func get_normal_point(point, a, b):
	var ap = point - a
	var ab = b - a
	return a + ap.project(ab)


func get_target(point):
	var target = null
	var world_record = 1000000
	for i in points.size():
		var a = points[i]
		var b = points[i+1]
		var normal_point = get_normal_point(point, a, b)
		if normal_point.x < a.x or normal_point.x > b.x:
			normal_point = b
		
		var distance = point.distance_to(normal_point)

		if distance < world_record:
			world_record = distance
			target = normal_point
	
	return target