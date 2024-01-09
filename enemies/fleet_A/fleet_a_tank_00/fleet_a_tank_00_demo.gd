extends Node2D

@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var spawning_timer: Timer = $SpawningTimer

func _ready():
	spawning_timer.timeout.connect(func():
		spawner_component.spawn()
	)
