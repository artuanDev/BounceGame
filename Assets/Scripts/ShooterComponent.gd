extends Camera3D

var ray_range = 2000.0

@export var decal: PackedScene
@export var particle: PackedScene

@export var PhysicalBall : bool
@export var SoundToPlay: AudioStreamWAV

@onready var gun = $GunPos
@onready var gunTip = $/root/TestArea/Player/BodyGraphic/Camera3D/GunPos/SM_TestGun/GunPosTip

var startPos : Vector3

func _ready() -> void:
	startPos = gun.position

func _process(delta: float) -> void:
	gun.position = lerp(gun.position, startPos, 10 * delta)
	if Input.is_action_just_pressed("shoot"):
		gun.global_position += gun.global_basis.z * 0.3

func _input(event):
	if event.is_action_pressed("shoot"):
		if PhysicalBall:
			Shoot_Physical_Ball()
		else:
			Get_Camera_Collision()

func Shoot_Physical_Ball():
	var rb_ball = RigidBody3D.new()
	var ball = CSGSphere3D.new()
	var collision = CollisionShape3D.new()
	var sphereshape = SphereShape3D.new()

	collision.shape = sphereshape
	var parent = owner.get_parent()

	rb_ball.position = global_position
	ball.name = "NewBall"
	ball.use_collision = true
	ball.scale = Vector3.ONE

	parent.add_child(rb_ball)
	rb_ball.add_child(ball)
	rb_ball.add_child(collision)

	rb_ball.apply_impulse(-global_transform.basis.z * 50)

func Get_Camera_Collision():
	if Input.is_action_just_pressed("shoot"):

		$Shoot.pitch_scale += randf_range(-0.1, 0.1)
		$Shoot.play()

		# Muzzle particle
		var particle_instance = particle.instantiate()
		get_tree().current_scene.add_child(particle_instance)
		particle_instance.global_position = gunTip.global_position
		particle_instance.reparent(gunTip)

		var timerpart = Timer.new()
		timerpart.wait_time = 0.5
		timerpart.one_shot = true
		timerpart.autostart = true
		particle_instance.add_child(timerpart)
		timerpart.timeout.connect(func():
			particle_instance.queue_free()
		)

		# Ray setup (UNCHANGED)
		var center = get_viewport().get_size() / 2
		var ray_origin = project_ray_origin(center)
		var ray_dir = project_ray_normal(center).normalized()
		var ray_end = ray_origin + ray_dir * ray_range

		var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
		var intersection = get_world_3d().direct_space_state.intersect_ray(query)

		if not intersection.is_empty():
			print(intersection.collider.name)

			# Draw incoming ray
			DebugDraw3D.draw_arrow(
				ray_origin,
				intersection.position,
				Color.ALICE_BLUE,
				0.1,
				false,
				10
			)

			# --- FIXED BOUNCE VISUALIZATION ---
			var normal = intersection.normal.normalized()

			# IMPORTANT: reflect the *incoming* direction
			var bounce_dir = (-ray_dir).reflect(normal).normalized()

			DebugDraw3D.draw_arrow(
				intersection.position,
				intersection.position + bounce_dir * 1.5,
				Color.DARK_RED,
				0.1,
				false,
				10
			)

			if intersection.collider.name == "DestroyableBox":
				intersection.collider.queue_free()
			else:
				var decal_instance = decal.instantiate()
				get_tree().current_scene.add_child(decal_instance)

				decal_instance.global_position = intersection.position + normal * 0.01
				decal_instance.look_at(decal_instance.global_position + normal, Vector3.UP)
				decal_instance.rotate_object_local(Vector3.RIGHT, deg_to_rad(90))

				var timer = Timer.new()
				timer.wait_time = 0.5
				timer.one_shot = true
				timer.autostart = true
				decal_instance.add_child(timer)
				timer.timeout.connect(func():
					decal_instance.queue_free()
				)
		else:
			print("Nothing")
