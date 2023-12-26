class_name FleetASheep02
extends Node2D

@export var game_stats: GameStats

@onready var intro_timer: Timer = $State/IntroTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $Anchor/SubAnchor/AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $State/AnimationPlayer
@onready var move_component: MoveComponent = $State/MoveComponent
@onready var flash_component: FlashComponent = $Effects/FlashComponent
@onready var hurtbox_component: HurtboxComponent = $Anchor/SubAnchor/HurtboxComponent
@onready var shake_component: ShakeComponent = $Effects/ShakeComponent
@onready var stats_component: StatsComponent = $State/StatsComponent
@onready var coin_grid: CoinGrid = $CoinGrid
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var score_component: ScoreComponent = $State/ScoreComponent
@onready var bullet_spawner: BulletSpawner = $Anchor/SubAnchor/BulletSpawner
@onready var thruster: AnimatedSprite2D = $Anchor/SubAnchor/Thruster

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

	stats_component.no_health.connect(_die)

func _intro_completed():
	animated_sprite_2d.play("spinning")
	animation_player.play("new_animation")
	move_component.velocity.y = 80
	hurtbox_component.process_mode = Node.PROCESS_MODE_INHERIT
	bullet_spawner.is_active = true
	thruster.visible = true
	thruster.play()

func _hit():
	flash_component.flash()
	shake_component.tween_shake()

func _die():
	SoundPlayer.play_sound(SoundPlayer.ENEMY_EXPLOSION)
	coin_grid.spawn()

	score_component.adjust_score()
	game_stats.killed_enemy_count += 1
	
	process_mode = Node.PROCESS_MODE_DISABLED

