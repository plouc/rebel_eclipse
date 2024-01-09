extends Node2D

enum Stage { INIT, HEADS_SECOND_STAGE, HEADS_DESTROYED } 

@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var intro_delay_timer: Timer = $IntroDelayTimer
@onready var death_delay_timer: Timer = $DeathDelayTimer
@onready var break_panel: Panel = $CanvasLayer/Control/BreakPanel

var boss: FleetAFinalBoss
var stage: Stage = Stage.INIT
var can_advance_stages: bool = false
var head_count: int = 0
var head_count_in_second_stage: int = 0
var head_count_destroyed: int = 0

func _ready():
	intro_delay_timer.timeout.connect(func():
		head_count = boss.heads_container.get_child_count()
		can_advance_stages = true
		break_panel.show()
	)
	death_delay_timer.timeout.connect(func():
		spawn()
	)
	
	spawn()

func spawn():
	break_panel.hide()

	can_advance_stages = false
	stage = Stage.INIT

	head_count = 0
	head_count_in_second_stage = 0
	head_count_destroyed = 0

	boss = spawner_component.spawn() as FleetAFinalBoss
	intro_delay_timer.start()

func _input(event):
	if event.is_action_pressed("ui_demo_explode"):
		next_stage()

func next_stage():
	if not boss or not can_advance_stages:
		return

	if stage == Stage.INIT:
		transition_head_to_second_stage()
	elif stage == Stage.HEADS_SECOND_STAGE:
		destroy_head()

func transition_head_to_second_stage():
	var head: FleetAFinalBossHead = boss.heads_container.get_child(head_count_in_second_stage) as FleetAFinalBossHead
	head.stats_component.health = head.second_stage_health_threshold

	head_count_in_second_stage += 1
	if head_count_in_second_stage >= head_count:
		stage = Stage.HEADS_SECOND_STAGE

func destroy_head():
	var head: FleetAFinalBossHead = boss.heads_container.get_child(0) as FleetAFinalBossHead
	head.stats_component.health = 0

	head_count_destroyed += 1
	if head_count_destroyed >= head_count:
		stage = Stage.HEADS_DESTROYED
		death_delay_timer.start()

