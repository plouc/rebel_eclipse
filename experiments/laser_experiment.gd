extends Node2D

@onready var lasers: Node2D = $Lasers
@onready var lasers_timer: Timer = $State/LasersTimer

var are_laser_active: bool = true

func _ready():
	for laser in lasers.get_children():
		laser.is_paused = not are_laser_active

	lasers_timer.timeout.connect(_on_lasers_timer_tick)

func _on_lasers_timer_tick():
	are_laser_active = not are_laser_active

	for laser in lasers.get_children():
		laser.is_paused = not are_laser_active

