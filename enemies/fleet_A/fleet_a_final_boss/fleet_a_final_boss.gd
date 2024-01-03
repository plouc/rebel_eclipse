class_name FleetAFinalBoss
extends Node2D

@export var game_stats: GameStats
@export var angle_adjustment_duration: float = 1.2

@onready var root_anchor: Node2D = $RootAnchor
@onready var heads_container: Node2D = $RootAnchor/HeadsContainer
@onready var heads_start_timer: Timer = $State/HeadsStartTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var rotation_by_difficulty = {
	GameStats.Difficulty.EASY: 10.0,
	GameStats.Difficulty.NORMAL: 20.0,
	GameStats.Difficulty.HARD: 30.0,
	GameStats.Difficulty.HELL: 40.0,
}

var heads: Array[FleetAFinalBossHead] = []
var started_head_index: int = 0

func _ready():
	for child in heads_container.get_children():
		heads.append(child as FleetAFinalBossHead)

	var angle_step: float = 360.0 / heads.size()
	for head_index in range(heads.size()):
		var head: FleetAFinalBossHead = heads[head_index]
		head.dead.connect(_on_head_death)
		head.rotation_degrees = head_index * angle_step

	heads_start_timer.timeout.connect(func():
		var head: FleetAFinalBossHead = heads[started_head_index]
		head.start()
		
		started_head_index += 1
		if started_head_index >= heads.size():
			heads_start_timer.stop()
	)
	
	animation_player.animation_finished.connect(func(anim_name: String):
		if anim_name == "enter":
			heads_start_timer.start()
			animation_player.play("oscillate")
	)

func _process(delta):
	root_anchor.rotation_degrees += rotation_by_difficulty[game_stats.difficulty] * delta

func _on_head_death(head: FleetAFinalBossHead):
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
