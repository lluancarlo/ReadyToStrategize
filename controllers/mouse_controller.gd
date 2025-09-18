extends Node
class_name MouseController

@onready var _main_camera : Camera3D = %MainCamera

@export var selection_box_ui : Panel

var current_hover_troop : BasicCharacter
var selecting : bool = false
var selection_start: Vector2
var selection_end: Vector2

func _ready() -> void:
	assert(selection_box_ui != null, "missing 'mselection_box_ui' param")
	StaticGlobal.connect_to_troops_hover(_on_troop_hovered)

func _on_troop_hovered(character: BasicCharacter, hovered: bool) -> void:
	current_hover_troop = character if hovered else null

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				deselect_all()
				selection_start = event.position
				selecting = true
				if current_hover_troop:
					current_hover_troop.select(true)
			else:
				selection_end = event.position
				selecting = false
				selection_box_ui.visible = false
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				move_selected_troops(event.position)
	
	elif selecting and event is InputEventMouseMotion:
		selection_box_ui.position = Vector2(min(selection_start.x, event.position.x), min(selection_start.y, event.position.y))
		selection_box_ui.size = Vector2(abs(selection_start.x - event.position.x), abs(selection_start.y - event.position.y))
		selection_box_ui.visible = true
		
		if current_hover_troop:
			current_hover_troop.select(true)
		
		select_troops_inside_box(selection_box_ui.get_global_rect())

func select_troops_inside_box(box: Rect2) -> void:
	for character in get_tree().get_nodes_in_group(StaticGlobal.TROOPS_GROUP) as Array[BasicCharacter]:
		var unit_screen_pos = character.get_position_on_camera() as Vector2
		if box.has_point(unit_screen_pos):
			character.select(true)

func deselect_all() -> void:
	for character in get_tree().get_nodes_in_group(StaticGlobal.TROOPS_GROUP) as Array[BasicCharacter]:
		character.select(false)

func move_selected_troops(mouse_position: Vector2) -> void:
	for character in get_tree().get_nodes_in_group(StaticGlobal.TROOPS_GROUP) as Array[BasicCharacter]:
		if character.is_selected:
			var world_position = _get_world_position_from_mouse(mouse_position)
			if world_position != Vector3.ZERO:
				character.move(world_position)

func _get_world_position_from_mouse(mouse_position: Vector2) -> Vector3:
	var params = PhysicsRayQueryParameters3D.new()
	params.from = _main_camera.project_ray_origin(mouse_position)
	params.to = params.from + _main_camera.project_ray_normal(mouse_position) * 1000
	params.collision_mask = 1
	
	var space_state = _main_camera.get_world_3d().direct_space_state
	var result = space_state.intersect_ray(params)
	
	if result:
		return result.position
	else:
		return Vector3.ZERO
