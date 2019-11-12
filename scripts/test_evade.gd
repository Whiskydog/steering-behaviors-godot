extends Node2D


func _ready():
	$'Steerable'.add_behavior($'Target', 'evade')
	$'Target'.add_behavior($'MouseTarget', 'seek')