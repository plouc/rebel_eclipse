class_name CollisionBoxComponent
extends Area2D

signal hit_hurtbox(hurtbox)

func _ready():
	area_entered.connect(_on_hurtbox_entered)

func _on_hurtbox_entered(hurtbox):
	if not hurtbox is HurtboxComponent:
		return
		
	hit_hurtbox.emit(hurtbox)
	hurtbox.crashed.emit(self)
