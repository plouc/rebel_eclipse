class_name FleetASheep02
extends Node2D

@export var game_stats: GameStats

@onready var intro_timer: Timer = $State/IntroTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $Anchor/SubAnchor/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $State/AnimationPlayer
@onready var move_component: MoveComponent = $State/MoveComponent
@onready var flash_component: FlashComponent = $Effects/FlashComponent
@onready var hurtbox_component: HurtboxComponent = $Anchor/SubAnchor/HurtboxComponent
@onready var collision_box_component: CollisionBoxComponent = $Anchor/SubAnchor/CollisionBoxComponent
@onready var shake_component: ShakeComponent = $Effects/ShakeComponent
@onready var stats_component: StatsComponent = $State/StatsComponent
@onready var coin_grid: CoinGrid = $CoinGrid
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var score_component: ScoreComponent = $State/ScoreComponent
@onready var bullet_spawner: BulletSpawner = $Anchor/SubAnchor/BulletSpawner
@onready var thruster: AnimatedSprite2D = $Anchor/SubAnchor/Thruster

const weapons_config_by_difficulty = {
	GameStats.Difficulty.EASY: {
		"bullets_firing_interval": 1.4,
		"bullets_speed": 300.0,
		"bullets_burst_amount": 1,
		"bullets_burst_speed_increment": 0.0,
	},
	GameStats.Difficulty.NORMAL: {
		"bullets_firing_interval": 1.0,
		"bullets_speed": 300.0,
		"bullets_burst_amount": 1,
		"bullets_burst_speed_increment": 0.0,
	},
	GameStats.Difficulty.HARD: {
		"bullets_firing_interval": 0.8,
		"bullets_speed": 300.0,
		"bullets_burst_amount": 2,
		"bullets_burst_speed_increment": 50.0,
	},
	GameStats.Difficulty.HELL: {
		"bullets_firing_interval": 0.6,
		"bullets_speed": 300.0,
		"bullets_burst_amount": 3,
		"bullets_burst_speed_increment": 50.0,
	},
}

func _ready():
	game_stats.spawned_enemy_count += 1

	thruster.visible = false

	move_component.velocity.y = 0
	
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)

	animated_sprite_2d.animation_finished.connect(func():
		if animated_sprite_2d.animation == "intro":
			_intro_completed()
	)

	intro_timer.timeout.connect(func():
		animated_sprite_2d.play("intro")
	)

	hurtbox_component.hurt.connect(_hit.unbind(1))
	hurtbox_component.process_mode = Node.PROCESS_MODE_DISABLED
	collision_box_component.process_mode = Node.PROCESS_MODE_DISABLED

	stats_component.no_health.connect(_die)

	game_stats.difficulty_update.connect(_adjust_difficulty)
	_adjust_difficulty(game_stats.difficulty)

func _adjust_difficulty(difficulty: GameStats.Difficulty):
	var weapon_config = weapons_config_by_difficulty[difficulty]

	bullet_spawner.firing_interval = weapon_config["bullets_firing_interval"]
	bullet_spawner.bullet_speed = weapon_config["bullets_speed"]
	bullet_spawner.burst_amount = weapon_config["bullets_burst_amount"]
	bullet_spawner.burst_bullet_speed_increment = weapon_config["bullets_burst_speed_increment"]

func _intro_completed():
	animated_sprite_2d.play("spinning")
	animation_player.play("new_animation")
	move_component.velocity.y = 120

	hurtbox_component.process_mode = Node.PROCESS_MODE_INHERIT
	collision_box_component.process_mode = Node.PROCESS_MODE_INHERIT

	bullet_spawner.is_active = true
	thruster.visible = true
	thruster.play()

func _hit():
	flash_component.flash()
	shake_component.tween_shake()

func _die():
	SoundPlayer.play(SoundPlayer.ENEMY_EXPLOSION)
	coin_grid.spawn()

	score_component.adjust_score()
	game_stats.killed_enemy_count += 1
	
	set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
