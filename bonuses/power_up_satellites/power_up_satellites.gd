extends Node2D

@export var pickup_effect_scene: PackedScene
@export var satellites_config: SatellitesConfig

@onready var move_component: MoveComponent = $State/MoveComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var area_2d: Area2D = $Area2D

func _ready():
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	area_2d.area_entered.connect(on_pickup.unbind(1))

	move_component.velocity.y = randi_range(40, 80)

func on_pickup():
	SoundPlayer.play(SoundPlayer.POWER_UP_BULLETS, -10)

	satellites_config.bump_level()
	
	var pickup_effect = pickup_effect_scene.instantiate()
	pickup_effect.position = position
	get_tree().current_scene.get_node("%Bonuses").add_child(pickup_effect)

	queue_free()
