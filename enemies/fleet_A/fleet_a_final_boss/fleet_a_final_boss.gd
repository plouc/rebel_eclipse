class_name FleetAFinalBoss
extends Node2D

const AUDIO_LOOP = preload("res://sounds/boss_loop.wav")

@export var game_stats: GameStats
@export var angle_adjustment_duration: float = 1.2
@export var heads_deployment_initial_delay: float = 1.0
@export var delay_between_head_deployment: float = 0.2
@export var heads_deployment_shake_amount: float = 6.0
@export var heads_deployment_shake_duration: float = 2.0
@export var head_death_shake_amount: float = 10.0
@export var head_death_shake_duration: float = 1.4

@onready var root_anchor: Node2D = $RootAnchor
@onready var heads_container: Node2D = $RootAnchor/RootEffectsAnchor/HeadsContainer
@onready var heads_start_timer: Timer = $State/HeadsStartTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shake_component: ShakeComponent = $Effects/ShakeComponent

var rotation_by_difficulty = {
	GameStats.Difficulty.EASY: 10.0,
	GameStats.Difficulty.NORMAL: 20.0,
	GameStats.Difficulty.HARD: 30.0,
	GameStats.Difficulty.HELL: 50.0,
}

var heads: Array[FleetAFinalBossHead] = []
var started_head_index: int = 0

func _ready():
	SoundPlayer.fade_transition("main", AUDIO_LOOP, 2.0, 5.0)
	tree_exited.connect(func():
		SoundPlayer.stop_named("main")
	)

	for child in heads_container.get_children():
		heads.append(child as FleetAFinalBossHead)

	var angle_step: float = 360.0 / heads.size()
	for head_index in range(heads.size()):
		var head: FleetAFinalBossHead = heads[head_index]
		head.dead.connect(_on_head_death)
		head.rotation_degrees = head_index * angle_step

	shake_component.shake_amount = heads_deployment_shake_amount
	shake_component.shake_duration = heads_deployment_shake_duration

	heads_start_timer.wait_time = delay_between_head_deployment
	heads_start_timer.timeout.connect(func():
		var head: FleetAFinalBossHead = heads[started_head_index]
		head.start()

		started_head_index += 1
		if started_head_index >= heads.size():
			heads_start_timer.stop()
	)
	
	animation_player.animation_finished.connect(func(anim_name: String):
		if anim_name == "enter":
			_deploy_heads()
			animation_player.play("oscillate")
	)

func _process(delta):
	root_anchor.rotation_degrees += rotation_by_difficulty[game_stats.difficulty] * delta

func _deploy_heads():
	shake_component.tween_shake()
	await get_tree().create_timer(heads_deployment_initial_delay).timeout
	heads_start_timer.start()

func _on_head_death(head: FleetAFinalBossHead):
	shake_component.shake_amount = head_death_shake_amount
	shake_component.shake_duration = head_death_shake_duration
	shake_component.tween_shake()

	var head_index = heads.find(head)
	if head_index > -1:
		heads.remove_at(head_index)
		_adjust_heads_rotation()
	
	if heads.size() == 0:
		game_stats.level_completed.emit()
		queue_free()

func _adjust_heads_rotation():
	var angle_step: float = 360.0 / heads.size()
	for head_index in range(heads.size()):
		var head: FleetAFinalBossHead = heads[head_index]
		
		var tween = create_tween().set_ease(Tween.EASE_OUT)
		tween.tween_property(
			head, "rotation_degrees",
			head_index * angle_step,
			angle_adjustment_duration
		).from_current()
