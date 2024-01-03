extends Node2D

@export var laser_config: LaserConfig
@export var game_stats: GameStats
@export var base_damage: float = 1.0
@export var hyper_level_damage_increment: float = 1.0

@onready var laser_beam: LaserBeam = $LaserBeam

func _ready():
	laser_config.level_changed.connect(_on_laser_level_update)
	_on_laser_level_update(laser_config.level)

	game_stats.hyper_level_update.connect(_on_hyper_level_update)
	_on_hyper_level_update(game_stats.hyper_level)

func _on_laser_level_update(laser_level: int):
	laser_beam.ray_count = laser_level

func _on_hyper_level_update(hyper_level: int):
	laser_beam.damage = base_damage + hyper_level * hyper_level_damage_increment
