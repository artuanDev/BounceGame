extends CharacterBody3D

var start_speed:float

@export var move_speed: float = 14.0
@export var accel_multiplier: float = 2.0
@export var jumpForce: float = 6.0

@export var camera: Camera3D

@export var mouseSensitivity: float = 1.0

var xRot: float = 0.0

func _ready() -> void:
	start_speed = move_speed

func _process(delta: float) -> void:
	
	var mouse_x = Input.get_last_mouse_velocity().x * delta * mouseSensitivity
	var mouse_y = Input.get_last_mouse_velocity().y * delta * mouseSensitivity
	
	xRot -= mouse_y
	xRot = clamp(xRot, -70,70)
	
	rotation_degrees.y -= mouse_x
	camera.rotation_degrees.x = xRot
	
	if Input.is_action_pressed("run"):
		var accelerated_speed = start_speed * accel_multiplier
		move_speed = accelerated_speed
	else:
		move_speed = start_speed
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpForce

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	move_and_slide()
