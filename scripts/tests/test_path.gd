extends Node2D


onready var path = $Path
onready var steerable = $Steerable


func _ready():
	steerable.add_behavior($Path, 'follow_path')