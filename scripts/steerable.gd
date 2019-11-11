extends KinematicBody2D


var steer_func_ref

var wander_circle: Node2D
var target: Node2D

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var steering_force = Vector2.ZERO

var steer_engine: Node = preload('steer_engine.gd').new()
onready var global: Node = $'/root/Global'

export(float) var slowing_distance = 100.0
export(float) var max_speed: float = 260.0
export(float) var max_force: float = 6.0


func _ready():
	wander_circle = $'WanderCircle'
	self.add_child(steer_engine)


func _process(_delta):
	global.keep_inside_camera_bounds(self)
	self.update()


func _physics_process(_delta):
	# Determine steering force based on current behavior
	# Clamped down to max force allowed
	steering_force = steer_func_ref.call_func(target).clamped(max_force)

	# Apply force to acceleration (we could also divide by mass)
	acceleration += steering_force

	# Apply acceleration to velocity then added to position
	# Clamped down to max speed allowed
	velocity = (velocity + acceleration).clamped(max_speed)
	if velocity.length() > .5:
		velocity = move_and_slide(velocity)

	# Rotate node towards velocity heading
	# Reset acceleration for next T
	self.rotation = velocity.angle()
	acceleration = Vector2.ZERO


func _draw():
	if global.debug:
		draw_line(Vector2.ZERO, Vector2(10, 0), Color.red)
		draw_line(Vector2.ZERO, Vector2(0, 10), Color.green)
		draw_line(Vector2.ZERO, steering_force, Color.mediumblue, 1.0, true)


func set_target_and_behavior(target, behavior):
	if behavior == 'wander':
		wander_circle.show()
	self.target = target
	steer_func_ref = funcref(steer_engine, behavior)