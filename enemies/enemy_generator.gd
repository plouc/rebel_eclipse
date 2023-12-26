extends Node2D

@export var GreenEnemyScene: PackedScene
@export var YellowEnemyScene: PackedScene
@export var PinkEnemyScene: PackedScene
@export var TurretScene: PackedScene

var margin = 24
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var green_enemy_spawn_timer: Timer = $GreenEnemySpawnTimer
@onready var yellow_enemy_spawn_timer: Timer = $YellowEnemySpawnTimer
@onready var pink_enemy_spawn_timer: Timer = $PinkEnemySpawnTimer
@onready var turret_spawn_timer: Timer = $TurretSpawnTimer

func _ready():
	green_enemy_spawn_timer.timeout.connect(handle_spawn.bind(
		GreenEnemyScene,
		green_enemy_spawn_timer
	))
	yellow_enemy_spawn_timer.timeout.connect(handle_spawn.bind(
		YellowEnemyScene,
		yellow_enemy_spawn_timer
	))
	pink_enemy_spawn_timer.timeout.connect(handle_spawn.bind(
		PinkEnemyScene,
		pink_enemy_spawn_timer
	))
	turret_spawn_timer.timeout.connect(handle_spawn.bind(
		TurretScene,
		turret_spawn_timer
	))
	
func handle_spawn(enemy_scene: PackedScene, timer: Timer):
	spawner_component.scene = enemy_scene
	spawner_component.spawn(
		Vector2(
			randf_range(margin, screen_width - margin),
			-16
		),
		get_tree().current_scene.get_node("%Enemies")
	)
	timer.start()

