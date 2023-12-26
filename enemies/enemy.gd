extends Node2D

@export var game_stats: GameStats
@export var show_health_bar: bool = true

@onready var stats_component: StatsComponent = $StatsComponent
@onready var move_component: MoveComponent = $MoveComponent as MoveComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var flash_component: FlashComponent = $FlashComponent
@onready var shake_component: ShakeComponent = $ShakeComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurt_component: HurtComponent = $HurtComponent
@onready var destroyed_component: DestroyedComponent = $DestroyedComponent
@onready var score_component: ScoreComponent = $ScoreComponent
@onready var coin_grid: CoinGrid = $CoinGrid
@onready var progress_bar: ProgressBar = $ProgressBar

func _ready():
	game_stats.spawned_enemy_count += 1

	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)

	hurtbox_component.hurt.connect(func(_hitbox: HitboxComponent):
		scale_component.tween_scale()
		flash_component.flash()
		shake_component.tween_shake()
	)

	stats_component.no_health.connect(func():
		score_component.adjust_score()
		SoundPlayer.play_sound(SoundPlayer.ENEMY_EXPLOSION)
		coin_grid.spawn()

		game_stats.killed_enemy_count += 1

		queue_free()
	)

	hitbox_component.hit_hurtbox.connect(destroyed_component.destroy.unbind(1))
	
	if !show_health_bar:
		progress_bar.visible = false
