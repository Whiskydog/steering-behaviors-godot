extends CollisionPolygon2D


var poly = PoolVector2Array([Vector2(0, -6), Vector2(-3, 2), Vector2(0, 0), Vector2(3, 2)])


func _ready():
	self.polygon = poly


func _draw():
	self.draw_polygon(polygon, [get_parent().color], [], null, null, true)