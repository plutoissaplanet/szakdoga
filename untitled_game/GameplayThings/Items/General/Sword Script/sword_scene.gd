extends Sprite2D

class_name SWORD_SCENE

@export var SWORD_ITEM: SWORDS

func _ready():
	if SWORD_ITEM:
		texture=SWORD_ITEM.ITEM_TEXT
	else:
		printerr("texture not found.")

func _process(delta):
	pass
