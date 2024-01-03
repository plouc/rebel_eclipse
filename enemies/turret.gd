extends Node2D

@export var game_stats: GameStats
@export var rotation_speed = 20

@onready var rotating_anchor = $RotatingAnchor
@onready var bullets_spawners: Node2D = $RotatingAnchor/BulletsSpawners
@onready var stats_component: StatsComponent = $State/StatsComponent
@onready var flash_component: FlashComponent = $Effects/FlashComponent
@onready var shake_component: ShakeComponent = $Effects/ShakeComponent
@onready var scale_component: ScaleComponent = $Effects/ScaleComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var power_up_bullets_spawner: SpawnerComponent = $PowerUpBulletsSpawner
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var score_component: ScoreComponent = $State/ScoreComponent
@onready var preview = $Preview

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
		
		score_component.adjust_score()

		power_up_bullets_spawner.spawn()

		game_stats.chained_kills += 1

		queue_free()
	)

func _process(delta):
	rotating_anchor.rotation_degrees += rotation_speed * delta
