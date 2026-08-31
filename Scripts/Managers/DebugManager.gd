extends Node
# class_name DebugManager

@export var debug_enabled: bool = true
@export var shooting_debug_enabled: bool = true

@export_range(0.01, 10.0, 0.01) var trace_duration_sec: float = 0.3
@export_range(0.01, 10.0, 0.01) var marker_duration_sec: float = 0.5
@export_range(0.01, 2.0, 0.01) var hit_marker_radius: float = 0.2

@export var trace_hit_color: Color = Color(1.0, 0.35, 0.2, 0.95)
@export var trace_miss_color: Color = Color(0.45, 0.75, 1.0, 0.9)
@export var hit_marker_color: Color = Color(1.0, 0.95, 0.35, 0.95)

var _debug_root: Node3D = null
var _active_drawables: Array[Dictionary] = []

func _process(delta: float) -> void:
	for index: int in range(_active_drawables.size() - 1, -1, -1):
		var entry: Dictionary = _active_drawables[index]
		entry["ttl"] = float(entry.get("ttl", 0.0)) - delta
		var ttl: float = float(entry.get("ttl", 0.0))
		if ttl <= 0.0:
			var drawable: Node3D = entry.get("node") as Node3D
			if is_instance_valid(drawable):
				drawable.queue_free()
			_active_drawables.remove_at(index)
			continue
		_active_drawables[index] = entry

func draw_shot_trace(origin: Vector3, direction: Vector3, max_distance: float, hit_result: Dictionary = {}) -> void:
	if not debug_enabled or not shooting_debug_enabled:
		return
	if max_distance <= 0.0:
		return
	if direction.length_squared() <= 0.0:
		return
	if not _ensure_debug_root():
		return

	var normalized_direction: Vector3 = direction.normalized()
	var end_point: Vector3 = origin + normalized_direction * max_distance
	var line_color: Color = trace_miss_color

	if not hit_result.is_empty():
		end_point = hit_result.get("position", end_point)
		line_color = trace_hit_color

	draw_line(origin, end_point, line_color, trace_duration_sec)

	if not hit_result.is_empty():
		draw_marker(end_point, hit_marker_color, hit_marker_radius, marker_duration_sec)

func draw_line(from: Vector3, to: Vector3, color: Color = Color.WHITE, duration_sec: float = 0.2) -> void:
	if not debug_enabled:
		return
	if not _ensure_debug_root():
		return

	var line_mesh: ImmediateMesh = ImmediateMesh.new()
	line_mesh.surface_begin(Mesh.PRIMITIVE_LINES, _create_line_material(color))
	line_mesh.surface_add_vertex(from)
	line_mesh.surface_add_vertex(to)
	line_mesh.surface_end()

	var line_instance: MeshInstance3D = MeshInstance3D.new()
	line_instance.mesh = line_mesh
	_debug_root.add_child(line_instance)
	_track_drawable(line_instance, duration_sec)

func draw_marker(position: Vector3, color: Color = Color.WHITE, radius: float = 0.06, duration_sec: float = 0.28) -> void:
	if not debug_enabled:
		return
	if not _ensure_debug_root():
		return

	var marker_instance: MeshInstance3D = MeshInstance3D.new()
	var sphere_mesh: SphereMesh = SphereMesh.new()
	_debug_root.add_child(marker_instance)
	sphere_mesh.radius = radius
	sphere_mesh.height = radius * 2.0
	marker_instance.mesh = sphere_mesh
	marker_instance.material_override = _create_fill_material(color)
	marker_instance.global_position = position
	_track_drawable(marker_instance, duration_sec)

func _track_drawable(node: Node3D, duration_sec: float) -> void:
	var ttl: float = duration_sec
	if ttl <= 0.0:
		ttl = 0.01
	_active_drawables.append({"node": node, "ttl": ttl})

func _ensure_debug_root() -> bool:
	if not is_inside_tree():
		return false

	var current_scene: Node = get_tree().current_scene
	if current_scene == null:
		return false

	if is_instance_valid(_debug_root):
		if _debug_root.get_parent() != current_scene:
			_debug_root.reparent(current_scene)
		return true

	_debug_root = Node3D.new()
	_debug_root.name = "DebugDrawRoot"
	_debug_root.top_level = true
	current_scene.add_child(_debug_root)
	return true

func _create_line_material(color: Color) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = false
	material.albedo_color = color
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.no_depth_test = true
	return material

func _create_fill_material(color: Color) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.no_depth_test = true
	return material
