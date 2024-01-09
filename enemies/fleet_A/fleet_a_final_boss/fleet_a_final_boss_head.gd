class_name FleetAFinalBossHead
extends Node2D

@export var game_stats: GameStats
@export var initial_health: float = 2000.0
@export var second_stage_health_threshold: float = 1000.0

@onready var intro_animated_sprite: AnimatedSprite2D = $IntroAnimatedSprite
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shell_animated_sprite: AnimatedSprite2D = $ShellAnimatedSprite
@onready var skeleton_base_animated_sprite: AnimatedSprite2D = $SkeletonBaseAnimatedSprite
@onready var skeleton_cage_animated_sprite: AnimatedSprite2D = $SkeletonCageAnimatedSprite
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
@onready var collision_box_component: CollisionBoxComponent = $LaserBeamAnchor/CollisionBoxComponent

var weapons_config_by_difficulty = {
	GameStats.Difficulty.EASY: {
		"laser_ray_count": 2,
		"bullets_firing_interval": 1.2,
		"bullets_outer_burst_amount": 3,
	},
	GameStats.Difficulty.NORMAL: {
		"laser_ray_count": 3,
		"bullets_firing_interval": 1.0,
		"bullets_outer_burst_amount": 5,
	},
	GameStats.Difficulty.HARD: {
		"laser_ray_count": 4,
		"bullets_firing_interval": 0.6,
		"bullets_outer_burst_amount": 7,
	},
	GameStats.Difficulty.HELL: {
		"laser_ray_count": 5,
		"bullets_firing_interval": 0.4,
		"bullets_outer_burst_amount": 13,
	},
}

var stage: int = 0
var flash_effect: FlashComponent

signal dead(head)

func _ready():
	laser_beam.is_paused = true
	_adjust_laser_for_difficulty(game_stats.difficulty)

	flash_effect = shell_flash_component

	_switch_bullets(false)
	_adjust_bullets_for_difficulty(game_stats.difficulty)
	
	game_stats.difficulty_update.connect(func(difficulty):
		_adjust_laser_for_difficulty(difficulty)
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
	
	animated_sprite.hide()
	shell_animated_sprite.hide()
	skeleton_base_animated_sprite.hide()
	skeleton_cage_animated_sprite.hide()

	expand_timer.timeout.connect(_expand)
	
	hurtbox_component.hurt.connect(func(_hitbox):
		flash_effect.flash()
		shell_shake_component.tween_shake()
	)
	hurtbox_component.process_mode = Node.PROCESS_MODE_DISABLED
	collision_box_component.process_mode = Node.PROCESS_MODE_DISABLED

	stats_component.max_health = initial_health
	stats_component.health = initial_health
	stats_component.health_changed.connect(func(health: float):
		if stage > 0:
			return

		if health <= second_stage_health_threshold:
			_second_stage()
	)
	stats_component.no_health.connect(_die)

func start():
	intro_animated_sprite.animation_finished.connect(_intro_completed)
	intro_animated_sprite.play("intro")

func _intro_completed():
	intro_animated_sprite.hide()
	animated_sprite.show()
	shell_animated_sprite.show()
	
	hurtbox_component.process_mode = Node.PROCESS_MODE_INHERIT
	collision_box_component.process_mode = Node.PROCESS_MODE_INHERIT

	_expand()

func _adjust_laser_for_difficulty(difficulty: GameStats.Difficulty):
	var ray_count: int = weapons_config_by_difficulty[difficulty]["laser_ray_count"]
	
	laser_beam.ray_count = ray_count

func _adjust_bullets_for_difficulty(difficulty: GameStats.Difficulty):
	var weapons_config = weapons_config_by_difficulty[difficulty]

	var firing_interval: float = weapons_config["bullets_firing_interval"]
	bullet_spawner_lefter.firing_interval = firing_interval
	bullet_spawner_left.firing_interval = firing_interval
	bullet_spawner_right.firing_interval = firing_interval
	bullet_spawner_righter.firing_interval = firing_interval
	
	var outer_burst_amount: int = weapons_config["bullets_outer_burst_amount"]
	bullet_spawner_lefter.burst_amount = outer_burst_amount
	bullet_spawner_righter.burst_amount = outer_burst_amount

func _switch_bullets(is_active: bool):
	bullet_spawner_lefter.is_active = is_active
	bullet_spawner_left.is_active = is_active
	bullet_spawner_right.is_active = is_active
	bullet_spawner_righter.is_active = is_active

func _expand():
	animated_sprite.play("expand")
	shell_animated_sprite.play("expand")
	skeleton_base_animated_sprite.play("expand")
	skeleton_cage_animated_sprite.play("expand")

	laser_position_animation.play("expand")

func _twist():
	laser_beam.is_paused = false

	_switch_bullets(false)

	animated_sprite.play("twist")
	shell_animated_sprite.play("twist")
	skeleton_base_animated_sprite.play("twist")
	skeleton_cage_animated_sprite.play("twist")

	laser_rotation_animation.play("twist")

func _retract():
	laser_beam.is_paused = true

	if stage == 0:
		_switch_bullets(true)

	animated_sprite.play("retract")
	shell_animated_sprite.play("retract")
	skeleton_base_animated_sprite.play("retract")
	skeleton_cage_animated_sprite.play("retract")

	laser_rotation_animation.stop()
	laser_position_animation.play("retract")
	
func _second_stage():
	SoundPlayer.play(SoundPlayer.PLAYER_EXPLOSION)
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
	skeleton_cage_animated_sprite.show()
	laser_beam.ray_count -= 1
	flash_effect = skeleton_cage_flash_effect
	stage = 1

func _die():
	SoundPlayer.play(SoundPlayer.PLAYER_EXPLOSION)
	SoundPlayer.play(SoundPlayer.PLAYER_EXPLOSION)
	explosion_spawner.spawn()
	explosion_spawner.spawn()
	explosion_spawner.spawn()
	explosion_spawner.spawn()
	explosion_spawner.spawn()
	explosion_spawner.spawn()
	explosion_spawner.spawn()
	queue_free()
	dead.emit(self)
