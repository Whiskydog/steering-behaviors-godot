tool
extends StaticBody2D


export(float) var radius = 10.0


func _ready():
	if not Engine.editor_hint:
		$'Collider'.set_shape(CircleShape2D.new())
		$'Collider'.shape.set_radius(radius)


func _process(_delta):
	if Engine.editor_hint:
		update()


func _draw():
	draw_smooth_circle(Color.black)


#func draw_smooth_circle(_radius, color, max_error = .25):
#	if _radius <= 0.0:
#		return
#
#	var max_points = 32
#	
#	var num_points = ceil(PI / acos(1.0 - max_error / _radius))
#	num_points = clamp(num_points, 3, max_points)
#
#	var points = PoolVector2Array([])
#
#	for i in num_points:
#		var phi = i * PI*2 / num_points
#		var v = Vector2(sin(phi), cos(phi))
#		points.push_back(v * _radius)
#
#	draw_colored_polygon(points, color, PoolVector2Array(), null, null, true)


func draw_smooth_circle(color):
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		#var angle_point = -PI*2 + i * (-PI*2 - PI*2) / nb_points - deg2rad(90)
		var angle_point = i * PI*2 / nb_points - deg2rad(90)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * radius)

	draw_colored_polygon(points_arc, color, PoolVector2Array(), null, null, true)
