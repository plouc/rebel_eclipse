extends AnimatedSprite2D

func _ready() -> void:
	animation_finished.connect(queue_free)
	animation_looped.connect(queue_free)
