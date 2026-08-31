extends WeaponBase

@export_range(1, 64, 1) var pellet_count: int = 8
@export_range(0.0, 45.0, 0.1) var spread_angle_deg: float = 8.0
@export_range(0.0, 9999.0, 1.0) var pellet_damage: float = 0.0

func _ready() -> void:
	weapon_id = GameConstants.WeaponId.SHOTGUN
	automatic_fire = false
	super._ready()

func _on_fire() -> void:
	super._on_fire()

	for _pellet_index: int in range(pellet_count):
		var direction: Vector3 = _get_spread_direction()
		_shoot_hitscan(direction)

func _get_spread_direction() -> Vector3:
	var fire_basis: Basis = _get_fire_basis()
	var forward: Vector3 = - fire_basis.z.normalized()
	var right: Vector3 = fire_basis.x.normalized()
	var up: Vector3 = fire_basis.y.normalized()

	var spread_radius: float = tan(deg_to_rad(spread_angle_deg * 0.5))
	var sample: Vector2 = _random_unit_disk_point() * spread_radius
	return (forward + right * sample.x + up * sample.y).normalized()

func _random_unit_disk_point() -> Vector2:
	var angle: float = randf_range(0.0, TAU)
	var radius: float = sqrt(randf())
	return Vector2(cos(angle), sin(angle)) * radius
