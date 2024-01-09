class_name BulletSpawner
extends Node2D

@export var is_active: bool = true:
	set(value):
		is_active = value
		if is_active:
			start()
		else:
			stop()
@export var is_player_bullet: bool = false
@export var bullet_scene: PackedScene
@export var layer_name: String = "%EnemiesBullets"
@export var firing_interval: float = 1.0:
	set(value):
		firing_interval = value
		if firing_timer:
			firing_timer.wait_time = firing_interval
@export var should_fire_only_once: bool = false
@export var bullet_speed: float = 300.0
@export var cancellable_bullets: bool = false
@export var auto_cancel_bullets: bool = true
@export var firing_effect_scene: PackedScene
@export var use_global_rotation: bool = true

@export_group("Burst")
@export var burst_amount: int = 1
@export var burst_spread: float = 0.0
@export var burst_bullet_speed_increment: float = 0.0
@export var burst_angle_increment: float = 0.0

@onready var firing_timer: Timer = $FiringTimer

var firing_effect: AnimatedSprite2D

signal bullets_cancellation_init(spawner: BulletSpawner)

func _ready():
	if not is_visible_in_tree():
		is_active = false

	if firing_effect_scene != null:
		firing_effect = firing_effect_scene.instantiate()
		add_child(firing_effect)

	firing_timer.autostart = false
	firing_timer.wait_time = firing_interval
	firing_timer.timeout.connect(fire)
	
	if auto_cancel_bullets:
		tree_exited.connect(func():
			cancel_bullets()
		)
	
	if is_active:
		start()
		
func start():
	if firing_timer:
		firing_timer.start()
		fire()
	
func stop():
	if firing_timer:
		firing_timer.stop()

func fire():
	var current_rotation: float = global_rotation if use_global_rotation else rotation

	if firing_effect != null:
		firing_effect.frame = 0

		firing_effect.play()

	var start_angle: float = current_rotation
	var angle_step: float = 0.0

	if burst_amount > 1 and burst_spread > 0:
		start_angle -= deg_to_rad(burst_spread / 2)
		angle_step = deg_to_rad(burst_spread / float(burst_amount - 1))

	for bullet_index in range(burst_amount):
		var bullet = bullet_scene.instantiate()

		bullet.spawner = self
		bullet.is_player_bullet = is_player_bullet
		bullet.is_cancellable = cancellable_bullets
		bullet.speed = bullet_speed + bullet_index * burst_bullet_speed_increment
		bullet.global_position = global_position
		bullet.direction = Vector2.from_angle(
			start_angle
			+ angle_step * bullet_index
			+ deg_to_rad(burst_angle_increment) * bullet_index
		)

		get_tree().current_scene.get_node(layer_name).add_child.call_deferred(bullet)

	if should_fire_only_once:
		queue_free()

func cancel_bullets():
	bullets_cancellation_init.emit()

