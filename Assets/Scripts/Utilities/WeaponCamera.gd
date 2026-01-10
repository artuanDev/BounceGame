extends Camera3D

@export var main_cam: Camera3D
# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	global_transform = main_cam.global_transform
	
