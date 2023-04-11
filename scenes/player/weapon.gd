class_name Weapon
extends Node3D

@onready var graphics = $Graphics
@onready var timer : Timer = $Timer
@onready var animation_player = $AnimationPlayer
@onready var muzzle_node : Node3D = $Graphics/Muzzle
@onready var _head : Node3D = $"../../.."
@onready var shell_spawner : Marker3D = $"../shotgun/Graphics/shell_spawner"

@export var automatic : bool = false
@export var fire_rate : float = 1.0
@export var max_ammo : int = 30
@export var mag_ammo : int = 10
@export var w_range : int = 50
@export var muzzle_flash_scale : Vector2 = Vector2(0.15, 0.15)

const _bullet_trail_prefab: PackedScene = preload("res://scenes/player/bullet_tail.tscn")
const _muzzle_flash_prefab: PackedScene = preload("res://scenes/player/muzzle_flash.tscn")
const _shell_prefab: PackedScene = preload("res://scenes/player/bullet_shell.tscn")

# AMMO
@export var can_shot := true
@export var can_reload := true
var cur_ammo
var all_ammo := 100

# SWAY
var mouse_mov
var sway_threshold = 5
var sway_lerp = 1
#

func _input(event):
	if event is InputEventMouseMotion:
		mouse_mov = -event.relative.x
		mouse_mov = clamp(mouse_mov, -20, 20)

func _ready():
	cur_ammo = mag_ammo
	all_ammo = max_ammo
	timer.connect("timeout", on_timer_timeout)

func _process(delta):
	sway(delta)

func fire(cur_weapon_range : RayCast3D):
	if can_shot:
		if cur_ammo > 0:
			if cur_weapon_range.is_colliding():
				if cur_weapon_range.get_collider() is Area3D: print("enemy_hitted")
				else: print("wall_hitted")
			visuals_fire(cur_weapon_range)
			can_shot = false
			cur_ammo -= 1
			timer.start(fire_rate)
			update_ammo()

func reload():
	if all_ammo == 0 or cur_ammo == mag_ammo or !can_reload:
		return
	animation_player.play("reload")

func reload_ammo():
	while cur_ammo < mag_ammo:
		if all_ammo == 0:
			break
		cur_ammo += 1
		all_ammo -= 1
	update_ammo()

func visuals_fire(cur_weapon_range : RayCast3D):
	animation_player.play("shot")
	
	#BULLET TRAIL
	var bullet_trail = _bullet_trail_prefab.instantiate()
	var look_at_point = _head.global_position + (-_head.global_transform.basis.z * 100)
	if cur_weapon_range.is_colliding():
		bullet_trail.max_distance = muzzle_node.global_position.distance_to(cur_weapon_range.get_collision_point())
		look_at_point = cur_weapon_range.get_collision_point()
	get_tree().get_root().add_child(bullet_trail)
	bullet_trail.global_position = muzzle_node.global_position
	bullet_trail.look_at(look_at_point, Vector3.UP)
	
	#MUZZLE FLASH
	var muzzle_flash = _muzzle_flash_prefab.instantiate()
	muzzle_flash.custom_size = muzzle_flash_scale
	muzzle_node.add_child(muzzle_flash)
	
	#SHELL
	var shell = _shell_prefab.instantiate()
	get_tree().get_root().add_child(shell)
	shell.global_position = shell_spawner.global_position
	shell.look_at(look_at_point, Vector3.UP)
	shell.init("9mm")

func on_timer_timeout():
	can_shot = true

func sway(delta):
	if mouse_mov != null:
		mouse_mov = lerpf(mouse_mov, 0, .6)
		if mouse_mov > sway_threshold: graphics.rotation = graphics.rotation.lerp(Vector3(0,-0.5,0), sway_lerp * delta)
		elif mouse_mov < -sway_threshold: graphics.rotation = graphics.rotation.lerp(Vector3(0,0.5,0), sway_lerp * delta)
		else: graphics.rotation = graphics.rotation.lerp(Vector3(0,0,0), sway_lerp * delta)

#UPDATE AMMO IN HUD
func update_ammo():
	Global.emit_signal("weapon_ammo_changed", cur_ammo, all_ammo)

func show_weapon():
	show()
	animation_player.play("pull_up")

func cancel_animations():
	animation_player.play("RESET")
