extends CharacterBody3D

@onready var NavAgent: NavigationAgent3D = $NavigationAgent3D
@onready var player: Node3D = get_tree().get_current_scene().get_node("CharacterEntity")
@export var animationPlayer:AnimationPlayerBasic
const SPEED := 5.0

func _physics_process(delta: float) -> void:
	if player == null:
		return

	NavAgent.target_position = player.global_position

	if not NavAgent.is_navigation_finished():
		var destination = NavAgent.get_next_path_position()
		var direction = (destination - global_position).normalized()
		velocity = direction * SPEED
	else:
		velocity = Vector3.ZERO

	move_and_slide()

	var look_target = Vector3(
		player.global_position.x,
		global_position.y,
		player.global_position.z
	)
	look_at(look_target, Vector3.UP)
	
	if velocity != Vector3.ZERO:
		animationPlayer.play(animationPlayer.list[1])
	else:
		animationPlayer.play(animationPlayer.list[0])
	
