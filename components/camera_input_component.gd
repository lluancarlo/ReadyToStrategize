extends Node
class_name CameraInputComponent

@export var main_camera : Camera3D
@export var horizontal_speed : float = 0.1
@export var vertical_speed : float = 0.1

func _physics_process(_delta: float) -> void:
	var horizontal = Input.get_axis("left", "right")
	var vertical = Input.get_axis("up", "down")
	
	if horizontal != 0:
		main_camera.position.x = lerpf(main_camera.position.x, main_camera.position.x + horizontal_speed, horizontal)
		
	if vertical != 0:
		main_camera.position.z = lerpf(main_camera.position.z, main_camera.position.z + vertical_speed, vertical)
