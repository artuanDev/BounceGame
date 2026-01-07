class_name FPSCameraComponent extends Node3D

@export var cam_controls: CameraControls
@export var target_camera: Camera3D
@export var target_player: PlayerBody

var xRot: float = 0
func _process(delta: float) -> void:
	
	var mouse_x = Input.get_last_mouse_velocity().x * delta * cam_controls.mouse_sensitivity_x
	var mouse_y = Input.get_last_mouse_velocity().y * delta * cam_controls.mouse_sensitivity_y
	
	xRot -= mouse_y
	xRot = clamp(xRot, cam_controls.min_x_limit,cam_controls.max_x_limit)
	
	target_player.rotation_degrees.y -= mouse_x
	target_camera.rotation_degrees.x = xRot
