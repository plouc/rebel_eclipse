class_name TimeToLiveComponent
extends Node

@export var actor: Node2D
@export var lifetime: float = 6.0

var age: float = 0.0

func _process(delta):
	age += delta
	if age >= lifetime:
		actor.queue_free()
