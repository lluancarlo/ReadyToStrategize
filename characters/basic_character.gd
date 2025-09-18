extends CharacterBody3D
class_name BasicCharacter

@export var _hover_material : Material
@export var _move_speed : float = 2

@onready var _main_camera : Camera3D = %MainCamera
@onready var _nav_agent : NavigationAgent3D = $NavigationAgent3D
@onready var _mesh : MeshInstance3D = $MeshInstance3D
@onready var _selection_effect : Node3D = $SelectedEffect

signal event_hovered(char: BasicCharacter, hovered: bool)

const selection_pivot_offset : Vector3 = Vector3(0.0, 1, 0.0)

var is_selected : bool
var current_target_position : Vector3
var physics_delta: float

func _ready() -> void:
	select(false)

func _physics_process(_delta: float) -> void:
	if not _nav_agent.is_navigation_finished():
		var next_pos: Vector3 = _nav_agent.get_next_path_position()
		var dir: Vector3 = (next_pos - global_transform.origin).normalized()
		_nav_agent.set_velocity(dir * _move_speed)
	else:
		_nav_agent.set_velocity(Vector3.ZERO)

	move_and_slide()

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

func move(target_position: Vector3) -> void:
	_nav_agent.set_target_position(target_position)
	DebugGlobal.spawn_temporary_3d_spot(target_position)

func _on_area_3d_mouse_entered() -> void:
	hover(true)
	event_hovered.emit(self, true)

func _on_area_3d_mouse_exited() -> void:
	hover(false)
	event_hovered.emit(self, false)

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
