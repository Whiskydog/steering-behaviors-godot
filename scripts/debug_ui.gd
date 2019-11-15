extends Control


onready var label = $'Label'


func _ready():
	$ButtonMenu/Column/Seek.connect('pressed', self, '_on_seek_pressed')
	$ButtonMenu/Column2/Flee.connect('pressed', self, '_on_flee_pressed')
	$ButtonMenu/Column/Arrive.connect('pressed', self, '_on_arrive_pressed')
	$ButtonMenu/Column2/Wander.connect('pressed', self, '_on_wander_pressed')
	$ButtonMenu/Column/Pursuit.connect('pressed', self, '_on_pursuit_pressed')
	$ButtonMenu/Column2/Evade.connect('pressed', self, '_on_evade_pressed')
	$ButtonMenu/Column/StayWithinRect.connect('pressed', self, '_on_stay_within_rect_pressed')
	$ButtonMenu/Column2/ObstacleAvoidance.connect('pressed', self, '_on_obstacle_avoidance_pressed')
	$ButtonMenu/Column/FollowFlowField.connect('pressed', self, '_on_follow_flow_field_pressed')


func setup(global):
	self.hide()
	global.connect('update_nodes', self, '_on_global_update_nodes')
	self.rect_position = -global.get_viewport().size/2


func _process(_delta):
	label.text = 'FPS: ' + String(Engine.get_frames_per_second())


func _on_global_update_nodes():
	self.visible = !self.visible


func _on_seek_pressed():
	get_tree().change_scene('res://scenes/test_seek.tscn')


func _on_flee_pressed():
	get_tree().change_scene('res://scenes/test_flee.tscn')


func _on_arrive_pressed():
	get_tree().change_scene('res://scenes/test_arrival.tscn')


func _on_wander_pressed():
	get_tree().change_scene('res://scenes/test_wander.tscn')


func _on_pursuit_pressed():
	get_tree().change_scene('res://scenes/test_pursuit.tscn')


func _on_evade_pressed():
	get_tree().change_scene('res://scenes/test_evade.tscn')


func _on_stay_within_rect_pressed():
	get_tree().change_scene('res://scenes/test_stay.tscn')


func _on_obstacle_avoidance_pressed():
	get_tree().change_scene('res://scenes/test_obstacle.tscn')


func _on_follow_flow_field_pressed():
	get_tree().change_scene('res://scenes/test_noise.tscn')
