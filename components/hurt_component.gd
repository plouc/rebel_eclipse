class_name HurtComponent
extends Node

@export var stats_component: StatsComponent
@export var hurtbox_component: HurtboxComponent

func _ready() -> void:
	# Connect the hurt signal on the hurtbox component to an anonymous function
	# that removes health equal to the damage from the hitbox
	hurtbox_component.hurt.connect(func(hitbox_component):
		stats_component.health -= hitbox_component.damage
	)
