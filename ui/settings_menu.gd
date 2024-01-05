extends Control

@export var game_stats: GameStats

@onready var difficulty_option_button: OptionButton = %DifficultyOptionButton
@onready var ship_speed_slider: HSlider = %ShipSpeedSlider
@onready var ship_speed_value_label: Label = %ShipSpeedValueLabel
@onready var done_button: Button = %DoneButton
@onready var power_up_extravaganza_check_button: CheckButton = %PowerUpExtravaganzaCheckButton

func _ready():
	for difficulty in game_stats.Difficulty.values():
		difficulty_option_button.add_item(
			game_stats.difficulty_label(difficulty as GameStats.Difficulty)
		)

	difficulty_option_button.selected = game_stats.difficulty
	difficulty_option_button.item_selected.connect(func(index: int):
		game_stats.difficulty = index as GameStats.Difficulty
	)
	difficulty_option_button.grab_focus()

	ship_speed_slider.min_value = game_stats.min_ship_speed
	ship_speed_slider.max_value = game_stats.max_ship_speed
	ship_speed_slider.step = 10.0
	ship_speed_slider.value = game_stats.ship_speed
	ship_speed_value_label.text = str(int(game_stats.ship_speed))

	ship_speed_slider.value_changed.connect(func(value: float):
		game_stats.ship_speed = value
		ship_speed_value_label.text = str(int(value))
	)

	power_up_extravaganza_check_button.toggled.connect(func(flag: bool):
		game_stats.is_power_up_extravaganza_enabled = flag
	)
	power_up_extravaganza_check_button.button_pressed = game_stats.is_power_up_extravaganza_enabled

	done_button.pressed.connect(func():
		get_tree().change_scene_to_file("res://ui/main_menu.tscn")
	)
