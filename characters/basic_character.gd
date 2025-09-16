extends Node3D
class_name BasicCharacter

@export_group("Nodes")
@export var _selection_effect : Node3D
@export var _mesh : MeshInstance3D
@export var _ray_direction : RayCast3D
@export_group("Others")
@export var _hover_material : Material

@onready var _main_camera : Camera3D = %MainCamera

signal event_hovered(char: BasicCharacter, hovered: bool)

const selection_pivot_offset : Vector3 = Vector3(0.0, 1, 0.0)

var is_selected : bool

func _ready() -> void:
	select(false)

func select(selected: bool) -> void:
	is_selected = selected
	_selection_effect.visible = selected

func hover(hovered: bool) -> void:
	if hovered:
		_mesh.material_override = _hover_material
	else:
		_mesh.material_override = null

func get_position_on_camera() -> Vector2:
	return _main_camera.unproject_position(self.global_transform.origin + selection_pivot_offset)

func move(mouse_position: Vector2) -> void:
	print("clicking on " + str(mouse_position))
	var world_position = _get_world_position_from_mouse(mouse_position)
	DebugGlobal.spawn_temporary_3d_spot(world_position)
	create_tween().tween_property(self, "position", world_position, 3.0)

func _get_world_position_from_mouse(mouse_position: Vector2) -> Vector3:
	var params = PhysicsRayQueryParameters3D.new()
	params.from = _main_camera.project_ray_origin(mouse_position)
	params.to = params.from + _main_camera.project_ray_normal(mouse_position) * 1000
	params.collision_mask = 1
	
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(params)
	
	if result:
		return result.position
	else:
		return Vector3.ZERO


func _on_area_3d_mouse_entered() -> void:
	hover(true)
	event_hovered.emit(self, true)

func _on_area_3d_mouse_exited() -> void:
	hover(false)
	event_hovered.emit(self, false)
