extends Node2D


func _ready():
	$'Steerable'.set_target_and_behavior($'Target', 'evade')
	$'Target'.set_target_and_behavior($'MouseTarget', 'seek')