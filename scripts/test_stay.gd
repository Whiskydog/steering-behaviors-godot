extends Node2D


var rect_margin = Vector2(50, 50)
onready var global = $'/root/Global'
onready var steerable = $Steerable
onready var rect = Rect2(-get_viewport().size/2 + rect_margin, get_viewport().size - rect_margin*2)


func _ready():
    global.connect('update_nodes', self, '_on_global_update_nodes')
    steerable.add_behavior(steerable.wander_circle, 'wander')
    steerable.add_behavior(rect, 'stay_within_rect')


func _draw():
    if global.debug:
        draw_rect(rect, Color.lightgray, false)


func _on_global_update_nodes():
    update()