class_name StatsComponent
extends Node

@export var max_health: float = 1

@export var health: float = max_health:
	set(value):
		health = max(0, value)

		health_changed.emit(health)

		if health == 0: no_health.emit()

func percentage() -> float:
	return health / max_health * 100

signal health_changed(health)
signal no_health()
