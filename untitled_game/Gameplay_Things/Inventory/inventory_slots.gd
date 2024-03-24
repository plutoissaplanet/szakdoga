extends Panel

@onready var item_visual: Sprite2D = $Display

func update(item: InventoryItem):
	if !item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = item.texture
