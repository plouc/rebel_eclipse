class_name ScreenEnterSpawnerComponent
extends Node2D

@export var notifier: VisibleOnScreenNotifier2D
@export var spawner: SpawnerComponent

func _ready():
	notifier.screen_entered.connect(func():
		spawner.spawn()
		queue_free()
	)

