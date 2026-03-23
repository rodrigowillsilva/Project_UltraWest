extends CharacterBody3D
class_name Player

@export var mouse_sensitivity: float = GameConstants.MOUSE_SENSITIVITY

@onready var camera_pivot: Node3D = $CameraPivot
@onready var player_systems: PlayerSystems = $PlayerSystems

var _pitch_radians: float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	var move_input: Vector2 = Input.get_vector(
		InputActions.MOVE_LEFT,
		InputActions.MOVE_RIGHT,
		InputActions.MOVE_FORWARD,
		InputActions.MOVE_BACK
	)

	var move_dir: Vector3 = Vector3.ZERO
	if move_input.length_squared() > 0.0:
		var xform_basis: Basis = global_transform.basis
		var forward: Vector3 = xform_basis.z
		var right: Vector3 = xform_basis.x
		move_dir = (right * move_input.x + forward * move_input.y).normalized()

	# Base movement (proto: direct set). Later we can add accel/friction.
	var base_speed: float = GameConstants.PLAYER_WALK_SPEED
	var layer: MovementLayer = player_systems.get_movement_layer(delta)
	var target_speed: float = base_speed * layer.speed_multiplier

	velocity.x = move_dir.x * target_speed
	velocity.z = move_dir.z * target_speed

	# Apply additive velocity contributions (for grapple/knockback later).
	velocity += layer.add_velocity

	if layer.max_speed > 0.0:
		var horizontal: Vector3 = Vector3(velocity.x, 0.0, velocity.z)
		var h_len: float = horizontal.length()
		if h_len > layer.max_speed:
			var clamped: Vector3 = horizontal.normalized() * layer.max_speed
			velocity.x = clamped.x
			velocity.z = clamped.z

	# Gravity + jump.
	if not is_on_floor():
		velocity.y -= _get_gravity() * delta
	else:
		if Input.is_action_just_pressed(InputActions.JUMP):
			velocity.y = GameConstants.PLAYER_JUMP_VELOCITY
		else:
			velocity.y = 0.0

	move_and_slide()

func _rotate_look(mouse_delta: Vector2) -> void:
	rotate_y(-mouse_delta.x * mouse_sensitivity)
	_pitch_radians = clampf(_pitch_radians - mouse_delta.y * mouse_sensitivity, deg_to_rad(-89.0), deg_to_rad(89.0))
	camera_pivot.rotation.x = _pitch_radians

func _get_gravity() -> float:
	return float(ProjectSettings.get_setting("physics/3d/default_gravity"))

func _handle_weapon_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputActions.WEAPON_1):
		player_systems.request_weapon_switch(GameConstants.WeaponId.REVOLVER)
	elif event.is_action_pressed(InputActions.WEAPON_2):
		player_systems.request_weapon_switch(GameConstants.WeaponId.SHOTGUN)
	elif event.is_action_pressed(InputActions.NEXT_WEAPON):
		player_systems.request_weapon_switch(GameConstants.WeaponId.NEXT)

func _handle_combat_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputActions.FIRE_PRIMARY):
		player_systems.request_fire_press()
	elif event.is_action_released(InputActions.FIRE_PRIMARY):
		player_systems.request_fire_release()

	if event.is_action_pressed(InputActions.RELOAD):
		player_systems.request_reload()

func _handle_ability_input(_event: InputEvent) -> void:
	if Input.is_action_pressed(InputActions.ABILITY):
		player_systems.request_ability_press()
	elif Input.is_action_just_released(InputActions.ABILITY):
		player_systems.request_ability_release()


#========= INPUT EVENTS =========#
func _unhandled_input(event: InputEvent) -> void:
	_handle_weapon_input(event)
	_handle_combat_input(event)
	_handle_ability_input(event)
	if event.is_action_pressed("ui_cancel"):
		var new_mode: int = Input.MOUSE_MODE_VISIBLE
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			new_mode = Input.MOUSE_MODE_CAPTURED
		Input.set_mouse_mode(new_mode)
		return

	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return

	if event is InputEventMouseMotion:
		var mm: InputEventMouseMotion = event
		_rotate_look(mm.relative)
