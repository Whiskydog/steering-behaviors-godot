extends Node2D


func _ready():
	$'Steerable'.add_behavior($'Target', 'pursuit')
	$'Target'.add_behavior($'MouseTarget', 'seek')