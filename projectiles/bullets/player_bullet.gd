extends Node2D

var direction: Vector2 = Vector2.RIGHT
var speed: int = 700

@export var spawner: BulletSpawner
@export var is_player_bullet: bool = true
@export var is_cancellable: bool = false
@export var game_stats: GameStats
@export var impact_effect: PackedScene

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var flash_component: FlashComponent = $FlashComponent

func _ready():
	rotation = direction.angle()
	
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)

	hitbox_component.hit_hurtbox.connect(on_impact.unbind(1))
	hitbox_component.damage = game_stats.hyper_level + 1

	animated_sprite.play("level_" + str(game_stats.hyper_level))

	var collision_shape: CollisionShape2D = hitbox_component.get_node("%collision_shape_" + str(game_stats.hyper_level))
	collision_shape.set_deferred("disabled", false)
	flash_component.flash()

func _process(delta):
	position += direction.normalized() * speed * delta
	rotation = direction.angle()

func on_impact():
	var impact = impact_effect.instantiate()
	impact.global_position = global_position
	impact.rotation = rotation

	get_tree().current_scene.get_node("%BulletsImpacts").add_child(impact)

	queue_free()
