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

var sinusoidal_movement_speed = 40

func _ready():
	game_stats.spawned_enemy_count += 1

	move_component.velocity.y += randi_range(-40, 40)

	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	
	hurtbox_component.hurt.connect(_hit.unbind(1))
	hurtbox_component.process_mode = Node.PROCESS_MODE_DISABLED
	
	stats_component.no_health.connect(_die)

	ship_animated_sprite.animation_finished.connect(func():
		if ship_animated_sprite.animation == "default":
			_intro_completed()
	)
	
	intro_animation_timer.timeout.connect(func():
		ship_animated_sprite.play()
	)

func _intro_completed():
	thruster_animated_sprite.play("playing")
	
	hurtbox_component.process_mode = Node.PROCESS_MODE_INHERIT
	
	move_sinusoidal_component.speed = sinusoidal_movement_speed

	left_bullet_spawner.is_active = true
	right_bullet_spawner.is_active = true

func _hit():
	flash_component.flash()
	shake_component.tween_shake()

func _die():
	SoundPlayer.play_sound(SoundPlayer.ENEMY_EXPLOSION)
	score_component.adjust_score()

	game_stats.killed_enemy_count += 1
	coin_grid.spawn()

	process_mode = Node.PROCESS_MODE_DISABLED
