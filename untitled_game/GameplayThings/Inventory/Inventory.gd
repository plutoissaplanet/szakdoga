extends Node2D

class_name Inventory

@onready var inventorySlots=$GridContainer.get_children()
@onready var armoryInventorySlots = $GridContainer2.get_children()
var heldItem=null
var player = null 

func _ready():
	player = self.get_parent()
	self.visible=false
	for slots in inventorySlots:
		slots.gui_input.connect(clicked_on_slot.bind(slots))
	for slots in armoryInventorySlots:
		slots.gui_input.connect(clicked_on_slot.bind(slots))
		slots.child_entered_tree.connect(apply_armor_states_to_player.bind(slots))
		
func _process(delta):
	if heldItem:
		heldItem.global_position=get_global_mouse_position()

func _input(event):
	if Input.is_action_pressed("inventory"):
		self.visible = not self.visible

func clicked_on_slot(event:InputEvent, slot: Panel):
	if self.visible and event.is_action_pressed("room_changer_click"):
		if heldItem:
			if slot.get_child_count() == 0:
				slot.placeItemIntoSlot(heldItem, slot)
				heldItem=null
		elif slot.get_child_count()>0:
			heldItem = slot.get_child(0)
			slot.pickItemFromSlot()
			
func pick_up_item(item):
	var itemParent = item.get_parent()
	if itemParent:
		itemParent.remove_child(item)
	item.remove_child(item.get_child(0))
	for slot in inventorySlots:
		if slot.get_child_count() == 0:
			slot.add_child(item)
			item.position = Vector2(4, 4)
			item.scale=Vector2(1,1)
			return

func apply_armor_states_to_player(child, slot):
	var armorInSlot = child
	player.totalHealth += armorInSlot.ARMOR
	player.healthBar.update_total_health(player.totalHealth)

func all_slots_are_occupied():
	for slot in inventorySlots:
		if slot.get_child_count() == 0:
			return false
	return true
			
			
