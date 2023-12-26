class_name MoveSinusoidalComponent
extends Node

@export var move_component: MoveComponent
@export var speed: float = 60.0
@export var angle_increment: float = 0.01
@export var randomize_start_angle: bool = true

var current_angle: float = 0

func _ready():
	if randomize_start_angle:
		current_angle = randi_range(0, 360)

func _process(_delta):
	current_angle += angle_increment

	move_component.velocity = Vector2(
		sin(current_angle) * speed,
		move_component.velocity.y
	)
