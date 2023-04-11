extends TextureRect

var pistol_img = preload("res://assets/hud/img_weapons/pistol.png")
var shotgun_img = preload("res://assets/hud/img_weapons/shotgun.png")

func init(weapon : String):
	match weapon:
		"pistol":
			texture = pistol_img
		"shotgun":
			texture = shotgun_img
