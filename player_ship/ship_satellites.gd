extends Node2D

@export var radius = 60
@export var angle_increment = 180
@export var satellites_config: SatellitesConfig
@export var satellite_scene: PackedScene

@onready var container: Node2D = $Satellites

@onready var satellites = []

var current_angle = 0

func _ready():
	satellites_config.level_changed.connect(adjust_satellites)
	adjust_satellites(satellites_config.level)
	position_satellites()

func _process(delta):
	if satellites.size() == 0:
		return
	
	current_angle += angle_increment * delta
	position_satellites()
	
func adjust_satellites(level: int):
	var satellite_count: int = satellites.size()

	if satellite_count < level:
		var create_count = level - satellite_count
		
		for _i in range(create_count):
			var satellite = satellite_scene.instantiate()
			container.add_child(satellite)
			
			satellites.append(satellite)

	elif satellite_count > level:
		var remove_count = satellite_count - level
		print("should remove some")

func position_satellites():
	if satellites.size() == 0:
		return

	var angle_step = 360 / satellites.size()
	
	for index in range(satellites.size()):
		var angle = current_angle + index * angle_step
		var satellite = satellites[index]
		
		satellite.position = Vector2(
			cos(deg_to_rad(angle)) * radius,
			sin(deg_to_rad(angle)) * radius
		)
