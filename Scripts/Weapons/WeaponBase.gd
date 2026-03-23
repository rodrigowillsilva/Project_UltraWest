extends Node
class_name WeaponBase

signal fired(weapon_id: GameConstants.WeaponId, ammo_in_magazine: int)
signal reloaded(weapon_id: GameConstants.WeaponId, ammo_in_magazine: int)

var weapon_id: GameConstants.WeaponId = GameConstants.WeaponId.REVOLVER
@export_range(1, 999, 1) var magazine_size: int = 6
@export_range(0.01, 10.0, 0.01) var fire_cooldown_sec: float = 0.25
@export_range(0.01, 10.0, 0.01) var reload_duration_sec: float = 1.2
@export_range(0.0, 10.0, 0.01) var reload_on_holster_delay_sec: float = 1.0
@export var automatic_fire: bool = false

var ammo_in_magazine: int = 0
var _trigger_held: bool = false
var _fire_cooldown_timer: Timer
var _reload_timer: Timer
var _pending_reload_is_holster: bool = false

func _ready() -> void:
	ammo_in_magazine = magazine_size
	_ensure_timers()
	_fire_cooldown_timer.timeout.connect(_on_fire_cooldown_timeout)
	_reload_timer.timeout.connect(_on_reload_timeout)

func on_equipped() -> void:
	if _pending_reload_is_holster and _reload_timer != null:
		_reload_timer.stop()
		_pending_reload_is_holster = false

func on_unequipped() -> void:
	release_primary()
	reload_on_holster()

func physics_tick(_delta: float) -> void:
	pass

func press_primary() -> void:
	_trigger_held = true
	try_fire()

func release_primary() -> void:
	_trigger_held = false

func reload() -> void:
	_request_reload(reload_duration_sec, false)

func reload_on_holster() -> void:
	_request_reload(reload_on_holster_delay_sec, true)

func _request_reload(delay_sec: float, is_holster_reload: bool) -> void:
	if ammo_in_magazine >= magazine_size:
		return

	if _reload_timer == null:
		_complete_reload()
		return

	_pending_reload_is_holster = is_holster_reload
	if delay_sec <= 0.0:
		_reload_timer.stop()
		_complete_reload()
		return

	_reload_timer.stop()
	_reload_timer.wait_time = delay_sec
	_reload_timer.start()

func _complete_reload() -> void:
	_pending_reload_is_holster = false
	if ammo_in_magazine >= magazine_size:
		return
	ammo_in_magazine = magazine_size
	reloaded.emit(weapon_id, ammo_in_magazine)
	print("Weapon reloaded: %s, ammo now: %d" % [str(weapon_id), ammo_in_magazine])

func try_fire() -> bool:
	if not _can_fire():
		return false

	ammo_in_magazine -= 1
	_start_fire_cooldown()
	_on_fire()
	fired.emit(weapon_id, ammo_in_magazine)
	return true

func _can_fire() -> bool:
	if ammo_in_magazine <= 0:
		return false
	if _fire_cooldown_timer != null and not _fire_cooldown_timer.is_stopped():
		return false
	if _reload_timer != null and not _reload_timer.is_stopped():
		return false
	return true

func _start_fire_cooldown() -> void:
	if _fire_cooldown_timer == null:
		return
	
	_fire_cooldown_timer.stop()
	_fire_cooldown_timer.wait_time = fire_cooldown_sec
	_fire_cooldown_timer.start()

func _on_fire_cooldown_timeout() -> void:
	if automatic_fire and _trigger_held:
		try_fire()

func _on_reload_timeout() -> void:
	_complete_reload()

func _ensure_timers() -> void:
	var cooldown_timer: Timer = get_node_or_null("FireCooldownTimer") as Timer
	if cooldown_timer == null:
		cooldown_timer = Timer.new()
		cooldown_timer.name = "FireCooldownTimer"
		cooldown_timer.one_shot = true
		add_child(cooldown_timer)
	_fire_cooldown_timer = cooldown_timer

	var reload_timer: Timer = get_node_or_null("ReloadTimer") as Timer
	if reload_timer == null:
		reload_timer = Timer.new()
		reload_timer.name = "ReloadTimer"
		reload_timer.one_shot = true
		add_child(reload_timer)
	_reload_timer = reload_timer

func _on_fire() -> void:
	print("Weapon fired: %s, ammo left: %d" % [str(weapon_id), ammo_in_magazine])
	pass
