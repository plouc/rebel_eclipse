class_name EnemyBullet02
extends Node2D

var direction: Vector2 = Vector2.RIGHT
var speed: int = 300

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var flash_component: FlashComponent = $FlashComponent

func _ready():
	global_rotation = direction.angle()
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(on_impact.unbind(1))

func _process(delta):
	translate(direction.normalized() * speed * delta)
	#global_rotation = direction.angle()

func on_impact():
	queue_free()
