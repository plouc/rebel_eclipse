extends Node2D

@export var move_component: MoveComponent
@export var velocity_y: int

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready():
	visible_on_screen_notifier_2d.screen_entered.connect(_adjust_velocity)

func _adjust_velocity():
	var velocity = Vector2(move_component.velocity.x, velocity_y)
	
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(move_component, "velocity", velocity, 2.0).from_current()
