extends Node3D

const shell_9mm = preload("res://assets/guns/ammo_glb/shell_9mm_mesh.res")
const shell_shotgun = preload("res://assets/guns/ammo_glb/shell_shotgun_mesh.res")
@onready var bullet_shell_particle : GPUParticles3D = $GPUParticles3D

func init(ammo_type : String):
	match ammo_type:
		"9mm":
			bullet_shell_particle.draw_pass_1 = shell_9mm
		"shotgun":
			bullet_shell_particle.draw_pass_1 = shell_shotgun
	bullet_shell_particle.emitting = true
