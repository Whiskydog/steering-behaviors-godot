extends Node2D


var flow_field


func _ready():
    flow_field = preload('res://scripts/flow_field.gd').new(20)
    self.add_child(flow_field)
    flow_field.position -= get_viewport().size/2
    $'Steerable'.add_behavior(flow_field, 'follow_flow_field')