class_name GameStats
extends Resource

enum Difficulty { EASY, NORMAL, HARD, HELL }

signal difficulty_update(new_difficulty: Difficulty)

@export var difficulty: Difficulty = Difficulty.NORMAL:
	set(value):
		difficulty = value
		difficulty_update.emit(difficulty)

signal spawned_enemy_count_update(new_spawned_enemy_count: int)
signal level_completed()

var spawned_enemy_count: int = 0 :
	set(value):
		spawned_enemy_count = value
		spawned_enemy_count_update.emit(spawned_enemy_count)

signal killed_enemy_count_update(new_killed_enemy_count: int)

var killed_enemy_count: int = 0 :
	set(value):
		var killed_enemy_count_delta = value - killed_enemy_count

		killed_enemy_count = value
		killed_enemy_count_update.emit(killed_enemy_count)

		if killed_enemy_count_delta > 0:
			chained_kills += killed_enemy_count_delta

var best_chained_kills: int = 0

signal chained_kills_update(new_chained_kills: int)
signal best_chained_kills_update(new_best_chained_kills: int)

@export var chained_kills: int = 0 :
	set(value):
		if value == 0 && chained_kills > best_chained_kills:
			best_chained_kills = chained_kills
			best_chained_kills_update.emit(best_chained_kills)

		chained_kills = value
		chained_kills_update.emit(chained_kills)

var max_hyper_level: int = 5

signal hyper_level_update(new_hyper_level: int)

@export var hyper_level: int = 0 :
	set(value):
		if value <= max_hyper_level:
			hyper_level = value
			hyper_level_update.emit(hyper_level)

signal score_changed(new_score)

@export var score: int = 0 :
	set(value):
		score = value
		score_changed.emit(score)

@export var highscore: int = 0

func reset():
	score = 0
	hyper_level = 0
	spawned_enemy_count = 0
	killed_enemy_count = 0
	chained_kills = 0
	best_chained_kills = 0
