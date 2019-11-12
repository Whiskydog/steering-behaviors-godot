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


func avoid_obstacles(boid: KinematicBody2D, _unused) -> Vector2:
    var rc = null
    if boid.raycast.is_colliding():
        rc = boid.raycast
    elif boid.raycast2.is_colliding():
        rc = boid.raycast2
    
    if rc != null:
        var collider = rc.get_collider()
        var force = (rc.get_collision_point() - collider.position).normalized() * boid.max_speed
        return force
    #if boid.raycast.is_colliding():
    #    var collider = boid.raycast.get_collider()
    #    var force = (boid.raycast.get_collision_point() - collider.position).normalized() * boid.max_speed
    #    return force
    return Vector2.ZERO
