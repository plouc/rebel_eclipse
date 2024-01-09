extends Control

@onready var play_button: Button = %PlayButton
@onready var settings_button: Button = %SettingsButton
@onready var misc_button: Button = %MiscButton

func _ready():
	play_button.grab_focus()
	
	play_button.focus_entered.connect(_on_button_focus)
	play_button.pressed.connect(_on_play_button_pressed)
	settings_button.focus_entered.connect(_on_button_focus)
	settings_button.pressed.connect(_on_settings_button_pressed)
	misc_button.focus_entered.connect(_on_button_focus)
	misc_button.pressed.connect(_on_misc_button_pressed)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		pass
		# _play()

func _on_button_focus():
	SoundPlayer.play(SoundPlayer.UI_ENTER_BUTTON)

func _on_play_button_pressed():
	SoundPlayer.play(SoundPlayer.UI_CONFIRM)
	_play()

func _play():
	get_tree().change_scene_to_file("res://game.tscn")

func _on_settings_button_pressed():
	SoundPlayer.play(SoundPlayer.UI_CONFIRM)
	get_tree().change_scene_to_file("res://ui/settings_menu.tscn")

func _on_misc_button_pressed():
	SoundPlayer.play(SoundPlayer.UI_CONFIRM)
	get_tree().change_scene_to_file("res://ui/misc_menu.tscn")

func _on_training_button_pressed():
	SoundPlayer.play(SoundPlayer.UI_CONFIRM)
	get_tree().change_scene_to_file("res://ui/training_menu.tscn")
