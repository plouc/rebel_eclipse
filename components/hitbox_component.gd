class_name HitboxComponent
extends Area2D

@export var damage: int = 1

# Create a signal for when the hitbox hits a hurtbox
signal hit_hurtbox(hurtbox)

func _ready():
	area_entered.connect(_on_hurtbox_entered)

func _on_hurtbox_entered(hurtbox):
	if not hurtbox is HurtboxComponent:
		return

	# Make sure the hurtbox isn't invincible
	if hurtbox.is_invincible: return
	# Signal out that we hit a hurtbox (this is useful for destroying projectiles when they hit something)
	hit_hurtbox.emit(hurtbox)
	# Have the hurtbox signal out that it was hit
	hurtbox.hurt.emit(self)
