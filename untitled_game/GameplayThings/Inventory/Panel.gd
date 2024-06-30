extends Panel

var itemSprite=preload("res://GameplayThings/Items/general_scene_for_items.tscn")
var item = null


func _ready():
	#item = itemSprite.instantiate()
	#if randi()%2==0:
		#add_child(item)
		#item.position = Vector2(4, 4)
	pass

func pickItemFromSlot():
	if item and has_node(item.get_path()):
		remove_child(item)
		var inventoryNode=find_parent("Inventory")
		inventoryNode.add_child(item)
		item=null

func placeItemIntoSlot(placableItem, slot):
	if placableItem.get_parent():
		placableItem.get_parent().remove_child(placableItem)
	item=placableItem
	slot.add_child(item)
	item.position = Vector2(4, 4)

	

