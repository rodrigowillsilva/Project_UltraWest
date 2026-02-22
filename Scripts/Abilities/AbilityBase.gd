extends Node
class_name AbilityBase

func on_equipped() -> void:
	pass

func on_unequipped() -> void:
	pass

func press() -> void:
	pass

func release() -> void:
	pass

func cancel() -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func get_movement_layer(_delta: float) -> MovementLayer:
	return MovementLayer.identity()
