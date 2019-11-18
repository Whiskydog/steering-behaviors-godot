extends KinematicBody2D


var behaviors = []
var targets = []

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var steering_force = Vector2.ZERO

onready var steer_engine: Node = $'/root/SteeringEngine'
onready var global: Node = $'/root/Global'
onready var raycasts = $RayCasts

export(float) var slowing_distance = 100.0
export(float) var max_speed: float = 260.0
export(float) var max_force: float = 6.0
var wander_circle: Node2D


func _ready():
	wander_circle = $'WanderCircle'
	velocity = Vector2.RIGHT * max_speed


func _process(_delta):
	global.keep_inside_camera_bounds(self)
	self.update()


func _physics_process(_delta):
	# Determine steering force based on current behaviors
	# Clamped down to max force allowed
	steering_force = Vector2.ZERO
	for i in behaviors.size():
		steering_force += behaviors[i].call_func(self, targets[i])
	steering_force = steering_force.clamped(max_force)

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
	for raycast in raycasts.get_children():
		raycast.set_cast_to(polar2cartesian(velocity.length(), velocity.angle() - rotation) + raycast.position)
	acceleration = Vector2.ZERO


func _draw():
	if global.debug:
		draw_line(Vector2.ZERO, Vector2(10, 0), Color.red)
		draw_line(Vector2.ZERO, Vector2(0, 10), Color.green)
		draw_line(Vector2.ZERO, steering_force, Color.mediumblue, 1.0, true)
		for raycast in raycasts.get_children():
			draw_line(raycast.position, raycast.cast_to, Color.black, 1.0, true)


func add_behavior(target, behavior):
	if behavior == 'wander':
		wander_circle.show()
	targets.append(target)
	behaviors.append(funcref(steer_engine, behavior))


func predict_future_position(prediction_time):
	return position + velocity * prediction_time