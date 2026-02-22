extends RefCounted
class_name MovementLayer

var speed_multiplier: float = 1.0
var add_velocity: Vector3 = Vector3.ZERO
var max_speed: float = 0.0

static func identity() -> MovementLayer:
	return MovementLayer.new()
