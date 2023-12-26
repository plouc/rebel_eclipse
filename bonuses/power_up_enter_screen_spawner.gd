extends Node2D

@export var power_up_scene: PackedScene

@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D
@onready var spawner_component: SpawnerComponent = $SpawnerComponent

func _ready():
	visible_on_screen_notifier_2d.screen_entered.connect(spawn)
	
func spawn():
	spawner_component.scene = power_up_scene
	spawner_component.spawn()
	

