class_name CoinGrid
extends Node2D

@export var coin: PackedScene
@export var position_randomness: int = 5

func spawn():
	var parent: Node = get_tree().current_scene.get_node("%Coins")

	for marker in get_children() as Array[Marker2D]:
		var instance = coin.instantiate()
		parent.call_deferred("add_child", instance)
		instance.global_position = Vector2(
			marker.global_position.x + randi_range(-position_randomness, position_randomness),
			marker.global_position.y + randi_range(-position_randomness, position_randomness)
		)
