class_name TrainingMenuEnemyItem
extends Control

@onready var selected_outline: TextureRect = $SelectedOutline
@export var preview_scene: PackedScene
@export var is_active: bool = false:
	set(value):
		if value == is_active:
			return

		is_active = value
		if is_active == true:
			_selected()
		else:
			_inactive()

@onready var preview_container = $PreviewContainer

var _preview: AnimatedTextureRect

func _ready():
	selected_outline.hide()
	_preview = preview_scene.instantiate() as AnimatedTextureRect
	_preview.auto_play = false
	_preview.position = (Vector2(128, 128) - _preview.size) / 2

	preview_container.add_child(_preview)

func _selected():
	_preview.play()
	selected_outline.show()

func _inactive():
	_preview.stop()
	selected_outline.hide()
