class_name SatellitesConfig
extends Resource

var max_level: int = 9

signal level_changed(new_level: int)

@export var level: int = 0 :
	set(value):
		if value <= max_level:
			level = value
			level_changed.emit(level)

func reset_level():
	level = 0
	
func bump_level():
	if level < max_level:
		level += 1
