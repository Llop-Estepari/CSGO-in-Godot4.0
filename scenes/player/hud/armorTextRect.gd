extends TextureRect
@onready var helmet_icon = $helmet_icon

func update_armor_icon(armor):
	helmet_icon.visible = false
	if armor >= 75:
		helmet_icon.visible = true
