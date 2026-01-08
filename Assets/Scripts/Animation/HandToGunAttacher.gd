extends Node3D

@export var left_ik: SkeletonIK3D
@export var right_ik: SkeletonIK3D
@export var gun_to_put_hands_into: HandGun

func _ready() -> void:
	left_ik.target_node = gun_to_put_hands_into.left_target.get_path()
	right_ik.target_node = gun_to_put_hands_into.right_target.get_path()
	left_ik.start()
	right_ik.start()
	
