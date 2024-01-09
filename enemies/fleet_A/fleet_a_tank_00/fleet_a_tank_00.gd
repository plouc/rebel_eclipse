class_name FleetATank00
extends Node2D

@export var game_stats: GameStats

@onready var intro_timer = $State/IntroTimer
@onready var move_component: MoveComponent = $State/MoveComponent
@onready var stats_component: StatsComponent = $State/StatsComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var flash_component: FlashComponent = $Effects/FlashComponent
@onready var shake_component: ShakeComponent = $Effects/ShakeComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var score_component: ScoreComponent = $State/ScoreComponent
@onready var bullet_spawner: BulletSpawner = $BulletsSpawners/BulletSpawner
@onready var base_animated_sprite: AnimatedSprite2D = $Anchor/BaseAnimatedSprite
@onready var turret_animated_sprite: AnimatedSprite2D = $Anchor/TurretAnimatedSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coin_grid: CoinGrid = $CoinGrid

const bullets_spawn_interval_by_difficulty = {
	GameStats.Difficulty.EASY: 1.0,
	GameStats.Difficulty.NORMAL: 0.5,
	GameStats.Difficulty.HARD: 0.25,
	GameStats.Difficulty.HELL: 0.2,
}

func _ready():
	game_stats.spawned_enemy_count += 1
	
	intro_timer.timeout.connect(_intro_completed)

	visible_on_screen_notifier_2d.screen_entered.connect(func():
		intro_timer.start()
	)
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	
	hurtbox_component.hurt.connect(func(_hitbox):
		flash_component.flash()
		shake_component.tween_shake()
	)
	
	stats_component.no_health.connect(func():
		SoundPlayer.play(SoundPlayer.ENEMY_EXPLOSION)
		coin_grid.spawn()
		
		score_component.adjust_score()
		game_stats.killed_enemy_count += 1

		queue_free()
	)

	var bullet_spawner_interval: float = bullets_spawn_interval_by_difficulty[game_stats.difficulty]
	bullet_spawner.firing_interval = bullet_spawner_interval

func _intro_completed() -> void:
	var velocity = Vector2(40, 40)

	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(move_component, "velocity", velocity, 2.0).from_current()

	bullet_spawner.is_active = true
	base_animated_sprite.play()
	turret_animated_sprite.play()
	animation_player.play("bullets_spawners_animation")
