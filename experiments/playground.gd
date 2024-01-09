extends Node2D

@export var game_stats: GameStats

func _ready():
	game_stats.hyper_level = game_stats.max_hyper_level
	tree_exited.connect(func():
		game_stats.hyper_level = 0
	)
