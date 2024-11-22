class_name BuildStateManager
extends Node3D

@export var ray_length: float = 3000.0
@export var movement_time: float = 5.0
@export_group("Centered", "centered_")
@export var centered_cell_x: bool = false
@export var centered_cell_y: bool = false
@export var centered_cell_z: bool = false

var current_spawnable: Node3D
var current_offset: Vector3 = Vector3(0.0, 0.0, 0.0)
var container: Node3D
var new_pos: Vector3

var plane: Plane = Plane.PLANE_XZ

func _ready() -> void:
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


func local_to_map(pos: Vector3) -> Vector3i:
	return Vector3i(floori(pos.x),floori(pos.y),floori(pos.z))


func map_to_local(grid_pos: Vector3i) -> Vector3:
	var final: Vector3 = Vector3(grid_pos)
	if centered_cell_x:
		final += Vector3(0.5, 0.0, 0.0)
	if centered_cell_y:
		final += Vector3(0.0, 0.5, 0.0)
	if centered_cell_z:
		final += Vector3(0.0, 0.0, 0.5)
	return final


func _unhandled_input(event: InputEvent) -> void:
	if GameState.current_state != GameState.STATE_BUILD or not current_spawnable:
		return
	if event.is_action_pressed(&"mouse_left") and current_spawnable:
		_place_object_in_world()
	if event.is_action_pressed(&"mouse_right") and current_spawnable:
		_leave_build_mode()


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


func build_object(obj: PackedScene) -> void:
	if current_spawnable:
		current_spawnable.queue_free()
	current_spawnable = obj.instantiate()
	add_child.call_deferred(current_spawnable)
	current_spawnable.global_translate.call_deferred(_get_mouse_world_position())
	GameState.change_state_to_build()


func _get_mouse_world_position() -> Vector3:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var screen_point: Vector2 = get_viewport().get_mouse_position()
	var pos: Vector3 = Utils.cast_ray_to_plane(
		plane, screen_point, camera, ray_length)
	return pos
