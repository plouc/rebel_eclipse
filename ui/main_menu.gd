extends Control

@onready var play_button = $CenterContainer/VBoxContainer/PlayButton
@onready var training_button = $CenterContainer/VBoxContainer/TrainingButton

func _ready():
	play_button.pressed.connect(_on_play_button_pressed)
	training_button.pressed.connect(_on_training_button_pressed)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		_play()

func _on_play_button_pressed():
	_play()

func _play():
	get_tree().change_scene_to_file("res://game.tscn")

func _on_training_button_pressed():
	get_tree().change_scene_to_file("res://ui/training_menu.tscn")
