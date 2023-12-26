class_name ShipBulletsSpawners
extends Node2D

@export var game_stats: GameStats
@export var config: BulletsConfig

@onready var left_bullet_spawner = $LeftBulletSpawner
@onready var top_left_diagonal_bullet_spawner = $TopLeftDiagonalBulletSpawner
@onready var top_left_bullet_spawner = $TopLeftBulletSpawner
@onready var top_bullet_spawner = $TopBulletSpawner
@onready var top_right_bullet_spawner = $TopRightBulletSpawner
@onready var top_right_diagonal_bullet_spawner = $TopRightDiagonalBulletSpawner
@onready var right_bullet_spawner = $RightBulletSpawner
@onready var bottom_right_bullet_spawner = $BottomRightBulletSpawner
@onready var bottom_bullet_spawner = $BottomBulletSpawner
@onready var bottom_left_bullet_spawner = $BottomLeftBulletSpawner

@onready var spawners = {
	"left" = left_bullet_spawner,
	"top_left_diagonal" = top_left_diagonal_bullet_spawner,
	"top_left" = top_left_bullet_spawner,
	"top" = top_bullet_spawner,
	"top_right" = top_right_bullet_spawner,
	"top_right_diagonal" = top_right_diagonal_bullet_spawner,
	"right" = right_bullet_spawner,
	"bottom_right" = bottom_right_bullet_spawner,
	"bottom" = bottom_bullet_spawner,
	"bottom_left" = bottom_left_bullet_spawner,
}

func _ready():
	adjust_spawners(config.level, config.spawners_config_by_level[config.level])
	config.level_changed.connect(adjust_spawners)

func adjust_spawners(_level: int, level_config: Array):
	for spawner_id in spawners:
		var spawner = spawners[spawner_id]
		spawner.is_active = spawner_id in level_config
