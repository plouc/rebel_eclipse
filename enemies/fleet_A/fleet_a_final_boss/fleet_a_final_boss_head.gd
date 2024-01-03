class_name FleetAFinalBossHead
extends Node2D

@export var game_stats: GameStats
@export var initial_health: float = 2000.0
@export var second_stage_health_threshold: float = 1000.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shell_animated_sprite: AnimatedSprite2D = $ShellAnimatedSprite
@onready var skeleton_base_animated_sprite: AnimatedSprite2D = $SkeletonBaseAnimatedSprite
@onready var shell_flash_component: FlashComponent = $Effects/ShellFlashComponent
@onready var shell_shake_component = $Effects/ShellShakeComponent
@onready var skeleton_cage_flash_effect = $Effects/SkeletonCageFlashEffect
@onready var laser_beam: LaserBeam = $LaserBeamAnchor/LaserBeam
@onready var laser_position_animation: AnimationPlayer = $LaserPositionAnimation
@onready var laser_rotation_animation: AnimationPlayer = $LaserRotationAnimation
@onready var bullet_spawner_lefter: BulletSpawner = $LaserBeamAnchor/BulletSpawnerLefter
@onready var bullet_spawner_left: BulletSpawner = $LaserBeamAnchor/BulletSpawnerLeft
@onready var bullet_spawner_right: BulletSpawner = $LaserBeamAnchor/BulletSpawnerRight
@onready var bullet_spawner_righter: BulletSpawner = $LaserBeamAnchor/BulletSpawnerRighter
@onready var expand_timer: Timer = $State/ExpandTimer
@onready var hurtbox_component: HurtboxComponent = $LaserBeamAnchor/HurtboxComponent
@onready var stats_component: StatsComponent = $State/StatsComponent
@onready var explosion_spawner:SpawnerComponent = $LaserBeamAnchor/ExplosionSpawner

var laser_rays_by_difficulty = {
	GameStats.Difficulty.EASY: 2,
	GameStats.Difficulty.NORMAL: 3,
	GameStats.Difficulty.HARD: 4,
	GameStats.Difficulty.HELL: 5,
}

var firing_interval_by_difficulty = {
	GameStats.Difficulty.EASY: 0.4,
	GameStats.Difficulty.NORMAL: 0.3,
	GameStats.Difficulty.HARD: 0.2,
	GameStats.Difficulty.HELL: 0.1,
}

var stage: int = 0
var flash_effect: FlashComponent

signal dead(head)

func _ready():
	laser_beam.is_paused = true
	laser_beam.ray_count = laser_rays_by_difficulty[game_stats.difficulty]
	
	flash_effect = shell_flash_component

	_switch_bullets(false)
	_adjust_bullets_for_difficulty(game_stats.difficulty)
	
	game_stats.difficulty_update.connect(func(difficulty):
		laser_beam.ray_count = laser_rays_by_difficulty[difficulty]
		_adjust_bullets_for_difficulty(difficulty)
	)
	
	animated_sprite.animation_finished.connect(func():
		if animated_sprite.animation == "expand":
			_twist()
		elif animated_sprite.animation == "twist":
			_retract()
		elif animated_sprite.animation == "retract":
			expand_timer.start()
	)
	
	skeleton_base_animated_sprite.hide()

	expand_timer.timeout.connect(_expand)
	
	hurtbox_component.process_mode = Node.PROCESS_MODE_DISABLED
	hurtbox_component.hurt.connect(func(_hitbox):
		flash_effect.flash()
		shell_shake_component.tween_shake()
	)

	stats_component.max_health = initial_health
	stats_component.health = initial_health
	stats_component.health_changed.connect(func(health: float):
		if stage > 0:
			return

		if health <= second_stage_health_threshold:
			_second_stage()
	)
	stats_component.no_health.connect(func():
		SoundPlayer.play_sound(SoundPlayer.PLAYER_EXPLOSION)
		SoundPlayer.play_sound(SoundPlayer.PLAYER_EXPLOSION)
		explosion_spawner.spawn()
		explosion_spawner.spawn()
		explosion_spawner.spawn()
		explosion_spawner.spawn()
		explosion_spawner.spawn()
		explosion_spawner.spawn()
		explosion_spawner.spawn()
		queue_free()
		dead.emit(self)
	)

func start():
	hurtbox_component.process_mode = Node.PROCESS_MODE_INHERIT

	_expand()

func _adjust_bullets_for_difficulty(difficulty: GameStats.Difficulty):
	var interval: float = firing_interval_by_difficulty[difficulty]

	bullet_spawner_lefter.interval = interval
	bullet_spawner_left.interval = interval
	bullet_spawner_right.interval = interval
	bullet_spawner_righter.interval = interval

func _switch_bullets(is_active: bool):
	bullet_spawner_lefter.is_active = is_active
	bullet_spawner_left.is_active = is_active
	bullet_spawner_right.is_active = is_active
	bullet_spawner_righter.is_active = is_active

func _expand():
	animated_sprite.play("expand")
	shell_animated_sprite.play("expand")
	skeleton_base_animated_sprite.play("expand")

	laser_position_animation.play("expand")

func _twist():
	laser_beam.is_paused = false

	_switch_bullets(false)

	animated_sprite.play("twist")
	shell_animated_sprite.play("twist")
	skeleton_base_animated_sprite.play("twist")

	laser_rotation_animation.play("twist")

func _retract():
	laser_beam.is_paused = true

	if stage == 0:
		_switch_bullets(true)

	animated_sprite.play("retract")
	shell_animated_sprite.play("retract")
	skeleton_base_animated_sprite.play("retract")

	laser_rotation_animation.stop()
	laser_position_animation.play("retract")
	
func _second_stage():
	SoundPlayer.play_sound(SoundPlayer.PLAYER_EXPLOSION)
	_switch_bullets(false)
	explosion_spawner.spawn()
	explosion_spawner.spawn()
	explosion_spawner.spawn()
	explosion_spawner.spawn()
	explosion_spawner.spawn()
	explosion_spawner.spawn()
	explosion_spawner.spawn()
	animated_sprite.hide()
	shell_animated_sprite.hide()
	skeleton_base_animated_sprite.show()
	laser_beam.ray_count -= 1
	flash_effect = skeleton_cage_flash_effect
	stage = 1
