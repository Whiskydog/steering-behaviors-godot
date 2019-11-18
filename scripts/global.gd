extends Node

var debug = false
signal update_nodes

func _ready():
	randomize()
	self.set_process(true)
	pause_mode = PAUSE_MODE_PROCESS


func _input(event):
	if event.is_action_pressed('quit'):
		get_tree().quit()

	if event.is_action_pressed('pause'):
		get_tree().paused = !get_tree().paused
	
	if event.is_action_pressed('debug'):
		debug = not debug
		emit_signal('update_nodes')


func keep_inside_camera_bounds(node2d):
	var vsize = get_viewport().size
	
	if node2d.position.x > vsize.x:
		node2d.position.x = 0
	elif node2d.position.x < 0:
		node2d.position.x = vsize.x

	if node2d.position.y > vsize.y:
		node2d.position.y = 0
	elif node2d.position.y < 0:
		node2d.position.y = vsize.y
