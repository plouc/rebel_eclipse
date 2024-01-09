extends Control

@export var demo_name: String
@export var game_stats: GameStats

@onready var demo_name_label: Label = %DemoNameLabel
@onready var difficulty_option_button: OptionButton = %DifficultyOptionButton

func _ready():
	var original_difficulty = game_stats.difficulty

	tree_exited.connect(func():
		game_stats.difficulty = original_difficulty
	)
	
	if demo_name:
		demo_name_label.text = demo_name

	difficulty_option_button.grab_focus()

func _input(event):
	if event.is_action_pressed("ui_back"):
		get_tree().change_scene_to_file("res://ui/misc_menu.tscn")
