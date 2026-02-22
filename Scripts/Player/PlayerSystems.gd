extends Node
class_name PlayerSystems

@onready var weapon_manager: WeaponManager = $WeaponManager
@onready var ability_manager: AbilityManager = $AbilityManager

func _ready() -> void:
	weapon_manager.weapon_equipped.connect(_on_weapon_equipped)
	# Initialize ability for starting weapon.
	_on_weapon_equipped(weapon_manager.active_weapon.weapon_id)

func request_weapon_switch(slot: int) -> void:
	# Rule: all abilities cancel on weapon switch.
	ability_manager.cancel_active()
	weapon_manager.equip_slot(slot)
	
func get_current_weapon() -> WeaponBase:
	return weapon_manager.active_weapon_id

func request_ability_press() -> void:
	ability_manager.press_active()

func request_ability_release() -> void:
	ability_manager.release_active()

func get_movement_layer(delta: float) -> MovementLayer:
	return ability_manager.get_movement_layer(delta)

func _on_weapon_equipped(weapon_id: StringName) -> void:
	ability_manager.set_active_for_weapon(weapon_id)
