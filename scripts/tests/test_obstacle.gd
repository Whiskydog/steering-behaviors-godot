extends Node2D


func _ready():
	$Steerable.add_behavior(null, 'avoid_obstacles')
	$Steerable.add_behavior($MouseTarget, 'seek')