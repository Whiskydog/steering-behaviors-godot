extends Node

var debug = false
signal update_nodes

func _ready():
    randomize()
    self.set_process(true)
    var debug_ui = preload('res://scenes/debug_ui.tscn').instance()
    debug_ui.setup(self)
    self.add_child(debug_ui)


func _input(event):
    if event.is_action_pressed('quit'):
        get_tree().quit()
    
    if event.is_action_pressed('debug'):
        debug = not debug
        emit_signal('update_nodes')


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
