class_name HurtComponent
extends Node

@export var stats_component: StatsComponent
@export var hurtbox_component: HurtboxComponent
@export var collison_box_component: CollisionBoxComponent

func _ready() -> void:
	hurtbox_component.hurt.connect(func(hitbox_component):
		stats_component.health -= hitbox_component.damage
	)

	if collison_box_component:
		collison_box_component.hit_hurtbox.connect(func(_collision_box):
			stats_component.health = 0
		)
