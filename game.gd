class_name Game
extends Node2D

@export var game_stats: GameStats
@export var bullets_config: BulletsConfig
@export var satellites_config: SatellitesConfig
@export var laser_config: LaserConfig

@onready var camera: Camera2D = $Camera2D
@onready var ship: Ship = $Level/Ship
@onready var score_label: Label = %ScoreLabel
@onready var health_progress_bar: TextureProgressBar = %HealthProgressBar
@onready var bullets_level_progress_bar: TextureProgressBar = %BulletsLevelProgressBar
@onready var bullets_level_label: Label = %BulletsLevelLabel
@onready var satellites_indicator: Control = %SatellitesIndicator
@onready var satellites_level_progress_bar: TextureProgressBar = %SatellitesLevelProgressBar
@onready var satellites_level_label: Label = %SatellitesLevelLabel
@onready var chained_kills_label: Label = %ChainedKillsLabel
@onready var chained_kills_container: Control = %ChainedKillsContainer
@onready var best_chained_kills_label: Label = %BestChainedKillsLabel
@onready var killed_enemy_count_label: Label = %KilledEnemyCountLabel
@onready var killed_enemies_completion_label: Label = %KilledEnemiesCompletionLabel
@onready var killed_enemies_completion_progress_bar: ProgressBar = %KilledEnemiesCompletionProgressBar
@onready var hyper_level_label: Label = %HyperLevelLabel
@onready var hyper_level_progress_bar: ProgressBar = %HyperLevelProgressBar
@onready var difficulty_label: Label = %DifficultyLabel
@onready var player_bullets: Node2D = %PlayerBullets
@onready var player_bullets_stats_count: Label = %PlayerBulletsStatsCount
@onready var enemies_bullets: Node2D = %EnemiesBullets
@onready var enemy_bullets_stats_count: Label = %EnemyBulletsStatsCount
@onready var terrestrial_enemies: Node2D = %TerrestrialEnemies
@onready var terrestrial_enemies_stats_count: Label = %TerrestrialEnemiesStatsCount
@onready var enemies: Node2D = %Enemies
@onready var enemies_stats_count: Label = %EnemiesStatsCount
@onready var aerial_enemies: Node2D = %AerialEnemies
@onready var aerial_enemies_stats_count: Label = %AerialEnemiesStatsCount
@onready var bonuses: Node2D = %Bonuses
@onready var bonuses_stats_count: Label = %BonusesStatsCount
@onready var coins: Node2D = %Coins
@onready var coins_stats_count: Label = %CoinsStatsCount
@onready var explosions: Node2D = %Explosions
@onready var explosions_stats_count: Label = %ExplosionsStatsCount
@onready var level_complete_menu: LevelCompleteMenu = $CanvasLayer/LevelCompleteMenu

var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")

signal toggle_game_paused(is_paused: bool)

var is_paused: bool = false:
	set(value):
		is_paused = value
		get_tree().paused = is_paused
		toggle_game_paused.emit(is_paused)

func _ready():
	game_stats.reset()
	bullets_config.reset_level()
	satellites_config.reset_level()
	laser_config.reset_level()

	update_score_label(game_stats.score)
	game_stats.score_changed.connect(update_score_label)

	update_player_health_label(ship.stats_component.health)
	ship.stats_component.health_changed.connect(update_player_health_label)

	update_bullets_level(bullets_config.level)
	bullets_config.level_changed.connect(update_bullets_level.unbind(1))

	update_satellites_level(satellites_config.level)
	satellites_config.level_changed.connect(update_satellites_level)
	
	update_difficulty(game_stats.difficulty)
	game_stats.difficulty_update.connect(update_difficulty)

	ship.tree_exiting.connect(func():
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://ui/game_over.tscn")
	)
	
	game_stats.spawned_enemy_count_update.connect(update_spawned_enemy_count_label)
	game_stats.spawned_enemy_count = 0

	game_stats.killed_enemy_count_update.connect(update_killed_enemy_count_label)
	game_stats.killed_enemy_count = 0
	
	game_stats.chained_kills_update.connect(update_chained_kills_label)
	update_chained_kills_label(0)

	game_stats.best_chained_kills_update.connect(update_best_chained_kills_label)
	
	game_stats.hyper_level_update.connect(update_hyper_level)
	game_stats.hyper_level = 0
	
	game_stats.level_completed.connect(func():
		print("> LEVEL COMPLETE")
		ship.process_mode = Node.PROCESS_MODE_DISABLED
	)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		is_paused = !is_paused
		
	elif event.is_action_pressed("ui_difficulty_next"):
		if game_stats.difficulty < game_stats.Difficulty.HELL:
			game_stats.difficulty += 1
		else:
			game_stats.difficulty = game_stats.Difficulty.EASY

func _process(_delta):
	_update_objects_stats()

	#var half_viewport = viewport_width / 2
	#var ship_x = ship.global_position.x - half_viewport
	#var mult = -1 if ship_x < 0 else 1
	#var ratio = min(abs(ship_x) / half_viewport, 1.0) * mult
	
	#var new_x = clamp(
	#	camera.global_position.x + -ratio * 100.0 * delta,
	#	-48, 48
	#)

	#camera.global_position = Vector2(
	#	new_x,
	#	camera.global_position.y,
	#)
	
func _update_objects_stats() -> void:
	player_bullets_stats_count.text = str(player_bullets.get_child_count())
	enemy_bullets_stats_count.text = str(enemies_bullets.get_child_count())
	terrestrial_enemies_stats_count.text = str(terrestrial_enemies.get_child_count())
	enemies_stats_count.text = str(enemies.get_child_count())
	aerial_enemies_stats_count.text = str(aerial_enemies.get_child_count())
	bonuses_stats_count.text = str(bonuses.get_child_count())
	coins_stats_count.text = str(coins.get_child_count())
	explosions_stats_count.text = str(explosions.get_child_count())

func update_score_label(new_score: int) -> void:
	score_label.text = str(new_score)

func update_player_health_label(new_health: float) -> void:
	health_progress_bar.value = float(new_health) / float(ship.stats_component.max_health)
	
func update_bullets_level(level: int) -> void:
	bullets_level_progress_bar.value = float(level + 1) / float(bullets_config.max_level + 1)
	bullets_level_label.text = str(level + 1) + "/" + str(bullets_config.max_level + 1)

func update_satellites_level(level: int) -> void:
	if level > 0:
		satellites_level_progress_bar.value = float(level) / float(satellites_config.max_level)
		satellites_indicator.modulate = Color(1, 1, 1)
	else:
		satellites_level_progress_bar.value = 0
		satellites_indicator.modulate = Color(.6, .6, .6)

	satellites_level_label.text = str(level) + "/" + str(satellites_config.max_level)

func update_chained_kills_label(chained_kills: int) -> void:
	chained_kills_label.text = str(chained_kills)

	if chained_kills == 0:
		chained_kills_container.modulate = Color(.6, .6, .6)
	else:
		chained_kills_container.modulate = Color(1.0, 1.0, 1.0)

func update_best_chained_kills_label(best_chained_kills: int) -> void:
	best_chained_kills_label.text = "Best: " + str(best_chained_kills)
	
func update_spawned_enemy_count_label(spawned_enemy_count: int) -> void:
	killed_enemy_count_label.text = str(game_stats.killed_enemy_count) + "/" + str(spawned_enemy_count)
	
func update_killed_enemy_count_label(killed_enemy_count: int) -> void:
	killed_enemy_count_label.text = str(killed_enemy_count) + "/" + str(game_stats.spawned_enemy_count)

	var completion = 0.0
	if killed_enemy_count > 0:
		completion = float(killed_enemy_count) / float(game_stats.spawned_enemy_count) * 100.0

	killed_enemies_completion_label.text = str(round(completion)) + "%"
	killed_enemies_completion_progress_bar.value = completion

func update_hyper_level(hyper_level: int) -> void:
	hyper_level_label.text = str(hyper_level) + "/" + str(game_stats.max_hyper_level)
	hyper_level_progress_bar.value = float(hyper_level) / float(game_stats.max_hyper_level)

func update_difficulty(difficulty: GameStats.Difficulty) -> void:
	if difficulty == GameStats.Difficulty.EASY:
		difficulty_label.text = "Easy"
	elif difficulty == GameStats.Difficulty.NORMAL:
		difficulty_label.text = "Normal"
	elif difficulty == GameStats.Difficulty.HARD:
		difficulty_label.text = "Hard"
	elif difficulty == GameStats.Difficulty.HELL:
		difficulty_label.text = "Hell"
