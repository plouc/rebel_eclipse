class_name FleetAShip00
extends Node2D

@export var game_stats: GameStats

@onready var move_component: MoveComponent = $State/MoveComponent
@onready var intro_animation_timer: Timer = $State/IntroAnimationTimer
@onready var ship_animated_sprite: AnimatedSprite2D = $Anchor/ShipAnimatedSprite
@onready var thruster_animated_sprite: AnimatedSprite2D = $Anchor/ThrusterAnimatedSprite
@onready var left_bullet_spawner: BulletSpawner = $Anchor/LeftBulletSpawner
@onready var right_bullet_spawner: BulletSpawner = $Anchor/RightBulletSpawner
@onready var move_sinusoidal_component: MoveSinusoidalComponent = $State/MoveSinusoidalComponent
@onready var stats_component: StatsComponent = $State/StatsComponent
@onready var hurtbox_component: HurtboxComponent = $Anchor/HurtboxComponent
@onready var flash_component: FlashComponent = $Effects/FlashComponent
@onready var shake_component: ShakeComponent = $Effects/ShakeComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $Anchor/VisibleOnScreenNotifier2D
@onready var score_component: ScoreComponent = $State/ScoreComponent
@onready var coin_grid: CoinGrid = $Anchor/CoinGrid
@onready var collision_box_component: CollisionBoxComponent = $Anchor/CollisionBoxComponent

const weapons_config_by_difficulty = {
	GameStats.Difficulty.EASY: {
		"bullets_firing_interval": 2,
		"bullets_burst_amount": 3,
	},
	GameStats.Difficulty.NORMAL: {
		"bullets_firing_interval": 1.6,
		"bullets_burst_amount": 4,
	},
	GameStats.Difficulty.HARD: {
		"bullets_firing_interval": 1.2,
		"bullets_burst_amount": 5,
	},
	GameStats.Difficulty.HELL: {
		"bullets_firing_interval": 0.8,
		"bullets_burst_amount": 5,
	},
}

var sinusoidal_movement_speed = 40

func _ready():
	game_stats.spawned_enemy_count += 1

	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	
	hurtbox_component.hurt.connect(_hit.unbind(1))
	hurtbox_component.process_mode = Node.PROCESS_MODE_DISABLED
	collision_box_component.process_mode = Node.PROCESS_MODE_DISABLED
	
	stats_component.no_health.connect(_die)

	ship_animated_sprite.animation_finished.connect(func():
		if ship_animated_sprite.animation == "default":
			_intro_completed()
	)
	
	intro_animation_timer.timeout.connect(func():
		ship_animated_sprite.play()
	)

	_adjust_difficulty(game_stats.difficulty)
	game_stats.difficulty_update.connect(_adjust_difficulty)

func _intro_completed():
	thruster_animated_sprite.play("playing")
	
	hurtbox_component.process_mode = Node.PROCESS_MODE_INHERIT
	collision_box_component.process_mode = Node.PROCESS_MODE_INHERIT
	
	# move_sinusoidal_component.speed = sinusoidal_movement_speed

	left_bullet_spawner.is_active = true
	right_bullet_spawner.is_active = true

func _adjust_difficulty(difficulty: GameStats.Difficulty):
	var weapon_config = weapons_config_by_difficulty[difficulty]

	var firing_interval: float = weapon_config["bullets_firing_interval"]
	left_bullet_spawner.firing_interval = firing_interval
	right_bullet_spawner.firing_interval = firing_interval
	
	var burst_amount: int = weapon_config["bullets_burst_amount"]
	left_bullet_spawner.burst_amount = burst_amount
	right_bullet_spawner.burst_amount = burst_amount

func _hit():
	flash_component.flash()
	shake_component.tween_shake()

func _die():
	SoundPlayer.play(SoundPlayer.ENEMY_EXPLOSION)
	score_component.adjust_score()

	game_stats.killed_enemy_count += 1
	coin_grid.spawn()

	process_mode = Node.PROCESS_MODE_DISABLED
