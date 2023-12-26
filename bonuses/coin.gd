extends Node2D

@export var points: int = 5
@export var game_stats: GameStats
@export var speed: int = 400

var player_position: Vector2
var target_position: Vector2
var distance_to_player: float

@onready var flash_component: FlashComponent = $FlashComponent
@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var move_component: MoveComponent = $MoveComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var area_2d: Area2D = $Area2D

var player: Node2D

func _ready():
	flash_component.flash()
	scale_component.tween_scale()
	await get_tree().create_timer(0.4).timeout
	
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	area_2d.area_entered.connect(on_pickup.unbind(1))

func _physics_process(_delta):
	var players = get_tree().get_nodes_in_group("player")
	if players:
		player_position = players[0].global_position
		distance_to_player = global_position.distance_to(player_position)

		if distance_to_player > 10 && distance_to_player < 200:
			target_position = (player_position - global_position).normalized() * speed

			move_component.velocity.x = target_position.x
			move_component.velocity.y = target_position.y

		else:
			move_component.velocity.x = 0
			move_component.velocity.y = 40

func on_pickup():
	game_stats.score += points
	SoundPlayer.play_sound(SoundPlayer.COIN, -30)
	
	queue_free()
