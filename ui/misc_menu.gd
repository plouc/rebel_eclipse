extends Control

@onready var bullets_demo_button: Button = %BulletsDemoButton
@onready var first_boss_demo_button: Button = %FirstBossDemoButton
@onready var fleet_a_ship_00_demo_button: Button = %FleetAShip00DemoButton
@onready var fleet_a_ship_01_demo_button: Button = %FleetAShip01DemoButton
@onready var fleet_a_ship_02_demo_button: Button = %FleetAShip02DemoButton
@onready var fleet_a_tank_00_demo_button: Button = %FleetATank00DemoButton

var focused_button: Button

func _ready():
	bullets_demo_button.grab_focus()

	bullets_demo_button.focus_entered.connect(_on_button_focus)
	bullets_demo_button.pressed.connect(_on_bullets_demo_button_pressed)
	first_boss_demo_button.focus_entered.connect(_on_button_focus)
	first_boss_demo_button.pressed.connect(_on_first_boss_demo_button_pressed)
	fleet_a_ship_00_demo_button.focus_entered.connect(_on_button_focus)
	fleet_a_ship_00_demo_button.pressed.connect(_on_fleet_a_ship_00_demo_button_pressed)
	fleet_a_ship_01_demo_button.focus_entered.connect(_on_button_focus)
	fleet_a_ship_01_demo_button.pressed.connect(_on_fleet_a_ship_01_demo_button_pressed)
	fleet_a_ship_02_demo_button.focus_entered.connect(_on_button_focus)
	fleet_a_ship_02_demo_button.pressed.connect(_on_fleet_a_ship_02_demo_button_pressed)
	fleet_a_tank_00_demo_button.focus_entered.connect(_on_button_focus)
	fleet_a_tank_00_demo_button.pressed.connect(_on_fleet_a_tank_00_demo_button_pressed)

func _input(event):
	if event.is_action_pressed("ui_back"):
		get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _on_button_focus():
	SoundPlayer.play(SoundPlayer.UI_ENTER_BUTTON)

func _on_bullets_demo_button_pressed():
	SoundPlayer.play(SoundPlayer.UI_CONFIRM)
	get_tree().change_scene_to_file("res://projectiles/bullets/bullets_demo.tscn")

func _on_first_boss_demo_button_pressed():
	SoundPlayer.play(SoundPlayer.UI_CONFIRM)
	get_tree().change_scene_to_file("res://enemies/fleet_A/fleet_a_final_boss/fleet_a_final_boss_demo.tscn")

func _on_fleet_a_ship_00_demo_button_pressed():
	SoundPlayer.play(SoundPlayer.UI_CONFIRM)
	get_tree().change_scene_to_file("res://enemies/fleet_A/fleet_a_ship_00/fleet_a_ship_00_demo.tscn")

func _on_fleet_a_ship_01_demo_button_pressed():
	SoundPlayer.play(SoundPlayer.UI_CONFIRM)
	get_tree().change_scene_to_file("res://enemies/fleet_A/fleet_a_ship_01/fleet_a_ship_01_demo.tscn")

func _on_fleet_a_ship_02_demo_button_pressed():
	SoundPlayer.play(SoundPlayer.UI_CONFIRM)
	get_tree().change_scene_to_file("res://enemies/fleet_A/fleet_a_ship_02/fleet_a_ship_02_demo.tscn")

func _on_fleet_a_tank_00_demo_button_pressed():
	SoundPlayer.play(SoundPlayer.UI_CONFIRM)
	get_tree().change_scene_to_file("res://enemies/fleet_A/fleet_a_tank_00/fleet_a_tank_00_demo.tscn")
