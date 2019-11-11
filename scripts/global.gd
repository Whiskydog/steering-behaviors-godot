extends Node

var debug = false
signal update_nodes

func _ready():
    randomize()
    self.set_process(true)
    var fps_counter = preload('res://scenes/fps_counter.tscn').instance()
    fps_counter.setup(self)
    self.add_child(fps_counter)


func _input(event):
    if event.is_action_pressed('quit'):
        get_tree().quit()
    
    if event.is_action_pressed('debug'):
        debug = not debug
        emit_signal('update_nodes')
    elif event.is_action_pressed('seek'):
        get_tree().change_scene('res://scenes/test_seek.tscn')
    elif event.is_action_pressed('flee'):
        get_tree().change_scene('res://scenes/test_flee.tscn')
    elif event.is_action_pressed('pursuit'):
        get_tree().change_scene('res://scenes/test_pursuit.tscn')
    elif event.is_action_pressed('evade'):
        get_tree().change_scene('res://scenes/test_evade.tscn')
    elif event.is_action_pressed('arrive'):
        get_tree().change_scene('res://scenes/test_arrival.tscn')
    elif event.is_action_pressed('wander'):
        get_tree().change_scene('res://scenes/test_wander.tscn')


func keep_inside_camera_bounds(node2d):
    var vsize = get_viewport().size / 2
    
    if node2d.position.x > vsize.x:
        node2d.position.x = -vsize.x
    elif node2d.position.x < -vsize.x:
        node2d.position.x = vsize.x

    if node2d.position.y > vsize.y:
        node2d.position.y = -vsize.y
    elif node2d.position.y < -vsize.y:
        node2d.position.y = vsize.y