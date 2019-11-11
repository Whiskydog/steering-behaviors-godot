extends Node2D


onready var steerable = $'Steerable'


func _ready():
    steerable.set_target_and_behavior(steerable.wander_circle, 'wander')


func _process(delta):
    self.update()


#func _draw():
#    draw_circle(steerable.wander_circle.global_position + polar2cartesian(steerable.wander_circle_radius, steerable.wander_angle + steerable.rotation),
#            2.0, Color.red)