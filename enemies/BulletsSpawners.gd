extends Node2D

@export var rotation_speed = 20

func _process(delta):
	rotation_degrees += rotation_speed * delta
