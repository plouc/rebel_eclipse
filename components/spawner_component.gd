class_name SpawnerComponent
extends Node2D

@export var scene: PackedScene
@export var position_randomness: int = 0
@export var layer_name: String = ""

# Spawn an instance of the scene at a specific global position on a parent
# By default the parent is the current "main" scene , but you can pass in
# an alternative parent if you so choose.
func spawn(global_spawn_position: Vector2 = global_position, parent: Node = get_tree().current_scene) -> Node:
	assert(scene is PackedScene, "Error: The scene export was never set on this spawner component.")
	
	if layer_name != "":
		parent = parent.get_node(layer_name)

	var instance = scene.instantiate()
	parent.add_child.call_deferred(instance)

	var initial_position = Vector2(
		global_spawn_position.x,
		global_spawn_position.y
	)
	if position_randomness > 0:
		initial_position.x += randi_range(-position_randomness, position_randomness)
		initial_position.y += randi_range(-position_randomness, position_randomness)

	# Update the global position of the instance.
	# (This must be done after adding it as a child)
	instance.global_position = initial_position
		
	# Return the instance in case we want to perform any other operations
	# on it after instancing it.
	return instance
