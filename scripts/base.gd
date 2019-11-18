extends Node


onready var debug_ui = $DebugLayer/DebugUI


func _ready():
	debug_ui.setup($'/root/Global')
	add_child(preload('res://scenes/tests/test_seek.tscn').instance())


func change_scene(scene):
	var current_scene = get_child(get_child_count()-1)
	remove_child(current_scene)
	current_scene.queue_free()
	add_child(load(scene).instance(), true)