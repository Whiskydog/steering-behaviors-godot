extends Node2D


var length: float


func _init(pos, length, direction):
    self.name = 'Arrow'
    self.position = pos
    self.length = length
    self.rotation = direction.angle()


func _draw():
    var end_point = Vector2.RIGHT * (length/2)

    #self.draw_circle(Vector2.ZERO, 1.0, Color.red)
    self.draw_line(Vector2.LEFT * (length/2), end_point, Color.black, 1.0, true)

    self.draw_line(end_point, end_point + polar2cartesian(2.5, deg2rad(135)), Color.black, 1.0, true)
    self.draw_line(end_point, end_point + polar2cartesian(2.5, deg2rad(-135)), Color.black, 1.0, true)


#func _input(event):
#    if event.is_action('right') and event.pressed:
#        self.rotation += deg2rad(10)
#        self.update()