extends Node3D

@onready var _trail_mesh = $Trail

var max_distance: float
var _trail_mesh_height: float

var _bullet_trail_life_time: float = 2
var _bullet_trail_speed: float = 250

func _ready():
	_trail_mesh_height = _trail_mesh.mesh.height
	if max_distance == 0:
		await get_tree().create_timer(_bullet_trail_life_time).timeout
		queue_free()

func _process(delta):
	_trail_mesh.position += Vector3.FORWARD * _bullet_trail_speed * delta
	if max_distance > 0 and global_position.distance_to(_trail_mesh.global_position) >= (max_distance - (_trail_mesh_height * 2)): queue_free();
