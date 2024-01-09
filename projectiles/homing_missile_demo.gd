extends Node2D

@onready var spawners: Node2D = $Spawners
@onready var spawning_timer: Timer = $SpawningTimer

func _ready():
	spawning_timer.timeout.connect(_spawn)
	_spawn()

func _spawn():
	for child in spawners.get_children():
		var spawner = child as SpawnerComponent
		spawner.spawn()
