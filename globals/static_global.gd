extends Node


const TROOPS_GROUP : String = "Troops"

func connect_to_troops_hover(function: Callable) -> void:
	for troop in get_tree().get_nodes_in_group(StaticGlobal.TROOPS_GROUP) as Array[BasicCharacter]:
		troop.event_hovered.connect(function)
