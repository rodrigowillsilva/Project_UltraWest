extends Node3D
class_name WeaponBase

signal fired(weapon_id: GameConstants.WeaponId, ammo_in_magazine: int)
signal reloaded(weapon_id: GameConstants.WeaponId, ammo_in_magazine: int)

var weapon_id: GameConstants.WeaponId = GameConstants.WeaponId.REVOLVER
@export var fire_point_path: NodePath
@export_flags_3d_physics var hit_collision_mask: int = (1 << (PhysicsLayers.WORLD - 1)) | (1 << (PhysicsLayers.ENEMY - 1))
@export_range(1.0, 10000.0, 1.0) var max_range: float = 1000.0
@export var debug_fire: bool = true
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
	pass

func _get_fire_point() -> Marker3D:
	return get_node_or_null(fire_point_path) as Marker3D

func _get_fire_origin() -> Vector3:
	return _get_fire_point().global_position

func _get_fire_basis() -> Basis:
	return _get_fire_point().global_transform.basis

func _get_fire_forward() -> Vector3:
	return -_get_fire_basis().z

func _shoot_hitscan(direction: Vector3, range_override: float = -1.0) -> Dictionary:
	if direction.length_squared() <= 0.0:
		return {}

	var cast_distance: float = max_range
	if range_override > 0.0:
		cast_distance = range_override

	var from: Vector3 = _get_fire_origin()
	var to: Vector3 = from + direction.normalized() * cast_distance

	var world: World3D = get_world_3d()
	if world == null:
		return {}

	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to, hit_collision_mask)
	query.collide_with_areas = true

	var owner_body: PhysicsBody3D = _find_owner_physics_body()
	if owner_body != null:
		query.exclude = [owner_body.get_rid()]

	var result: Dictionary = world.direct_space_state.intersect_ray(query)
	_debug_shot(from, to, result)
	return result

func _find_owner_physics_body() -> PhysicsBody3D:
	var current: Node = self
	while current != null:
		if current is PhysicsBody3D:
			return current as PhysicsBody3D
		current = current.get_parent()
	return null

func _debug_shot(from: Vector3, to: Vector3, result: Dictionary) -> void:
	if not debug_fire:
		return

	var debug_manager: Node = get_node_or_null("/root/DebugManager")
	if debug_manager == null:
		return
	if not debug_manager.has_method("draw_shot_trace"):
		return

	var direction: Vector3 = to - from
	var distance: float = direction.length()
	if distance <= 0.0:
		return

	debug_manager.call("draw_shot_trace", from, direction.normalized(), distance, result)
