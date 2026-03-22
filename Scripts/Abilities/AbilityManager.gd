extends Node
class_name AbilityManager

signal active_ability_changed(ability: AbilityBase)

var _active_ability: AbilityBase

func _physics_process(delta: float) -> void:
	if _active_ability == null:
		return
	_active_ability.physics_tick(delta)

func set_active_for_weapon(weapon_id: GameConstants.WeaponId) -> void:
	cancel_active()

	var new_ability: AbilityBase = _build_ability_for_weapon(weapon_id)
	if new_ability == null:
		return

	_active_ability = new_ability
	add_child(_active_ability)
	_active_ability.on_equipped()
	active_ability_changed.emit(_active_ability)

func press_active() -> void:
	if _active_ability == null:
		return
	_active_ability.press()

func release_active() -> void:
	if _active_ability == null:
		return
	_active_ability.release()

func cancel_active() -> void:
	if _active_ability == null:
		return
	_active_ability.cancel()
	_active_ability.on_unequipped()
	_active_ability.queue_free()
	_active_ability = null

func get_movement_layer(delta: float) -> MovementLayer:
	if _active_ability == null:
		return MovementLayer.identity()
	return _active_ability.get_movement_layer(delta)

func _build_ability_for_weapon(weapon_id: GameConstants.WeaponId) -> AbilityBase:
	# Proto: Revolver always provides Sprint. Extend later for other weapons.
	if weapon_id == GameConstants.WeaponId.REVOLVER:
		var ability: AbilityBase = SprintAbility.new()
		return ability
	return null
