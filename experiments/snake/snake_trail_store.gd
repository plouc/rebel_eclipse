class_name SnakeTrailStore
extends Node

@export var actor: Node2D

var markers: Array[Dictionary] = []

func update_markers() -> void:
	markers.append({
		"position": actor.position,
		"rotation": actor.rotation,
	})

func clear_markers() -> void:
	markers.clear()
	markers.append({
		"position": actor.position,
		"rotation": actor.rotation,
	})

func _process(_delta):
	update_markers()
