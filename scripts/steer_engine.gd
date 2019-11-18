extends Node


const ANGLE_CHANGE = 50.0


func _ready():
	self.name = 'SteeringEngine'


func seek(boid, target) -> Vector2:
	# Set desired velocity to the unit vector that points towards the target
	# Multiply it by parent max speed to get a velocity vector
	var desired_velocity = (target.position - boid.position).normalized() * boid.max_speed

	# We return the desired velocity minus the parent's current velocity
	# This will make the parent steer towards the target
	return desired_velocity - boid.velocity


func seek_pos(boid, target_pos: Vector2) -> Vector2:
	var desired_velocity = (target_pos - boid.position).normalized() * boid.max_speed
	return desired_velocity - boid.velocity


func flee(boid, target) -> Vector2:
	# Same than seek but inverting the unit vector
	var desired_velocity = (boid.position - target.position).normalized() * boid.max_speed
	return desired_velocity - boid.velocity


func flee_pos(boid, target_pos: Vector2) -> Vector2:
	var desired_velocity = (boid.position - target_pos).normalized() * boid.max_speed
	return desired_velocity - boid.velocity


func pursuit(boid, target) -> Vector2:
	# We get the distance between parent and target
	var distance = (target.position - boid.position).length()

	# T is how many cicles will take us to get to the target based on the target speed
	var T = distance / target.max_speed

	# We predict where the target will be in T cicles and do a seek towards that position
	var future_pos = target.position + target.velocity * T
	return seek_pos(boid, future_pos)


func evade(boid, target) -> Vector2:
	# Same than pursuit but we flee from the target position instead of seeking it
	var distance = (target.position - boid.position).length()
	var T = distance / target.max_speed
	var future_pos = target.position + target.velocity * T
	return flee_pos(boid, future_pos)


func arrive(boid, target) -> Vector2:
	#var desired = target.position - p.position
	#var d = desired.length()
	#desired = desired.normalized()
	#if d < p.slowing_distance:
	#    var l = range_lerp(d, 0, p.slowing_distance, 0, p.max_speed)
	#    desired *= l
	#else:
	#    desired *= p.max_speed
	#return desired - p.velocity

	# We determine the offset vector between target and parent position
	var target_offset = target.position - boid.position
	# We determine distance between target and parent
	var distance = target_offset.length()

	# We get target speed by determining how far we're from the slowing distance multiplying by max speed
	# Then clipping it between this new speed and max speed
	# If we're outside slowing distance we just get max speed, otherwise we get a 0-1 range that slows
	# our speed down to zero. Clipped speed is the minimum between this speed and max speed
	var ramped_speed = boid.max_speed * (distance / boid.slowing_distance)
	var clipped_speed = min(ramped_speed, boid.max_speed)

	# We get desired velocity by dividing our speed by distance, basically this gives us the velocity length, then
	# setting this length to the target offset vector (to keep correct heading)
	var desired_velocity = (clipped_speed / distance) * target_offset
	return desired_velocity - boid.velocity


func wander(boid, wander_circle) -> Vector2:
	wander_circle.wander_angle += randf() * deg2rad(ANGLE_CHANGE) - deg2rad(ANGLE_CHANGE) * .5
	#p.wander_angle = clamp(p.wander_angle, -2*PI, 2*PI)
	return seek_pos(boid, wander_circle.global_position + 
			polar2cartesian(wander_circle.radius, wander_circle.wander_angle + wander_circle.parent_rotation()))


func follow_flow_field(boid, flow_field) -> Vector2:
	var desired_velocity = flow_field.lookup(boid.position)
	return desired_velocity * boid.max_speed


func stay_within_rect(boid, rect: Rect2) -> Vector2:
	var desired = boid.velocity

	if boid.position.x < rect.position.x:
		desired = Vector2(boid.max_speed, boid.velocity.y)
	elif boid.position.x > rect.end.x:
		desired = Vector2(-boid.max_speed, boid.velocity.y)

	if boid.position.y < rect.position.y:
		desired = Vector2(boid.velocity.x, boid.max_speed)
	elif boid.position.y > rect.end.y:
		desired = Vector2(boid.velocity.x, -boid.max_speed)
	
	return desired - boid.velocity


func avoid_obstacles(boid, _unused) -> Vector2:
	var rc = null
	for raycast in boid.raycasts.get_children():
		if raycast.is_colliding():
			rc = raycast
			break
	
	if rc != null:
		var collider = rc.get_collider()
		var force = (rc.get_collision_point() - collider.position).normalized() * boid.max_speed
		return force

	return Vector2.ZERO


func follow_path(boid, path) -> Vector2:
	var desired = steer_to_follow_path(boid, path, .5, 1)
	if desired == Vector2.ZERO:
		desired = polar2cartesian(boid.max_speed, boid.velocity.angle())
	return desired - boid.velocity


func steer_to_follow_path(boid, path, prediction_time, direction):
	var path_distance_offset = direction * prediction_time * boid.max_speed
	var future_position = boid.predict_future_position(prediction_time)
	var now_path_distance = path.map_point_to_path_distance(boid.position)
	var future_path_distance = path.map_point_to_path_distance(future_position)

	var right_way
	if path_distance_offset > 0:
		right_way = now_path_distance < future_path_distance
	else:
		right_way = now_path_distance > future_path_distance

	var ret_array = path.map_point_to_path(future_position)
	var on_path = ret_array[0]
	var tangent = ret_array[1]
	var outside = ret_array[2]

	if outside < 0 && right_way:
		return Vector2.ZERO
	else:
		var target_path_distance = now_path_distance + path_distance_offset
		var target = path.map_path_distance_to_point(target_path_distance)
		return seek_pos(boid, target)


func steer_to_stay_on_path(boid, path, prediction_time):
	var future_position = boid.predict_future_position(prediction_time)
	var ret_array = path.map_point_to_path(future_position)
	var on_path = ret_array[0]
	var tangent = ret_array[1]
	var outside = ret_array[2]

	if outside < 0:
		return Vector2.ZERO
	else:
		return seek_pos(boid, on_path)


func separate(boid, awareness_area):
	var desired_separation = 35.0
	var sum = Vector2.ZERO
	var count = 0
	for other in awareness_area.get_overlapping_bodies():
		var d = boid.position.distance_to(other.position)
		if d > 0 and d < desired_separation:
			var diff = (boid.position - other.position).normalized()
			diff /= d
			sum += diff
			count += 1

	if count > 0:
		sum /= count
		sum = sum.normalized() * boid.max_speed
		return sum - boid.velocity
	return sum


#func separate(boid, boids):
#	var desired_separation = 35.0
#	var sum = Vector2.ZERO
#	var count = 0
#	for other in boids:
#		var d = boid.position.distance_to(other.position)
#		if d > 0 and d < desired_separation:
#			sum += other.position
#			count += 1
#
#	if count > 0:
#		sum /= count
#		return flee_pos(boid, sum)
#	return sum


func cohere(boid, awareness_area):
	var neighbor_dist = 50.0
	var sum = Vector2.ZERO
	var count = 0
	for other in awareness_area.get_overlapping_bodies():
		var d = boid.position.distance_to(other.position)
		if d > 0 and d < neighbor_dist:
			sum += other.position
			count += 1
	
	if count > 0:
		sum /= count
		return seek_pos(boid, sum)
	return sum


func align(boid, awareness_area):
	var neighbor_dist = 50.0
	var sum = Vector2.ZERO
	var count = 0
	for other in awareness_area.get_overlapping_bodies():
		var d = boid.position.distance_to(other.position)
		if d > 0 and d < neighbor_dist:
			sum += other.velocity
			count += 1
	
	if count > 0:
		sum /= count
		sum = sum.normalized() * boid.max_speed
		return sum - boid.velocity
	return sum


func flock(boid, awareness_area):
	var sep = separate(boid, awareness_area)
	var ali = align(boid, awareness_area)
	var coh = cohere(boid, awareness_area)

	sep *= 1.5

	return sep + ali + coh
