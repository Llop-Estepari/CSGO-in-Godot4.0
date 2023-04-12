extends CanvasLayer

@onready var animation_player = $wInfo/HBoxContainer/AnimationPlayer
@onready var weapon_image = $wInfo/HBoxContainer/pName/weaponImage
@onready var w_ammo = $wInfo/HBoxContainer/pAmmo/wAmmo
@onready var w_all_ammo = $wInfo/HBoxContainer/pAllAmmo/all_ammo_panel/wAllAmmo
@onready var hp = $hInfo/HBoxContainer/HBoxContainer/HP
@onready var ap = $hInfo/HBoxContainer/HBoxContainer2/AP
@onready var vest_image = $hInfo/HBoxContainer/HBoxContainer2/vestImage


func _ready():
	$wInfo.hide()
	Global.connect("weapon_changed", on_weapon_changed)
	Global.connect("weapon_ammo_changed", on_weapon_shoted)
	Global.connect("health_changed", on_health_changed)
	
func on_weapon_changed(w_name, ammo, all_ammo):
	$wInfo.show()
	weapon_image.init(w_name)
	w_ammo.text = str(ammo)
	w_all_ammo.text = str(all_ammo)

func on_weapon_shoted(mag, max_ammo):
	animation_player.play("weapon_shoted")
	w_ammo.text = str(mag)
	w_all_ammo.text = str(max_ammo)

func on_health_changed(_hp, _ap):
	if _hp == 0:
		$wInfo.queue_free()
	hp.text = str(_hp)
	ap.text = str(_ap)
	vest_image.check_icon(_ap)
