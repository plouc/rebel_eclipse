class_name ChainedKillsTimerComponent
extends Node

@export var game_stats: GameStats
@export var duration: float = 3.0
@export var progress_bar: TextureProgressBar

var elapsed_time: float = 0.0

func _ready():
	game_stats.chained_kills_update.connect(func(count: int):
		if count > 0:
			elapsed_time = 0.0
	)
	
	elapsed_time = 0.0

func _process(delta: float):
	if game_stats.chained_kills == 0:
		progress_bar.value = 0
		return
	
	if elapsed_time >= duration:
		game_stats.chained_kills = 0
		elapsed_time = 0.0
		return

	elapsed_time += delta
	progress_bar.value = 100.0 - elapsed_time / duration * 100



