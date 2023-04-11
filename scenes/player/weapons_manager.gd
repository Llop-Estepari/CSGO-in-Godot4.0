extends Node3D

@onready var weapons_slot = get_children()
@onready var cur_weapon_range :RayCast3D = $cur_weapon_range

var cur_weapon : Node3D

func _input(_event):
	weapons_selection_input()
	fire_weapon()
	if Input.is_action_just_pressed("action_reload"): cur_weapon.reload()

func _ready():
	hide_weapons()

func _process(_delta):
	if cur_weapon != null and cur_weapon.automatic:
		if Input.is_action_pressed("action_fire"): cur_weapon.fire(cur_weapon_range)

func weapons_selection_input():
	if Input.is_key_pressed(KEY_1) and cur_weapon != weapons_slot[0]:
		set_cur_weapon(weapons_slot[0])
	elif Input.is_key_pressed(KEY_2) and cur_weapon != weapons_slot[1]:
		set_cur_weapon(weapons_slot[1])

func fire_weapon():
	if cur_weapon == null: return
	if not cur_weapon.automatic: 
		if Input.is_action_just_pressed("action_fire"): cur_weapon.fire(cur_weapon_range)

func hide_weapons():
	for w in weapons_slot:
		w.hide()

func set_cur_weapon(weapon : Node3D):
	Global.emit_signal("weapon_changed", weapon.name, weapon.cur_ammo, weapon.all_ammo)
	#Cancel animation if player swap gun while animation is playing
	if cur_weapon != null: cur_weapon.cancel_animations()
	hide_weapons()
	cur_weapon = weapon
	weapon.graphics.rotation = Vector3(0,0,0)
	#Set raycast height with weapon range
	cur_weapon_range.target_position.z = -weapon.w_range
	cur_weapon.show_weapon()
