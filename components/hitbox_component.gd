class_name HitboxComponent
extends Area2D

@export var damage: float = 1.0

# Create a signal for when the hitbox hits a hurtbox
signal hit_hurtbox(hurtbox)
signal impact(collision_point)

func _ready():
	area_entered.connect(_on_hurtbox_entered)
	# area_shape_entered.connect(_on_area_shape_entered)

func _on_area_shape_entered(
	_area_rid: RID,
	area: Area2D,
	area_shape_index: int,
	_local_shape_index: int
):
	if not area is HurtboxComponent:
		return

	var shape = area.shape_owner_get_owner(area_shape_index).shape
	var collision_points = shape.collide_and_get_contacts(
		global_transform, shape, area.global_transform
	)

	if collision_points.size() > 0:
		impact.emit(collision_points)

func _on_hurtbox_entered(hurtbox):
	if not hurtbox is HurtboxComponent:
		return

	if hurtbox.is_invincible: return
	# Signal out that we hit a hurtbox (this is useful for destroying projectiles when they hit something)
	hit_hurtbox.emit(hurtbox)
	# Have the hurtbox signal out that it was hit
	hurtbox.hurt.emit(self)
