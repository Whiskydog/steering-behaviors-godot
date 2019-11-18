extends Node2D

onready var width = get_viewport().size.x
onready var height = get_viewport().size.y
var boids = []

func _ready():
	for i in range(65):
		var boid = preload('res://scenes/steerable.tscn').instance()
		add_child(boid, true)
		boid.position.x = randf() * width
		boid.position.y = randf() * height
		boid.add_behavior(boid.wander_circle, 'wander')
		boid.add_behavior(boids, 'flock')
		boids.append(boid)