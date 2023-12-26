class_name OnetimeAnimatedEffect
extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(queue_free)
	animated_sprite_2d.animation_looped.connect(queue_free)
