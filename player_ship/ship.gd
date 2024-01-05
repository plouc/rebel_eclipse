class_name Ship
extends Node2D

@export var game_stats: GameStats
@export var camera: Camera2D
@export var position_margin: = 8
@export var move_stats: MoveStats

@onready var animated_sprite_2d: AnimatedSprite2D = $Anchor/AnimatedSprite2D
@onready var move_component: MoveComponent = $Movement/MoveComponent
@onready var flame_animated_sprite: AnimatedSprite2D = $Anchor/FlameAnimatedSprite
@onready var scale_component: ScaleComponent = $Effects/ScaleComponent
@onready var flash_component: FlashComponent = $Effects/FlashComponent
@onready var shake_component: ShakeComponent = $Effects/ShakeComponent
@onready var stats_component: StatsComponent = $StatsComponent
@onready var hurtbox_component: HurtboxComponent = $Collision/HurtboxComponent

var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
var viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")

func _ready():
	stats_component.no_health.connect(_die)
	hurtbox_component.hurt.connect(_hit.unbind(1))
	hurtbox_component.crashed.connect(_die.unbind(1))
	
	move_stats.speed = game_stats.ship_speed

func _process(_delta: float) -> void:
	var edge_left = camera.global_position.x + position_margin
	var edge_right = camera.global_position.x + viewport_width - position_margin
	var edge_top = camera.global_position.y + position_margin
	var edge_bottom = camera.global_position.y + viewport_height - position_margin

	global_position.x = clamp(global_position.x, edge_left, edge_right)
	global_position.y = clamp(global_position.y, edge_top, edge_bottom)

	animate_the_ship()

func _hit():
	SoundPlayer.play(SoundPlayer.PLAYER_HIT)
	
	flash_component.flash()
	shake_component.tween_shake()
	scale_component.tween_scale()

func _die():
	SoundPlayer.play(SoundPlayer.PLAYER_EXPLOSION)
	queue_free()

func animate_the_ship() -> void:
	if move_component.velocity.x < 0:
		animated_sprite_2d.play("bank_left")
		# flame_animated_sprite.play("bank_left")
	elif move_component.velocity.x > 0:	
		animated_sprite_2d.play("bank_right")
		# flame_animated_sprite.play("bank_right")
	else:
		animated_sprite_2d.play("center")
		# flame_animated_sprite.play("center")
