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

func _on_troop_hovered(char: BasicCharacter, hovered: bool) -> void:
	current_hover_troop = char if hovered else null

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
		var rect_pos = Vector2(
			min(selection_start.x, event.position.x),
			min(selection_start.y, event.position.y)
		)
		var rect_size = Vector2(
			abs(selection_start.x - event.position.x),
			abs(selection_start.y - event.position.y)
		)
		
		selection_box_ui.position = Vector2(min(selection_start.x, event.position.x), min(selection_start.y, event.position.y))
		selection_box_ui.size = Vector2(abs(selection_start.x - event.position.x), abs(selection_start.y - event.position.y))
		selection_box_ui.visible = true
		
		if current_hover_troop:
			current_hover_troop.select(true)
		
		select_troops_inside_box(selection_box_ui.get_global_rect())

func select_troops_inside_box(box: Rect2) -> void:
	for obj in get_tree().get_nodes_in_group(StaticGlobal.TROOPS_GROUP):
		var char := obj as BasicCharacter
		if char:
			var unit_screen_pos = char.get_position_on_camera() as Vector2
			if box.has_point(unit_screen_pos):
				char.select(true)

func deselect_all() -> void:
	for char in get_tree().get_nodes_in_group(StaticGlobal.TROOPS_GROUP) as Array[BasicCharacter]:
		char.select(false)

func move_selected_troops(mouse_position: Vector2) -> void:
	for char in get_tree().get_nodes_in_group(StaticGlobal.TROOPS_GROUP) as Array[BasicCharacter]:
		if char.is_selected:
			char.move(mouse_position)
