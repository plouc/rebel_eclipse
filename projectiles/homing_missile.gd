class_name HomingMissile
extends Node2D

@export var speed = 350.0
@export var steer_force = 50.0
@export var rotation_speed = 1.0

@onready var area_2d: Area2D = $Area2D

var velocity: Vector2 = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null

func _ready():
	area_2d.area_entered.connect(func(stuff: Area2D):
		target = stuff
	)

	velocity = Vector2.from_angle(global_rotation).normalized() * speed

func seek() -> Vector2:
	if not target:
		return Vector2.ZERO
		
	var delta: Vector2 = target.global_position - global_position
	print(delta.length())
	var desired = delta.normalized() * speed
	var steer = (desired - velocity).normalized() * steer_force

	return steer

func _process_a(delta: float):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.normalized() * speed
	rotation = velocity.angle()
	
	global_position += velocity * delta
	
func _process_b(delta: float):
	if target:
		var dir: Vector2 = target.global_position - global_position
		dir = dir.normalized()
	
		var rotate_amount = dir.cross(global_transform.y)
		rotate(rotate_amount * rotation_speed * delta)
		
		global_translate(-global_transform.y  * speed * delta)
	else:
		global_position += velocity * delta

func _physics_process(delta: float):
	_process_a(delta)
	#_process_b(delta)

func _on_missile_body_entered(_body):
	queue_free()

func _on_lifetime_timeout():
	queue_free()
