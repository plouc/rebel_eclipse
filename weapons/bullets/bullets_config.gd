class_name BulletsConfig
extends Resource

var spawners_config_by_level = [
	["top"],
	["top_left", "top_right"],
	["top_left", "top", "top_right"],
	["top_left_diagonal", "top_left", "top", "top_right", "top_right_diagonal"],
	["top_left_diagonal", "top_left", "top", "top_right", "top_right_diagonal", "bottom"],
	[
		"top_left_diagonal",
		"top_left",
		"top",
		"top_right",
		"top_right_diagonal",
		"bottom_right",
		"bottom_left",
	],
	[
		"left",
		"top_left_diagonal",
		"top_left",
		"top",
		"top_right",
		"top_right_diagonal",
		"right",
		"bottom_right",
		"bottom_left",
	],
	[
		"left",
		"top_left_diagonal",
		"top_left",
		"top",
		"top_right",
		"top_right_diagonal",
		"right",
		"bottom_right",
		"bottom",
		"bottom_left",
	],
]
var max_level: int = spawners_config_by_level.size() - 1

signal level_changed(new_level: int, config: Array[String])

@export var level: int = 0 :
	set(value):
		if value <= max_level:
			level = value
			level_changed.emit(level, spawners_config_by_level[level])

func reset_level():
	level = 0
	
func bump_level():
	if level < max_level:
		level += 1
