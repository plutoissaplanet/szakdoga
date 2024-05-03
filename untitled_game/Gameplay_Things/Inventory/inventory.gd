extends Resource

class_name Inventory
signal update

@export var slot: Array[InvSlot]

func pickup(item: ITEM):
	#var item_s = slot.filter(func(slot): return slot.item == item)
	var empty = slot.filter(func(slot): return slot.item==null)
	if !empty.is_empty():
		empty[0].item=item
	update.emit()
