extends Control

@onready var play_button: Button = %PlayButton
@onready var settings_button: Button = %SettingsButton
@onready var training_button: Button = %TrainingButton

func _ready():
	SoundPlayer.stop_all()

	play_button.pressed.connect(_on_play_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	training_button.pressed.connect(_on_training_button_pressed)
	
	play_button.grab_focus()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		pass
		# _play()

func _on_play_button_pressed():
	_play()

func _play():
	get_tree().change_scene_to_file("res://game.tscn")

func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://ui/settings_menu.tscn")

func _on_training_button_pressed():
	get_tree().change_scene_to_file("res://ui/training_menu.tscn")
