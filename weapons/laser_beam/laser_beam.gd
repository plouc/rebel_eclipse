class_name LaserBeam
extends Node2D

@export var angle: float = 90
@export var max_length: float = 800.0
@export var damage: float = 1.0:
	set(value):
		damage = value
		_adjust_damage(damage)
@export var pause_tween_duration: float = 0.6
@export var ray_count: int = 1:
	set(value):
		ray_count = value
		_adjust_raycasts()
@export var ray_width: float = 12.0:
	set(value):
		ray_width = value
		_adjust_raycasts()
@export var beam_texture_single: Texture2D
@export var beam_texture_start: Texture2D
@export var beam_texture_middle: Texture2D
@export var beam_texture_end: Texture2D
@export var beam_shader: Shader
@export var beam_speed: float = 5.0:
	set(value):
		beam_speed = value
		_adjust_raycasts()
@export var shooting_particles_scene: PackedScene
@export var hit_particles_scene: PackedScene
@export var is_player_laser: bool = false

@export var is_paused: bool = false:
	set(value):
		is_paused = value
		if is_paused:
			_pause()
		else:
			_resume()

@onready var raycasts: Node2D = $Raycasts
@onready var beams: Node2D = $Beams
@onready var tips: Node2D = $Tips
@onready var hit_particles: Node2D = $HitParticles
@onready var emitters: Node2D = $Emitters

var _is_ready: bool = false
var _current_length: float = 0.0
var _ray_casts: Array[RayCast2D] = []
var _beams: Array[Line2D] = []
var _hitboxes: Array[HitboxPersistentComponent] = []
var _shooting_particles: Array[GPUParticles2D] = []
var _hit_particles: Array[GPUParticles2D] = []

func _ready():
	_is_ready = true
	is_paused = is_paused
	_adjust_raycasts()
	_set_shooting_particles(not is_paused)

func _adjust_raycasts():
	if not _is_ready:
		return

	var current_ray_count: int = _ray_casts.size()
	
	if current_ray_count < ray_count:
		var create_count: int = ray_count - current_ray_count
		
		for ray_index in range(create_count):
			var ray_cast: RayCast2D = RayCast2D.new()
			ray_cast.collide_with_bodies = false
			ray_cast.collide_with_areas = true
			ray_cast.collision_mask = 0
			raycasts.add_child(ray_cast)
			_ray_casts.append(ray_cast)

			var beam_material = ShaderMaterial.new()
			beam_material.shader = beam_shader

			var beam = Line2D.new()
			beam.width = ray_width
			beam.add_point(Vector2.ZERO)
			beam.add_point(Vector2.ZERO)
			beam.texture_mode = Line2D.LINE_TEXTURE_TILE
			beam.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
			beam.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			beam.material = beam_material
			beams.add_child(beam)
			_beams.append(beam)

			var collision = CollisionShape2D.new()
			var collision_shape = CircleShape2D.new()
			collision.shape = collision_shape

			var hitbox = HitboxPersistentComponent.new()
			hitbox.collision_layer = 0
			hitbox.collision_mask = 0

			if is_player_laser:
				ray_cast.set_collision_mask_value(2, true)
				hitbox.set_collision_mask_value(2, true)
			else:
				ray_cast.set_collision_mask_value(1, true)
				hitbox.set_collision_mask_value(1, true)

			hitbox.add_child(collision)
			add_child.call_deferred(hitbox)
			_hitboxes.append(hitbox)

			var ray_shooting_particles: GPUParticles2D = shooting_particles_scene.instantiate()
			ray_shooting_particles.emitting = not is_paused
			emitters.add_child(ray_shooting_particles)
			_shooting_particles.append(ray_shooting_particles)

			var ray_hit_particles: GPUParticles2D = hit_particles_scene.instantiate()
			hit_particles.add_child(ray_hit_particles)
			_hit_particles.append(ray_hit_particles)
		
	elif current_ray_count > ray_count:
		var delete_count: int = current_ray_count - ray_count
		
		for ray_index in range(delete_count):
			
			var ray_cast: RayCast2D = _ray_casts[0]
			ray_cast.queue_free()
			_ray_casts.remove_at(0)
		
			var beam: Line2D = _beams[0]
			beam.queue_free()
			_beams.remove_at(0)

			var hitbox: HitboxPersistentComponent = _hitboxes[0]
			hitbox.queue_free()
			_hitboxes.remove_at(0)

			var ray_shooting_particles: GPUParticles2D = _shooting_particles[0]
			ray_shooting_particles.queue_free()
			_shooting_particles.remove_at(0)

			var ray_hit_particles: GPUParticles2D = _hit_particles[0]
			ray_hit_particles.queue_free()
			_hit_particles.remove_at(0)
	
	var start_y: float = (ray_count - 1) * ray_width / 2 * -1
	
	for ray_index in range(_ray_casts.size()):
		var ray_cast = _ray_casts[ray_index]
		ray_cast.position.y = start_y + ray_index * ray_width
		
		var beam: Line2D = _beams[ray_index]
		beam.width = ray_width
		beam.material.set_shader_parameter("speed", beam_speed)
		
		if ray_count == 1:
			beam.texture = beam_texture_single
		elif ray_index == 0:
			beam.texture = beam_texture_start
		elif ray_index == ray_count - 1:
			beam.texture = beam_texture_end
		else:
			beam.texture = beam_texture_middle

		var hitbox: HitboxPersistentComponent = _hitboxes[ray_index]
		hitbox.damage = damage

		var collision_shape: CircleShape2D = hitbox.get_child(0).shape
		collision_shape.radius = ray_width / 2 + 1
		
		var ray_shooting_particles: GPUParticles2D = _shooting_particles[ray_index]
		ray_shooting_particles.position = ray_cast.position

func _adjust_damage(new_damage: float):
	for ray_index in _hitboxes.size():
		var hitbox: HitboxPersistentComponent = _hitboxes[ray_index]
		hitbox.damage = new_damage

func _adjust_length(new_length: float):
	if !_is_ready:
		return

	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "_current_length", new_length, pause_tween_duration).from_current()
	await tween.finished

func _pause():
	await _adjust_length(0.0)
	_set_shooting_particles(false)

func _resume():
	_set_shooting_particles(true)
	_adjust_length(max_length)

func _set_shooting_particles(emitting: bool):
	for ray_index in _shooting_particles.size():
		var ray_shooting_particles: GPUParticles2D = _shooting_particles[ray_index]
		ray_shooting_particles.emitting = emitting

func _physics_process(_delta):
	raycasts.rotation = deg_to_rad(angle)
	
	if _ray_casts.size() == 0:
		return

	var target_position = Vector2(_current_length, 0)

	for ray_index in range(_ray_casts.size()):
		var ray_cast: RayCast2D = _ray_casts[ray_index]
		ray_cast.target_position = target_position

		var ray_hit_particles: GPUParticles2D = _hit_particles[ray_index]

		var end_position: Vector2
		if ray_cast.is_colliding():
			end_position = ray_cast.get_collision_point()
			ray_hit_particles.emitting = true
		else:
			end_position = ray_cast.global_position + ray_cast.target_position.rotated(deg_to_rad(angle))
			ray_hit_particles.emitting = false

		var beam: Line2D = _beams[ray_index]
		beam.points[0] = ray_cast.global_position - global_position
		beam.points[1] = end_position - global_position

		var hitbox: HitboxPersistentComponent = _hitboxes[ray_index]
		hitbox.global_position = end_position

		ray_hit_particles.global_position = end_position
		ray_hit_particles.rotation_degrees = angle

		emitters.rotation_degrees = angle
