extends HBoxContainer
@onready var animation_player = $AnimationPlayer

var max_slots = 5

var cur_max_ammo : int = 0

func update(ammo, max_mag_ammo : int = cur_max_ammo):
	check_low_ammo(ammo)
	if ammo > 4: animation_player.play("shot")
	elif ammo == 4: animation_player.play("5to4")
	elif ammo == 3: animation_player.play("4to3")
	elif ammo == 2: animation_player.play("3to2")
	elif ammo == 1: animation_player.play("2to1")
	elif ammo == 0: animation_player.play("1to0")

func reload(max_ammo):
	check_low_ammo(max_ammo)
	if max_ammo > 4: animation_player.play("RESET")
	elif max_ammo == 4: animation_player.play("4bullets")
	elif max_ammo == 3: animation_player.play("3bullets")
	elif max_ammo == 2: animation_player.play("2bullets")
	elif max_ammo == 1: animation_player.play("1bullets")

func weapon_changed(ammo, _max_ammo, max_mag_ammo):
	cur_max_ammo = max_mag_ammo
	check_low_ammo(ammo)
	if ammo > 4: animation_player.play("RESET")
	elif ammo == 4: animation_player.play("4bullets")
	elif ammo == 3: animation_player.play("3bullets")
	elif ammo == 2: animation_player.play("2bullets")
	elif ammo == 1: animation_player.play("1bullets")
	elif ammo == 0: animation_player.play("0bullets")

func check_low_ammo(ammo):
	modulate = Color(1, 1, 1, .8)
	var red_amount = 1
	if cur_max_ammo > 10 and cur_max_ammo < 19: red_amount = 2
	elif cur_max_ammo > 19: red_amount = 4
	elif cur_max_ammo > 30: red_amount = 5
	
	if ammo <= red_amount: modulate = Color(1, 0, 0, .8)
