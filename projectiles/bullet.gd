extends Node2D

var direction: Vector2 = Vector2.RIGHT
var speed: int = 200

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var flash_component: FlashComponent = $FlashComponent

func _ready():
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(on_impact.unbind(1))
	scale_component.tween_scale()
	flash_component.flash()

func _process(delta):
	translate(direction.normalized() * speed * delta)
	global_rotation = direction.angle()

func on_impact():
	queue_free()
