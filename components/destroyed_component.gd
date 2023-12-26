class_name DestroyedComponent
extends Node

@export var actor: Node2D
@export var stats_component: StatsComponent
@export var destroy_effect_spawner_component: SpawnerComponent

func _ready() -> void:
	stats_component.no_health.connect(destroy)

func destroy() -> void:
	destroy_effect_spawner_component.spawn(
		actor.global_position,
		get_tree().current_scene.get_node("%Explosions")
	)

	actor.queue_free()
