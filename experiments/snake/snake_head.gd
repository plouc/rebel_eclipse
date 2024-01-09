class_name SnakeHead
extends Node2D

@onready var trail = $SnakeTrailStore
@onready var move_component: MoveComponent = $MoveComponent

func _ready():
	print("added head")
