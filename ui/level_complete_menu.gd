class_name LevelCompleteMenu
extends Control

@export var game_stats: GameStats

@onready var MainMenuButton: Button = %MainMenuButton

func _ready():
	hide()

	game_stats.level_completed.connect(func():
		show()
		_render_level_stats()
	)

	MainMenuButton.pressed.connect(_on_main_menu_button_pressed)

func _render_level_stats():
	pass
	
func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
