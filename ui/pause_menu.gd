extends Control

@export var game: Game

@onready var resume_button: Button = %ResumeButton
@onready var exit_button: Button = %ExitButton

func _ready():
	hide()

	game.toggle_game_paused.connect(_on_game_toggle_paused)
	
	resume_button.pressed.connect(_on_resume_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

func _on_game_toggle_paused(is_paused: bool):
	if is_paused:
		show()
		resume_button.grab_focus()
	else:
		hide()

func _on_resume_button_pressed():
	game.is_paused = false

func _on_exit_button_pressed():
	game.is_paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
