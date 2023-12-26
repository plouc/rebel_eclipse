class_name HealthBarComponent
extends Node

@export var progress_bar: ProgressBar
@export var color: Color = Color("ffffff")
@export var stats_component: StatsComponent

func _ready():
	var background = progress_bar.get_theme_stylebox("background").duplicate()
	background.border_color = color
	progress_bar.add_theme_stylebox_override("background", background)

	var fill = progress_bar.get_theme_stylebox("fill").duplicate()
	fill.bg_color = color
	progress_bar.add_theme_stylebox_override("fill", fill)
	
	progress_bar.value = stats_component.percentage()
	
	stats_component.health_changed.connect(func(_health):
		progress_bar.value = stats_component.percentage()
	)
