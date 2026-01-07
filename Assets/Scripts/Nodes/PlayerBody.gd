class_name PlayerBody extends CharacterBody3D

@onready var player_entity: CharacterEntity = get_tree().get_current_scene().get_node("CharacterEntity")

var start_speed:float
var move_speed
var xRot: float = 0.0

func _ready() -> void:
	move_speed = player_entity.Stats.movement_speed
	start_speed = move_speed

func _process(delta: float) -> void:
	
	if Input.is_action_pressed("run"):
		var accelerated_speed = start_speed * player_entity.Stats.accel_multiplier
		move_speed = accelerated_speed
	else:
		move_speed = start_speed
	
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * player_entity.Stats.gravity_multiplier * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = player_entity.Stats.jump_force

	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	move_and_slide()
