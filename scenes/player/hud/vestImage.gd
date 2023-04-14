extends TextureRect

var icons := [preload("res://assets/hud/img_icons/stahlhelm.png"),preload("res://assets/hud/img_icons/trench-body-armor.png")]

func check_icon(armor):
	if armor > 75:
		texture = icons[0]
	else:
		texture = icons[1]
