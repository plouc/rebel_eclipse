class_name BulletSpawner
extends Node2D

@export var bullet_scene: PackedScene
@export var layer_name: String = "%EnemiesBullets"
@export var interval: float = 1
@export var firing_effect_scene: PackedScene
@export var is_active: bool = true

@onready var firing_timer: Timer = $FiringTimer

var firing_effect: Node2D

func _ready():
	firing_timer.wait_time = interval
	firing_timer.timeout.connect(fire)
	firing_timer.start()
	
	if firing_effect_scene != null:
		firing_effect = firing_effect_scene.instantiate()
		
		get_tree().current_scene.get_node("%ProjectilesEffects").add_child.call_deferred(firing_effect)
		
		firing_effect.global_position = global_position
		firing_effect.global_rotation = global_rotation

func fire():
	if !is_active:
		return

	if firing_effect != null:
		firing_effect.global_position = global_position
		firing_effect.global_rotation = global_rotation

		firing_effect.play()

	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.direction = Vector2.from_angle(global_rotation)

	get_tree().current_scene.get_node(layer_name).add_child(bullet)



