extends Panel

var itemSprite=preload("res://GameplayThings/Items/general_scene_for_items.tscn")
var item = null


func pickItemFromSlot():
	if item and has_node(item.get_path()):
		remove_child(item)
		print("picked up and children count: ", self.get_child_count())
		var inventoryNode=find_parent("Inventory")
		inventoryNode.add_child(item)
		item=null

func placeItemIntoSlot(placableItem, slot):
	if (placableItem.finalItem.ITEM_NAME == "Sword" && slot.is_in_group("Sword")) || (placableItem.finalItem.ITEM_NAME == "Boot" && slot.is_in_group("Boot")) || (placableItem.finalItem.ITEM_NAME == "Chestplate" && slot.is_in_group("Plate")) :
		if placableItem.get_parent():
			placableItem.get_parent().remove_child(placableItem)
		item=placableItem
		slot.add_child(item)
		item.position = Vector2(4, 4)

	

