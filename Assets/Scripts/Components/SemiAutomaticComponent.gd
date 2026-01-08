class_name SemiautomaticComponent extends Node3D

@export var gun_info: HandGun;
@export var sound_player: AudioStreamPlayer3D
@onready var GunPos : Node3D = get_parent_node_3d().get_parent()

var startPos : Vector3
var can_shoot : bool = true

func _ready() -> void:
	startPos = GunPos.position
	
func _process(delta: float) -> void:
	GunPos.position = lerp(GunPos.position, startPos, 10 * delta)
	
	if Input.is_action_just_pressed("shoot") && can_shoot:
		var intersection = WeaponUtilities.shoot_ray(
			gun_info.cam,
			gun_info.cam.global_position,
			-gun_info.cam.global_transform.basis.z,
			100.0
		)
		
		if intersection != null:
			WeaponUtilities.spawn_node_temp(
				self, gun_info.Gun.shoot_decal,
				intersection.position + intersection.normal * 0.01,intersection.normal,
				true, false, null, 0.5
				)
			
		WeaponUtilities.spawn_node_temp(
			self, gun_info.Gun.shoot_particle,
			gun_info.GunTip.global_position,intersection.normal,
			false, true, gun_info.GunTip, 0.1
			)
		print(intersection.collider.name)
		WeaponUtilities.play_shoot_sound(sound_player,gun_info.Gun.shoot_sound)
		
		GunPos.global_position += GunPos.global_basis.z * gun_info.Gun.recoil_strength
		can_shoot = false
		
		await WeaponUtilities.create_timer(self, gun_info.Gun.cooldown_time).timeout
		can_shoot = true
