extends Object
class_name WeaponUtilities

static func play_shoot_sound(
	sound_player: AudioStreamPlayer3D,sound: AudioStreamWAV) -> void:
		
	if sound == null || sound_player == null:
		return
		
	sound_player.stream = sound
	sound_player.play()

static func create_timer(owner: Node, time: float) -> Timer:
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = time
	owner.add_child(timer)
	timer.start()
	return timer

static func shoot_ray(
	from: Node,
	origin: Vector3,
	direction: Vector3,
	distance: float,
	collision_mask: int = 0xFFFFFFFF
) -> Dictionary:
	
	var space_state = from.get_world_3d().direct_space_state

	var query := PhysicsRayQueryParameters3D.create(
		origin,
		origin + direction.normalized() * distance
	)
	query.collision_mask = collision_mask
	query.exclude = [from]

	var result = space_state.intersect_ray(query)
				# Draw incoming ray
	DebugDraw3D.draw_arrow(
		origin,
		result.position,
		Color.ALICE_BLUE,
		0.1,
		false,
		10
	)
	
	return result

static func spawn_node_temp(
	owner: Node3D,scene: PackedScene,
	instance_position: Vector3,
	lookatpos: Vector3,
	aligned: bool, reparented: bool,
	new_parent: Node3D, max_time:float) -> void:
	var instance = scene.instantiate()
	owner.get_tree().current_scene.add_child(instance)

	instance.global_position = instance_position
	
	if aligned: instance.look_at(instance.global_position + lookatpos, Vector3.UP)
	
	if aligned: instance.rotate_object_local(Vector3.RIGHT, deg_to_rad(90))
	
	if reparented: instance.reparent(new_parent)

	var timer = Timer.new()
	timer.wait_time = max_time
	timer.one_shot = true
	timer.autostart = true
	instance.add_child(timer)
	timer.timeout.connect(func():
		instance.queue_free()
	)
