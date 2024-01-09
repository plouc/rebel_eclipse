extends Node2D

@onready var spawning_timer: Timer = $Spawners/SpawningTimer
@onready var spawner_component_00: SpawnerComponent = $Spawners/SpawnerComponent00
@onready var spawner_component_01: SpawnerComponent = $Spawners/SpawnerComponent01
@onready var spawner_component_02: SpawnerComponent = $Spawners/SpawnerComponent02

func _ready():
	spawning_timer.timeout.connect(spawn)
	spawn()

func spawn():
	spawner_component_00.spawn()
	spawner_component_01.spawn()
	spawner_component_02.spawn()
