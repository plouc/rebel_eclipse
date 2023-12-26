class_name ShipBulletSpawner
extends Node2D

@export var bullet_scene: PackedScene
@export var is_active: bool = false

@onready var fire_timer: Timer = $FireTimer
@onready var firing_effect = $FiringEffect

func _ready():
	fire_timer.timeout.connect(fire)

func fire():
	if !is_active:
		return false

	firing_effect.play("default")

	var bullet = bullet_scene.instantiate()
	bullet.position = global_position
	bullet.direction = Vector2.from_angle(rotation)

	get_tree().current_scene.get_node("%PlayerBullets").add_child(bullet)

