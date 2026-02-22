extends "res://Scripts/Abilities/AbilityBase.gd"
class_name SprintAbility

@export var speed_multiplier: float = 1.5

func get_movement_layer(_delta: float) -> MovementLayer:
	var layer: MovementLayer = MovementLayer.identity()
	layer.speed_multiplier = speed_multiplier
	return layer
