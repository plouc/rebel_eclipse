class_name SpawnerPreviewComponent
extends Node

@export var preview: Node2D

func _ready():
	if !preview:
		return

	if !Engine.is_editor_hint():
		preview.visible = false
