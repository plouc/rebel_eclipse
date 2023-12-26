class_name HyperBonus
extends Node2D

@export var game_stats: GameStats

@onready var move_component: MoveComponent = $State/MoveComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var area_2d: Area2D = $Area2D

func _ready():
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	area_2d.area_entered.connect(_on_pickup.unbind(1))
	
	move_component.velocity.y = randi_range(40, 80)

func _on_pickup() -> void:
	SoundPlayer.play_sound(SoundPlayer.POWER_UP_BULLETS)

	game_stats.hyper_level += 1

	queue_free()
