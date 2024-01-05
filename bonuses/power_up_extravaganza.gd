extends Node2D

@export var game_stats: GameStats

func _ready():
	if not game_stats.is_power_up_extravaganza_enabled:
		queue_free()
