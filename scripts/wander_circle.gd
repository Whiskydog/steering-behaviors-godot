extends Node2D


onready var global = $'/root/Global'

var wander_angle = rand_range(-2*PI, 2*PI)
export(float) var radius = 10.0
export(float) var distance_from_parent = 20.0


func _init():
    self.hide()


func _ready():
    self.position = Vector2.RIGHT * distance_from_parent


func _process(delta):
    update()


func _draw():
    if global.debug:
        draw_circle_no_fill(Vector2.ZERO, radius, Color.blue)
        draw_line(Vector2.ZERO, polar2cartesian(radius, wander_angle), Color.blue, 1.0, true)


func draw_circle_no_fill(center, radius, color):
	var nb_points = 64
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = -PI*2 + i * (-PI*2 - PI*2) / nb_points - deg2rad(90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
        draw_line(points_arc[index_point], points_arc[index_point + 1], color)


func parent_rotation():
    return get_parent().rotation