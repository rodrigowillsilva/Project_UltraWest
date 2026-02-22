extends RefCounted
class_name InputActions

const MOVE_FORWARD: StringName = &"move_forward"
const MOVE_BACK: StringName = &"move_back"
const MOVE_LEFT: StringName = &"move_left"
const MOVE_RIGHT: StringName = &"move_right"

const LOOK_X: StringName = &"look_x"
const LOOK_Y: StringName = &"look_y"

const JUMP: StringName = &"jump"

const ABILITY: StringName = &"ability"

const FIRE_PRIMARY: StringName = &"fire_primary"
const RELOAD: StringName = &"reload"

const WEAPON_1: StringName = &"weapon_1"
const WEAPON_2: StringName = &"weapon_2"
const NEXT_WEAPON: StringName = &"next_weapon"

static func all() -> Array[StringName]:
	return [
		MOVE_FORWARD,
		MOVE_BACK,
		MOVE_LEFT,
		MOVE_RIGHT,
		LOOK_X,
		LOOK_Y,
		JUMP,
		ABILITY,
		FIRE_PRIMARY,
		RELOAD,
		WEAPON_1,
		WEAPON_2,
		NEXT_WEAPON,
	]
