@tool
class_name AnimatedTextureRect
extends TextureRect

@export var sprites: SpriteFrames
@export var current_animation: String = "default"
@export var frame_index: int = 0
@export_range(0.0, INF, 0.001) var speed_scale: float = 1.0
@export var auto_play: bool = false
@export var playing: bool = false

var _refresh_rate: float = 1.0
var _fps: float = 30.0
var _frame_delta: float = 0.0

func _ready():
	_fps = sprites.get_animation_speed(current_animation)
	_refresh_rate = sprites.get_frame_duration(current_animation, frame_index)
	
	texture = sprites.get_frame_texture(current_animation, frame_index)
	
	if auto_play:
		play()

func _process(delta):
	if sprites == null or playing == false:
		return
		
	if sprites.has_animation(current_animation) == false:
		playing = false
		assert(false, "Animation %s doesn't exist" % current_animation)
		
	_get_animation_data()

	_frame_delta += (speed_scale * delta)
	if _frame_delta >= _refresh_rate / _fps:
		texture = _get_next_frame()
		_frame_delta = 0.0

func play(animation_name: String = current_animation) -> void:
	frame_index = 0
	_frame_delta = 0.0
	current_animation = animation_name
	_get_animation_data()
	playing = true

func pause() -> void:
	playing = false

func resume() -> void:
	playing = true
	
func stop() -> void:
	frame_index = 0
	playing = false
	texture = sprites.get_frame_texture(current_animation, frame_index)

func _get_animation_data() -> void:
	_fps = sprites.get_animation_speed(current_animation)
	_refresh_rate = sprites.get_frame_duration(current_animation, frame_index)

func _get_next_frame() -> Texture2D:
	frame_index += 1
	var frame_count = sprites.get_frame_count(current_animation)

	if frame_index >= frame_count:
		frame_index = 0

		if not sprites.get_animation_loop(current_animation):
			playing = false

	_get_animation_data()
	
	return sprites.get_frame_texture(current_animation, frame_index)

