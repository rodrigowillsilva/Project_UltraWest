extends Node
class_name WeaponManager

signal weapon_equipped(weapon_id: StringName)

@export var proto_weapons: Array[WeaponBase]
var active_weapon: WeaponBase

func _ready() -> void:
	active_weapon = proto_weapons[0]

func equip_slot(slot: int) -> void:
	# Proto mapping: 1=Revolver, 2=Shotgun
	var new_id: StringName = active_weapon.weapon_id
	match slot:
		1:
			new_id = &"revolver"
		2:
			new_id = &"shotgun"

	if new_id == active_weapon.weapon_id:
		return

	active_weapon.weapon_id = new_id
	weapon_equipped.emit(active_weapon.weapon_id)

func get_weapons() -> Array[WeaponBase]:
	return proto_weapons
