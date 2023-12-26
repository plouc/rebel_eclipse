class_name PinkEnemy
extends Node2D

@export var game_stats: GameStats

@onready var stats_component: StatsComponent = $State/StatsComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var scale_component: ScaleComponent = $Effects/ScaleComponent
@onready var flash_component: FlashComponent = $Effects/FlashComponent
@onready var shake_component: ShakeComponent = $Effects/ShakeComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
# @onready var hitbox_component: HitboxComponent = $HitboxComponent
# @onready var hurt_component: HurtComponent = $HurtComponent
# @onready var score_component: ScoreComponent = $ScoreComponent
@onready var power_up_bullets_spawner = $PowerUpBulletsSpawner
@onready var coin_grid: CoinGrid = $CoinGrid

func _ready():
	game_stats.spawned_enemy_count += 1

	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)

	hurtbox_component.hurt.connect(func(_hitbox: HitboxComponent):
		scale_component.tween_scale()
		flash_component.flash()
		shake_component.tween_shake()
	)
	
	stats_component.no_health.connect(func():
		SoundPlayer.play_sound(SoundPlayer.ENEMY_EXPLOSION)
		coin_grid.spawn()
		power_up_bullets_spawner.spawn()

		game_stats.killed_enemy_count += 1

		process_mode = Node.PROCESS_MODE_DISABLED
	)

	#hitbox_component.hit_hurtbox.connect(destroyed_component.destroy.unbind(1))
