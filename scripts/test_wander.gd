extends Node2D


onready var steerable = $'Steerable'


func _ready():
    steerable.set_target_and_behavior(steerable.wander_circle, 'wander')


func _process(delta):
    self.update()