extends CanvasLayer

@onready var animation_player = $wInfo/HBoxContainer/AnimationPlayer
@onready var weapon_image = $wInfo/HBoxContainer/pName/weaponImage
@onready var w_ammo = $wInfo/HBoxContainer/pAmmo/wAmmo
@onready var w_all_ammo = $wInfo/HBoxContainer/pAllAmmo/all_ammo_panel/wAllAmmo


func _ready():
	$wInfo.hide()
	Global.connect("weapon_changed", on_weapon_changed)
	Global.connect("weapon_ammo_changed", on_weapon_shoted)
	
func on_weapon_changed(w_name, ammo, all_ammo):
	$wInfo.show()
	weapon_image.init(w_name)
	w_ammo.text = str(ammo)
	w_all_ammo.text = str(all_ammo)

func on_weapon_shoted(mag, max_ammo):
	animation_player.play("weapon_shoted")
	w_ammo.text = str(mag)
	w_all_ammo.text = str(max_ammo)
