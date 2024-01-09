class_name Snake
extends Node2D

@export var distance_between: float = .16
@export var snake_parts: Array[PackedScene]
@onready var timer = $Timer

var origin_position = Vector2(288, 50)
var origin_rotation = 90

var count_up: float = 0
var speed: float = 200.0
var turn_speed: float = 18.0
var snake_body = []

func _ready():
	create_body_parts()

func _process(delta):
	if snake_parts.size() > 0:
		create_body_parts(delta)

	snake_movement(delta)

func _input(_event: InputEvent) -> void:
	var x_input_axis = Input.get_axis("ui_left", "ui_right")
	var y_input_axis = Input.get_axis("ui_up", "ui_down")
	
	if snake_body.size() > 0:
		var head = snake_body[0]
		var velocity = Vector2(
			x_input_axis,
			y_input_axis,
		).normalized() * speed
		head.move_component.velocity = velocity
		head.rotation = velocity.angle()

func snake_movement(_delta: float) -> void:
	if snake_body.size() > 1:
		for part_index in range(1, snake_body.size()):
			var previous_part = snake_body[part_index - 1]
			var previous_trail: SnakeTrailStore = previous_part.trail

			var part: Node2D = snake_body[part_index]
			part.position = previous_trail.markers[0]["position"]
			part.rotation = previous_trail.markers[0]["rotation"]

			previous_trail.markers.remove_at(0)

func create_body_parts(delta: float = 0.0):
	if snake_body.size() == 0:
		var head: Node2D = snake_parts[0].instantiate()
		add_child(head)
		head.position = origin_position
		head.rotation = deg_to_rad(origin_rotation)
		head.z_index = snake_parts.size()
		snake_body.append(head)
		snake_parts.remove_at(0)

	var tail = snake_body[-1]
	var tail_trail: SnakeTrailStore = tail.trail

	if count_up == 0:
		tail_trail.clear_markers()

	count_up += delta
	if count_up >= distance_between:
		var new_part: Node2D = snake_parts[0].instantiate()
		add_child(new_part)
		new_part.position = tail_trail.markers[0]["position"]
		new_part.z_index = snake_parts.size()

		snake_body.append(new_part)
		snake_parts.remove_at(0)
		new_part.trail.clear_markers()
		
		count_up = 0
