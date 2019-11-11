extends Node2D


func _ready():
	$'Steerable'.set_target_and_behavior($'Target', 'pursuit')
	$'Target'.set_target_and_behavior($'MouseTarget', 'seek')