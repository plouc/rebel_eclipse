class_name LockToCameraComponent
extends Node

@export var actor: Node2D

var _camera: Camera2D
var _initial_offset: Vector2

func _ready():
	_camera = get_tree().current_scene.get_node("Camera2D")
	_initial_offset = actor.global_position - _camera.global_position

func _process(_delta):
	actor.global_position = _camera.global_position + _initial_offset
