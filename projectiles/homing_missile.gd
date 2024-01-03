class_name HomingMissile
extends Node2D

@export var speed = 200.0
@export var steer_force = 30.0

@onready var area_2d: Area2D = $Area2D

var velocity: Vector2 = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null

func _ready():
	area_2d.area_entered.connect(func(stuff: Area2D):
		print("collided")
		target = stuff
	)
	
	var t = Transform2D()
	t.origin.y = randf_range(0, 500)
	start(t)

func start(_transform):
	# target = _target
	global_transform = _transform
	velocity = transform.x * speed

func seek() -> Vector2:
	var steer = Vector2.ZERO
	if target:
		var desired = (target.global_position - global_position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force

	return steer

func _process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.normalized() * speed
	rotation = velocity.angle()
	global_position += velocity * delta

func _on_missile_body_entered(body):
	queue_free()

func _on_lifetime_timeout():
	queue_free()
