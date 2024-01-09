extends ParallaxBackground

@onready var space_layer: ParallaxLayer = %SpaceLayer
@onready var far_stars_layer: ParallaxLayer = %FarStarsLayer
@onready var close_stars_layer: ParallaxLayer = %CloseStarsLayer

func _process(delta):
	space_layer.motion_offset.y += 50 * delta
	far_stars_layer.motion_offset.y += 80 * delta
	close_stars_layer.motion_offset.y += 110 * delta
