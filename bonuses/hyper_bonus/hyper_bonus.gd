class_name HyperBonus
extends Node2D

@export var pickup_effect_scene: PackedScene
@export var game_stats: GameStats

@onready var move_component: MoveComponent = $State/MoveComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var area_2d: Area2D = $Area2D

func _ready():
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	area_2d.area_entered.connect(_on_pickup.unbind(1))
	
	move_component.velocity.y = randi_range(40, 80)

func _on_pickup() -> void:
	SoundPlayer.play(SoundPlayer.HYPER_LEVEL_UP)

	game_stats.hyper_level += 1
	
	var pickup_effect = pickup_effect_scene.instantiate()
	pickup_effect.position = position
	get_tree().current_scene.get_node("%Bonuses").add_child(pickup_effect)

	queue_free()
