extends Control

@export var game_stats: GameStats

@onready var difficulty_option_button: OptionButton = %DifficultyOptionButton
@onready var ship_speed_slider: HSlider = %ShipSpeedSlider
@onready var ship_speed_value_label: Label = %ShipSpeedValueLabel
@onready var done_button: Button = %DoneButton
@onready var power_up_extravaganza_check_button: CheckButton = %PowerUpExtravaganzaCheckButton

func _ready():
	difficulty_option_button.grab_focus()

	ship_speed_slider.min_value = game_stats.min_ship_speed
	ship_speed_slider.max_value = game_stats.max_ship_speed
	ship_speed_slider.step = 10.0
	ship_speed_slider.value = game_stats.ship_speed
	ship_speed_value_label.text = str(int(game_stats.ship_speed))

	ship_speed_slider.value_changed.connect(func(value: float):
		SoundPlayer.play(SoundPlayer.UI_SLIDER_MOVE)
		game_stats.ship_speed = value
		ship_speed_value_label.text = str(int(value))
	)

	power_up_extravaganza_check_button.button_pressed = game_stats.is_power_up_extravaganza_enabled
	power_up_extravaganza_check_button.toggled.connect(func(flag: bool):
		SoundPlayer.play(SoundPlayer.UI_TOGGLE_ON if flag else SoundPlayer.UI_SLIDER_MOVE)
		game_stats.is_power_up_extravaganza_enabled = flag
	)

	done_button.pressed.connect(_on_done_button_pressed)

func _input(event):
	if event.is_action_pressed("ui_back"):
		get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _on_done_button_pressed():
	SoundPlayer.play(SoundPlayer.UI_CONFIRM)
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
