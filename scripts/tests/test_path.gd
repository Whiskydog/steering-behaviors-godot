extends Node2D


func _ready():
	$Steerable.add_behavior($Path, 'follow_path')