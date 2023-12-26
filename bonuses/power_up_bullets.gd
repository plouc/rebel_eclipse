extends Node2D

@export var pickup_effect_scene: PackedScene
@export var bullets_config: BulletsConfig

@onready var move_component: MoveComponent = $State/MoveComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var area_2d: Area2D = $Area2D

func _ready():
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	area_2d.area_entered.connect(_on_pickup.unbind(1))

	move_component.velocity.y = randi_range(40, 80)

func _on_pickup():
	SoundPlayer.play_sound(SoundPlayer.POWER_UP_BULLETS)

	bullets_config.bump_level()
	
	var pickup_effect = pickup_effect_scene.instantiate()
	pickup_effect.position = position
	get_tree().current_scene.get_node("%Bonuses").add_child(pickup_effect)

	queue_free()
