extends Node2D

class_name Inventory

@onready var inventorySlots=$GridContainer.get_children()
@onready var armoryInventorySlots = $GridContainer2.get_children()
@onready var swordSlot = $TextureRect3/SwordSlot
var heldItem=null
var player = null 

func _ready():
	player = get_parent()
	self.visible=false
	for slots in inventorySlots:
		slots.gui_input.connect(clicked_on_slot.bind(slots))
	for slots in armoryInventorySlots:
		slots.gui_input.connect(clicked_on_slot.bind(slots))
		slots.child_entered_tree.connect(apply_armor_states_to_player.bind(slots))
	swordSlot.gui_input.connect(clicked_on_slot.bind(swordSlot))
	swordSlot.child_entered_tree.connect(apply_armor_states_to_player.bind(swordSlot))
		
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
	elif self.visible and event.is_action_pressed("right_mouse_button"):
		var itemInSlot = slot.get_child(0)
		if player.attackBonus == 0 and player.speedBonus == 0 and itemInSlot.finalItem is ATTACK_POTION or itemInSlot.finalItem is SPEED_POTION or itemInSlot.finalItem is HEALTH_POTIONS:
			if itemInSlot.finalItem is HEALTH_POTIONS and player.stats.HealthPoints == player.totalHealth:
				return
			player.consumed_potion.emit(itemInSlot.finalItem)
			slot.remove_child(slot.get_child(0))
			
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
	if slot.is_in_group("Sword") and armorInSlot.finalItem.ITEM_NAME == "Sword":
		player.stats.AttackPoints += armorInSlot.finalItem.ATTACK_POINTS
	else:
		player.totalHealth += armorInSlot.ARMOR
		player.healthBar.update_total_health(player.totalHealth)
		

func all_slots_are_occupied():
	for slot in inventorySlots:
		if slot.get_child_count() == 0:
			return false
	return true
			
			
