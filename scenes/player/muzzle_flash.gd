extends Node3D

@onready var _particles: GPUParticles3D = $GPUParticles3D
var _life_time: float = 0.2
var custom_size

func _ready():
	_particles.emitting = true
	_particles.draw_pass_1.size = custom_size
	await get_tree().create_timer(_life_time).timeout
	queue_free()
