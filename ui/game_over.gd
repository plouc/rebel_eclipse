extends Control

@export var game_stats: GameStats

@onready var score_value: Label = %ScoreValue
@onready var high_score_value: Label = %HighScoreValue

func _ready():
	SoundPlayer.stop_named("main")
	SoundPlayer.play_named("main", SoundPlayer.GAME_OVER_SCREEN)

	if game_stats.score > game_stats.highscore:
		game_stats.highscore = game_stats.score

	score_value.text = str(game_stats.score)
	high_score_value.text = str(game_stats.highscore)

func exit():
	game_stats.score = 0
	
	SoundPlayer.play(SoundPlayer.UI_CONFIRM)
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		exit()
