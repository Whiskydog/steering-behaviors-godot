extends Control


onready var label = $'Label'
onready var base_scene = $'../../'


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
	$ButtonMenu/Column2/FollowPath.connect('pressed', self, '_on_follow_path_pressed')
	$ButtonMenu/Column/Flock.connect('pressed', self, '_on_flock_pressed')
	$ButtonMenu/Column2/Separation.connect('pressed', self, '_on_separation_pressed')


func setup(global):
	hide()
	global.connect('update_nodes', self, '_on_global_update_nodes')


func _process(_delta):
	label.text = 'FPS: ' + String(Engine.get_frames_per_second())


func _on_global_update_nodes():
	self.visible = !self.visible


func _on_seek_pressed():
	base_scene.change_scene('res://scenes/tests/test_seek.tscn')


func _on_flee_pressed():
	base_scene.change_scene('res://scenes/tests/test_flee.tscn')


func _on_arrive_pressed():
	base_scene.change_scene('res://scenes/tests/test_arrival.tscn')


func _on_wander_pressed():
	base_scene.change_scene('res://scenes/tests/test_wander.tscn')


func _on_pursuit_pressed():
	base_scene.change_scene('res://scenes/tests/test_pursuit.tscn')


func _on_evade_pressed():
	base_scene.change_scene('res://scenes/tests/test_evade.tscn')


func _on_stay_within_rect_pressed():
	base_scene.change_scene('res://scenes/tests/test_stay.tscn')


func _on_obstacle_avoidance_pressed():
	base_scene.change_scene('res://scenes/tests/test_obstacle.tscn')


func _on_follow_flow_field_pressed():
	base_scene.change_scene('res://scenes/tests/test_noise.tscn')


func _on_follow_path_pressed():
	base_scene.change_scene('res://scenes/tests/test_path.tscn')


func _on_flock_pressed():
	base_scene.change_scene('res://scenes/tests/test_flock.tscn')


func _on_separation_pressed():
	base_scene.change_scene('res://scenes/tests/test_separation.tscn')