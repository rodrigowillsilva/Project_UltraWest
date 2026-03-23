extends Node
class_name WeaponManager

signal weapon_equipped(weapon_id: GameConstants.WeaponId)

var weapons: Array[WeaponBase] = []
var active_weapon: WeaponBase = null

func _ready() -> void:
	weapons.clear()
	for weapon in get_children():
		var w := weapon as WeaponBase
		if w == null:
			continue
		weapons.append(w)

	if weapons.is_empty():
		push_warning("WeaponManager has no WeaponBase children.")
		return

	active_weapon = weapons[0]
	active_weapon.on_equipped()
	weapon_equipped.emit(active_weapon.weapon_id)

func _physics_process(delta: float) -> void:
	if active_weapon == null:
		return
	active_weapon.physics_tick(delta)

func equip_slot(slot: GameConstants.WeaponId) -> void:
	if active_weapon == null:
		return

	if slot == GameConstants.WeaponId.NEXT:
		equip_next()
		return

	var target_weapon: WeaponBase = _find_weapon_by_id(slot)
	if target_weapon == null:
		push_warning("Requested weapon slot is not available: %s" % str(slot))
		return

	if slot == active_weapon.weapon_id:
		return

	active_weapon.on_unequipped()
	active_weapon = target_weapon
	active_weapon.on_equipped()
	weapon_equipped.emit(active_weapon.weapon_id)

func equip_next() -> void:
	if weapons.size() <= 1:
		return

	var current_index: int = weapons.find(active_weapon)
	if current_index == -1:
		current_index = 0

	var next_index: int = (current_index + 1) % weapons.size()
	var next_weapon: WeaponBase = weapons[next_index]
	if next_weapon == active_weapon:
		return

	active_weapon.on_unequipped()
	active_weapon = next_weapon
	active_weapon.on_equipped()
	weapon_equipped.emit(active_weapon.weapon_id)

func press_primary() -> void:
	if active_weapon == null:
		return
	active_weapon.press_primary()

func release_primary() -> void:
	if active_weapon == null:
		return
	active_weapon.release_primary()

func reload_active() -> void:
	if active_weapon == null:
		return
	active_weapon.reload()

func get_weapons() -> Array[WeaponBase]:
	return weapons

func _find_weapon_by_id(weapon_id: GameConstants.WeaponId) -> WeaponBase:
	for weapon: WeaponBase in weapons:
		if weapon.weapon_id == weapon_id:
			return weapon
	return null
