extends Control


onready var label = $'Label'


func setup(global):
	self.hide()
	global.connect('update_nodes', self, '_on_global_update_nodes')
	self.rect_position = -global.get_viewport().size/2


func _process(_delta):
	label.text = 'FPS: ' + String(Engine.get_frames_per_second())


func _on_global_update_nodes():
	self.visible = !self.visible