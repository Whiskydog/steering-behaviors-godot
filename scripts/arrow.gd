extends Node2D


var length: float


func _init(pos, _length, direction):
    name = 'Arrow'
    position = pos
    length = _length
    rotation = direction.angle()


func _draw():
    var end_point = Vector2.RIGHT * (length/2)

    draw_line(Vector2.LEFT * (length/2), end_point, Color.black, 1.0, true)
    draw_line(end_point, end_point + polar2cartesian(2.5, deg2rad(135)), Color.black, 1.0, true)
    draw_line(end_point, end_point + polar2cartesian(2.5, deg2rad(-135)), Color.black, 1.0, true)