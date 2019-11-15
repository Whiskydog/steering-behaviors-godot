extends Node2D


func _ready():
	$'Steerable'.add_behavior($'Target', 'flee')
