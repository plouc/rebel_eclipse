extends Node2D

@export var game_stats: GameStats
@export var points: int = 5
@export var speed: float = 500.0
@export var delay_before_active: float = 0.6
@export var detection_distance_threshold: float = 160.0
@export var picked_distance_threshold: float = 5.0

var player_position: Vector2
var target_position: Vector2
var distance_to_player: float

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var flash_component: FlashComponent = $FlashComponent
@onready var move_component: MoveComponent = $MoveComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var area_2d: Area2D = $Area2D

var player: Node2D

func _ready():
	game_stats.spawned_coin_count += 1

	var frame_count: int = animated_sprite_2d.sprite_frames.get_frame_count("default")
	animated_sprite_2d.frame = randi_range(0, frame_count - 1)

	flash_component.flash()
	await get_tree().create_timer(delay_before_active).timeout
	
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	area_2d.area_entered.connect(on_pickup.unbind(1))

func _physics_process(_delta):
	var players = get_tree().get_nodes_in_group("player")
	if players:
		player_position = players[0].global_position
		distance_to_player = global_position.distance_to(player_position)

		if distance_to_player < picked_distance_threshold:
			on_pickup()
		elif distance_to_player < detection_distance_threshold:
			target_position = (player_position - global_position).normalized() * speed

			move_component.velocity.x = target_position.x
			move_component.velocity.y = target_position.y

		else:
			move_component.velocity.x = 0
			move_component.velocity.y = 40

func on_pickup():
	game_stats.score += points
	game_stats.collected_coin_count += 1
	SoundPlayer.play(SoundPlayer.COINS, -20)

	queue_free()
