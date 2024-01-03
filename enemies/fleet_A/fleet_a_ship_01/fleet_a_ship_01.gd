class_name FleetAShip01
extends Node2D

@export var game_stats: GameStats
@export var switch_mode_interval: float = 2.0
@export var enter_screen_duration: float = 0.8
@export var enter_screen_y: float = 280.0
@export var intro_duration: float = 1.0
@export var attack_position_y: float = 140.0
@export var exit_duration: float = 1.0
@export var exit_position_y: float = 800.0
@export var attack_duration: float = 12.0

@onready var root_anchor: Node2D = $RootAnchor
@onready var ship_animated_sprite: AnimatedSprite2D = $RootAnchor/Anchor/ShipAnimatedSprite
@onready var laser_beam_left: LaserBeam = $RootAnchor/Anchor/LaserBeamLeft
@onready var laser_beam_center: LaserBeam = $RootAnchor/Anchor/LaserBeamCenter
@onready var laser_beam_right: LaserBeam = $RootAnchor/Anchor/LaserBeamRight
@onready var bullet_spawner_center = $RootAnchor/Anchor/BulletSpawnerCenter
@onready var progress_bar = $RootAnchor/Anchor/UI/ProgressBar
@onready var hurtbox_component: HurtboxComponent = $RootAnchor/Anchor/HurtboxComponent
@onready var visible_on_screen_notifier_2d = $RootAnchor/VisibleOnScreenNotifier2D
@onready var switch_mode_timer: Timer = $State/SwitchModeTimer
@onready var attack_timer: Timer = $State/AttackTimer
@onready var shake_component: ShakeComponent = $Effects/ShakeComponent
@onready var flash_component: FlashComponent = $Effects/FlashComponent
@onready var stats_component: StatsComponent = $State/StatsComponent
@onready var score_component: ScoreComponent = $State/ScoreComponent
@onready var ship_animation_player = $ShipAnimationPlayer
@onready var center_bullets_animation_player = $CenterBulletsAnimationPlayer
@onready var coin_grid: CoinGrid = $RootAnchor/Anchor/CoinGrid

var side_lasers_ray_count_per_difficulty = {
	GameStats.Difficulty.EASY: 1,
	GameStats.Difficulty.NORMAL: 2,
	GameStats.Difficulty.HARD: 3,
	GameStats.Difficulty.HELL: 4,
}
var center_laser_ray_count_per_difficulty = {
	GameStats.Difficulty.EASY: 2,
	GameStats.Difficulty.NORMAL: 3,
	GameStats.Difficulty.HARD: 4,
	GameStats.Difficulty.HELL: 5,
}
var center_bullets_spawn_interval_by_difficulty = {
	GameStats.Difficulty.EASY: 0.3,
	GameStats.Difficulty.NORMAL: 0.2,
	GameStats.Difficulty.HARD: 0.1,
	GameStats.Difficulty.HELL: 0.05,
}
var current_mode: String = "compact"

func _ready():
	game_stats.spawned_enemy_count += 1

	switch_mode_timer.wait_time = switch_mode_interval
	switch_mode_timer.timeout.connect(_switch_mode)
	
	attack_timer.wait_time = attack_duration
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_exit)
	
	hurtbox_component.process_mode = Node.PROCESS_MODE_DISABLED
	hurtbox_component.hurt.connect(_hit.unbind(1))

	stats_component.no_health.connect(_die)

	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)

	progress_bar.hide()
	
	_enter_screen()
	game_stats.difficulty_update.connect(_adjust_difficulty)
	_adjust_difficulty()

func _adjust_difficulty(difficulty: GameStats.Difficulty = game_stats.difficulty):
	var side_lasers_ray_count: int = side_lasers_ray_count_per_difficulty[difficulty]
	laser_beam_left.ray_count = side_lasers_ray_count
	laser_beam_right.ray_count = side_lasers_ray_count
	
	var center_laser_ray_count: int = center_laser_ray_count_per_difficulty[difficulty]
	laser_beam_center.ray_count = center_laser_ray_count
	
	var bullet_spawner_center_interval: float = center_bullets_spawn_interval_by_difficulty[difficulty]
	bullet_spawner_center.interval = bullet_spawner_center_interval

func _enter_screen() -> void:
	var entering_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	entering_tween.finished.connect(_entered_screen)

	entering_tween.tween_property(
		root_anchor,
		"position",
		Vector2(0, enter_screen_y),
		enter_screen_duration
	).from_current()
	
func _entered_screen() -> void:
	_play_intro()

func _play_intro():
	ship_animated_sprite.play("intro")

	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

	tween.finished.connect(_intro_completed)

	tween.tween_property(
		root_anchor,
		"position",
		Vector2(0, attack_position_y),
		intro_duration
	).from_current()

func _intro_completed():
	_switch_mode()
	switch_mode_timer.start()
	attack_timer.start()
	hurtbox_component.process_mode = Node.PROCESS_MODE_INHERIT
	ship_animated_sprite.animation_finished.connect(_enable_side_shots)
	ship_animation_player.play("floating")
	progress_bar.show()

func _exit():
	progress_bar.hide()
	switch_mode_timer.stop()
	ship_animation_player.pause()
	hurtbox_component.process_mode = Node.PROCESS_MODE_DISABLED
	bullet_spawner_center.is_active = false

	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

	tween.tween_property(
		root_anchor,
		"position",
		Vector2(0, exit_position_y),
		exit_duration
	).from_current()

func _enable_side_shots():
	if ship_animated_sprite.animation == "wide":
		laser_beam_left.is_paused = false
		laser_beam_center.is_paused = true
		laser_beam_right.is_paused = false
		
		bullet_spawner_center.is_active = true

func _to_wide_mode():
	ship_animated_sprite.play("wide")
	
	current_mode = "wide"

func _to_compact_mode():
	laser_beam_left.is_paused = true
	laser_beam_center.is_paused = false
	laser_beam_right.is_paused = true

	if game_stats.difficulty < GameStats.Difficulty.HARD:
		bullet_spawner_center.is_active = false
	
	ship_animated_sprite.play("compact")

	current_mode = "compact"

func _switch_mode():
	if current_mode == "compact":
		_to_wide_mode()
	else:
		_to_compact_mode()

func _hit():
	flash_component.flash()
	shake_component.tween_shake()

func _die():
	score_component.adjust_score()
	SoundPlayer.play_sound(SoundPlayer.PLAYER_EXPLOSION)
	
	coin_grid.spawn()
	
	game_stats.killed_enemy_count += 1
	
	process_mode = Node.PROCESS_MODE_DISABLED
