class_name BuildState
extends Node3D

#region Variables
@export var ray_length: float = 3000.0
@export var movement_time: float = 5.0
@export var cell_size: Vector3 = Vector3.ONE

var current_spawnable: Node3D
var placement_offset: Vector3 = Vector3(0.5, 0.0, 0.5)
var placement_footprint: Vector3 = Vector3.ZERO

var container: Node3D
var new_pos: Vector3

var plane: Plane = Plane.PLANE_XZ

static var build_state: BuildState
#endregion


func _ready() -> void:
	if not build_state:
		build_state = self
	container = get_tree().get_first_node_in_group(&"world_container")
	plane.d = global_position.y


func _process(delta: float) -> void:
	if GameState.current_state != GameState.STATE_BUILD or not current_spawnable:
		return
	var pos: Vector3 = _get_mouse_world_position()
	if pos:
		var grid_pos: Vector3i = local_to_map(pos)
		new_pos = map_to_local(grid_pos)
		new_pos.y = maxf(new_pos.y, 0)
		current_spawnable.global_position = current_spawnable.global_position\
			.lerp(new_pos, delta * movement_time)


func _unhandled_input(event: InputEvent) -> void:
	if GameState.current_state != GameState.STATE_BUILD or not current_spawnable:
		return
	if event.is_action_pressed(&"mouse_left") and current_spawnable:
		_place_object_in_world()
	if event.is_action_pressed(&"mouse_right") and current_spawnable:
		_leave_build_mode()


func local_to_map(pos: Vector3) -> Vector3i:
	var map_pos: Vector3 = (pos / cell_size).floor()
	return Vector3i(map_pos)


func map_to_local(map_pos: Vector3i) -> Vector3:
	var offset: Vector3 = placement_offset
	var local_pos: Vector3 = Vector3(
		map_pos.x * cell_size.x + offset.x,
		map_pos.y * cell_size.y + offset.y,
		map_pos.z * cell_size.z + offset.z
	)
	return local_pos


func build_object(obj_data: ObjectData) -> void:
	if current_spawnable:
		current_spawnable.queue_free()
	current_spawnable = obj_data.scene.instantiate()
	placement_offset = obj_data.placement_offset
	placement_footprint = obj_data.footprint
	add_child.call_deferred(current_spawnable)
	current_spawnable.global_translate.call_deferred(_get_mouse_world_position())
	GameState.change_state_to_build()


func _leave_build_mode() -> void:
	current_spawnable.queue_free()
	current_spawnable = null
	GameState.change_state_to_live()
	get_viewport().set_input_as_handled()


func _place_object_in_world() -> void:
	if not container:
		return
	var obj: Node3D = current_spawnable.duplicate()
	container.add_child(obj)
	obj.global_position = new_pos
	if not Input.is_key_pressed(KEY_SHIFT):
		GameState.change_state_to_live()
		current_spawnable.queue_free()
		current_spawnable = null
	get_viewport().set_input_as_handled()


func _get_mouse_world_position() -> Vector3:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var screen_point: Vector2 = get_viewport().get_mouse_position()
	var pos: Vector3 = Utils.cast_ray_to_plane(
		plane, screen_point, camera, ray_length)
	return pos
