extends Node


const ANGLE_CHANGE = 50.0
onready var p = get_parent() # Behavior owner


func _ready():
    self.name = 'SteeringEngine'


func seek(target) -> Vector2:
    # Set desired velocity to the unit vector that points towards the target
    # Multiply it by parent max speed to get a velocity vector
    var desired_velocity = (target.position - p.position).normalized() * p.max_speed

    # We return the desired velocity minus the parent's current velocity
    # This will make the parent steer towards the target
    return desired_velocity - p.velocity


func seek_pos(target_pos: Vector2) -> Vector2:
    var desired_velocity = (target_pos - p.position).normalized() * p.max_speed
    return desired_velocity - p.velocity


func flee(target) -> Vector2:
    # Same than seek but inverting the unit vector
    var desired_velocity = (p.position - target.position).normalized() * p.max_speed
    return desired_velocity - p.velocity


func flee_pos(target_pos: Vector2) -> Vector2:
    var desired_velocity = (p.position - target_pos).normalized() * p.max_speed
    return desired_velocity - p.velocity


func pursuit(target) -> Vector2:
    # We get the distance between parent and target
    var distance = (target.position - p.position).length()

    # T is how many cicles will take us to get to the target based on the target speed
    var T = distance / target.max_speed

    # We predict where the target will be in T cicles and do a seek towards that position
    var future_pos = target.position + target.velocity * T
    return seek_pos(future_pos)


func evade(target) -> Vector2:
    # Same than pursuit but we flee from the target position instead of seeking it
    var distance = (target.position - p.position).length()
    var T = distance / target.max_speed
    var future_pos = target.position + target.velocity * T
    return flee_pos(future_pos)


func arrive(target) -> Vector2:
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
    var target_offset = target.position - p.position
    # We determine distance between target and parent
    var distance = target_offset.length()

    # We get target speed by determining how far we're from the slowing distance multiplying by max speed
    # Then clipping it between this new speed and max speed
    # If we're outside slowing distance we just get max speed, otherwise we get a 0-1 range that slows
    # our speed down to zero. Clipped speed is the minimum between this speed and max speed
    var ramped_speed = p.max_speed * (distance / p.slowing_distance)
    var clipped_speed = min(ramped_speed, p.max_speed)

    # We get desired velocity by dividing our speed by distance, basically this gives us the velocity length, then
    # setting this length to the target offset vector (to keep correct heading)
    var desired_velocity = (clipped_speed / distance) * target_offset
    return desired_velocity - p.velocity


func wander(wander_circle) -> Vector2:
    wander_circle.wander_angle += randf() * deg2rad(ANGLE_CHANGE) - deg2rad(ANGLE_CHANGE) * .5
    #p.wander_angle = clamp(p.wander_angle, -2*PI, 2*PI)
    return seek_pos(wander_circle.global_position + 
            polar2cartesian(wander_circle.radius, wander_circle.wander_angle + wander_circle.parent_rotation()))


func follow_flow_field(flow_field) -> Vector2:
    var desired_velocity = flow_field.lookup(p.position)
    return desired_velocity * p.max_speed