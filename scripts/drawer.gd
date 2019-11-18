extends Node2D


var resolution = 48
onready var width = get_viewport().size.x
onready var height = get_viewport().size.y


func _ready():
	get_viewport().connect('size_changed', self, '_on_viewport_size_changed')


func _draw():
	for i in range(height/resolution+1):
		draw_line(Vector2(0, i*resolution), Vector2(width, i*resolution), 
				Color.lightgray, 1.0, true)
	for i in range(width/resolution+1):
		draw_line(Vector2(i*resolution, 0), Vector2(i*resolution, height), 
				Color.lightgray, 1.0, true)


func _on_viewport_size_changed():
	width = get_viewport().size.x
	height = get_viewport().size.y