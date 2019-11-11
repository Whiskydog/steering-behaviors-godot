extends Node2D


func _ready():
	$'/root/Global'.connect('update_nodes', self, '_on_global_update_nodes')


func _process(_delta):
	self.position = get_global_mouse_position()


func _draw():
	if $'/root/Global'.debug:
		self.draw_circle(Vector2.ZERO, 2.5, Color.red)


func _on_global_update_nodes():
	self.update()