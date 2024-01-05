extends Node2D

@export var danger_ahead_scene: PackedScene
@export var layer: CanvasLayer

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready():
	visible_on_screen_notifier_2d.screen_entered.connect(func():
		var danger_ahead = danger_ahead_scene.instantiate()
		layer.add_child(danger_ahead)
	)
