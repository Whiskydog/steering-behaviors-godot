extends Node2D


onready var steerable = $'Steerable'


func _ready():
    steerable.add_behavior(steerable.wander_circle, 'wander')