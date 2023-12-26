class_name MoveInputComponent
extends Node

@export var move_stats: MoveStats
@export var move_component: MoveComponent

func _input(_event: InputEvent) -> void:
	var x_input_axis = Input.get_axis("ui_left", "ui_right")
	var y_input_axis = Input.get_axis("ui_up", "ui_down")
	
	move_component.velocity = Vector2(
		x_input_axis * move_stats.speed,
		y_input_axis * move_stats.speed
	)
	
