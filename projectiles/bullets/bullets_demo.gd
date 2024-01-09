extends Node2D

@export var game_stats: GameStats

@onready var spawners: Node2D = $Spawners

var direction: Vector2 = Vector2.RIGHT
var speed: float = 120.0

func _ready():
	game_stats.hyper_level = 5

	tree_exited.connect(func():
		game_stats.hyper_level = 0
	)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://ui/misc_menu.tscn")

func _process(delta):
	spawners.position += direction.normalized() * speed * delta

	if (spawners.position.x + 250) >= 576:
		direction = Vector2.LEFT
	elif spawners.position.x <= 0:
		direction = Vector2.RIGHT
