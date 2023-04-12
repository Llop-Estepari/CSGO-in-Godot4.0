extends TextureRect

var icons := [preload("res://assets/hud/img_icons/helemt_icon.png"), preload("res://assets/hud/img_icons/vest_icon.png")]

func check_icon(armor):
	if armor > 75:
		texture = icons[0]
	else:
		texture = icons[1]
