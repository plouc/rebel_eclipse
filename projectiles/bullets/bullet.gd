class_name Bullet
extends Node2D

@export var spawner: BulletSpawner:
	set(value):
		spawner = value
		if spawner:
			_setup_spawner()

@export var is_player_bullet: bool = false
@export var is_cancellable: bool = false
@export var direction: Vector2 = Vector2.RIGHT:
	set(value):
		direction = value
		if should_orient_sprite:
			rotation = direction.angle()
@export var speed: float = 0.0
@export var lifetime: float = 3.0
@export var damage: float = 1.0
@export var should_orient_sprite: bool = true
@export var curve_duration: float = 1.0
@export var curve_transform: Script
@export var should_activate_sub_spawners_on_expiration: bool = false

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var flash_component: FlashComponent = $Effects/FlashComponent
@onready var bullet_animated_sprite: AnimatedSprite2D = $BulletAnimatedSprite
@onready var sub_spawners: Node2D = $SubSpawners

var age: float = 0.0:
	set(value):
		age = value
		normalized_age = age / lifetime
		curve_normalized_time = age / curve_duration
var normalized_age: float = 0.0
var curve_normalized_time: float = 0.0

func _ready():
	hitbox_component.collision_layer = 0
	hitbox_component.collision_mask = 0
	if is_player_bullet:
		hitbox_component.set_collision_mask_value(2, true)
	else:
		hitbox_component.set_collision_mask_value(1, true)

	hitbox_component.damage = damage
	hitbox_component.hit_hurtbox.connect(_on_impact.unbind(1))

	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)

	flash_component.sprite = bullet_animated_sprite
	flash_component.flash()

func _setup_spawner():
	if not spawner:
		return

	spawner.bullets_cancellation_init.connect(func():
		if not is_cancellable:
			return

		cancel()
	)

func cancel():
	hitbox_component.process_mode = Node.PROCESS_MODE_DISABLED
	
	if bullet_animated_sprite.sprite_frames.has_animation("cancel"):
		bullet_animated_sprite.play("cancel")
		await bullet_animated_sprite.animation_finished

	queue_free()

func _process(delta):
	age += delta
	if age >= lifetime:
		if should_activate_sub_spawners_on_expiration:
			for sub_spawner in sub_spawners.get_children():
				(sub_spawner as BulletSpawner).is_active = true

		queue_free()
		return

	translate(direction.normalized() * speed * delta)

func _on_impact():
	queue_free()

