extends Node
class_name WeaponManager

signal weapon_equipped(weapon_id: GameConstants.WeaponId)

var weapons: Array[WeaponBase]
var active_weapon: WeaponBase

func _ready() -> void:
	for weapon in get_children():
		var w := weapon as WeaponBase
		weapons.append(w)
	active_weapon = weapons[0]

func equip_slot(slot: GameConstants.WeaponId) -> void:
	if slot == active_weapon.weapon_id:
		return
		
	active_weapon = weapons[slot]
	weapon_equipped.emit(active_weapon.weapon_id)

func get_weapons() -> Array[WeaponBase]:
	return weapons
