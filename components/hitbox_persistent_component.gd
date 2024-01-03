class_name HitboxPersistentComponent
extends Area2D

@export var damage: float = 1.0
@export var damage_interval: float = 0.2

var _current_hurtbox: HurtboxComponent
var _elapsed_time: float = 0.0

signal hit_hurtbox(hurtbox)

func _ready():
	area_entered.connect(_on_hurtbox_entered)
	area_exited.connect(_on_hurtbox_exited)

func _process(delta):
	if !_current_hurtbox:
		return

	_elapsed_time += delta
	if _elapsed_time >= damage_interval:
		_hit()
		_elapsed_time = 0.0

func _hit():
	if !_current_hurtbox:
		return

	hit_hurtbox.emit(_current_hurtbox)
	_current_hurtbox.hurt.emit(self)

func _on_hurtbox_entered(hurtbox):
	if not hurtbox is HurtboxComponent:
		return

	if hurtbox.is_invincible:
		return

	_current_hurtbox = hurtbox
	_elapsed_time = 0.0
	_hit()

func _on_hurtbox_exited(hurtbox):
	if not hurtbox == _current_hurtbox:
		return

	_current_hurtbox = null

