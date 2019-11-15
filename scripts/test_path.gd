extends Node2D


func _ready():
	$Path.add_point(0, 0)
	$Path.add_point(200, -200)
	$Steerable.add_behavior($Path, 'follow_path')