extends Node


const TROOPS_GROUP : String = "Troops"

func connect_to_troops_hover(function: Callable) -> void:
	for obj in get_tree().get_nodes_in_group(StaticGlobal.TROOPS_GROUP):
		var char := obj as BasicCharacter
		char.event_hovered.connect(function)
