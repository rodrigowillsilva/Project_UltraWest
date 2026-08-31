extends WeaponBase

@export_range(0.0, 9999.0, 1.0) var hit_damage: float = 0.0

func _ready() -> void:
	weapon_id = GameConstants.WeaponId.REVOLVER
	automatic_fire = false
	super._ready()

func _on_fire() -> void:
	super._on_fire()
	_shoot_hitscan(_get_fire_forward())
