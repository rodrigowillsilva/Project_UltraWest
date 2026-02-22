extends Node
class_name ProjectBootstrap

@export var add_missing_input_actions: bool = false

func _ready() -> void:
	_validate_input_actions()

func _validate_input_actions() -> void:
	var required_actions: Array[StringName] = InputActions.all()
	for action_name: StringName in required_actions:
		if InputMap.has_action(action_name):
			continue

		if add_missing_input_actions:
			InputMap.add_action(action_name)
			push_warning("Added missing input action: %s (no events bound yet)" % String(action_name))
		else:
			push_warning("Missing input action: %s" % String(action_name))
