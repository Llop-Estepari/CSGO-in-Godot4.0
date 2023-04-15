extends CanvasLayer

#Health Container
##Health
@onready var h_label = $hContainer/HBoxContainer/health/Label
@onready var h_progress_bar = $hContainer/HBoxContainer/health/ProgressBar
##Armor
@onready var a_label = $hContainer/HBoxContainer/armor/Label
@onready var a_progress_bar = $hContainer/HBoxContainer/armor/ProgressBar
@onready var armor_text_rect = $hContainer/HBoxContainer/armor/Panel/armorTextRect

#Weapon Container
#Ammo
@onready var h_box_bullet = $wContainer/HBoxContainer/HBox_bullet
@onready var cur_ammo = $wContainer/HBoxContainer/PanelContainer/cur_ammo
@onready var max_ammo = $wContainer/HBoxContainer/PanelContainer/max_ammo

func _ready():
	$wContainer.hide()
	Global.connect("weapon_changed", on_weapon_changed)
	Global.connect("weapon_ammo_changed", on_weapon_shoted)
	Global.connect("health_changed", on_health_changed)

func on_weapon_changed(w_name, ammo, all_ammo, mag_ammo):
	$wContainer.show()
	cur_ammo.text = str(ammo)
	max_ammo.text = str("/", all_ammo)
	h_box_bullet.weapon_changed(ammo, all_ammo, mag_ammo)

func on_weapon_shoted(mag, all_ammo, reload):
	cur_ammo.text = str(mag)
	max_ammo.text = str("/", all_ammo)
	if !reload:
		h_box_bullet.update(mag, all_ammo)
	else:
		h_box_bullet.reload(mag)

func on_health_changed(hp, ap):
	h_label.text = str(hp)
	h_progress_bar.value = hp
	a_label.text = str(ap)
	a_progress_bar.value = ap
	armor_text_rect.update_armor_icon(ap)
