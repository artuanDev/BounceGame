class_name GunStats extends WeaponStats

@export var recoil_strength: float = 3.0
var shoot_decal:PackedScene = preload("res://Assets/Scenes/Prefabs/shoot_decal.tscn")
var shoot_particle:PackedScene = preload("res://Assets/Scenes/Prefabs/ShootParticle.tscn")
var shoot_sound: AudioStreamWAV = preload("res://Assets/Sounds/SFX/laserShoot.wav")
