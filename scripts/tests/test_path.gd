extends Node2D


onready var path = $Path
onready var steerable = $Steerable
var normal_point = Vector2.ZERO

func _ready():
	#steerable.add_behavior($MouseTarget, 'arrive')
	steerable.add_behavior($Path, 'follow_path')


func _process(_delta):
	update()


func _draw():
	draw_line(Vector2.ZERO, Vector2.RIGHT * 10, Color.black)
	draw_circle(normal_point, 2.5, Color.red)
