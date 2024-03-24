extends Control


var is_open= false
@onready var inventory: Inventory = preload("res://Gameplay_Things/Inventory/PlayerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	updateSlots()
	close()
	
@warning_ignore("unused_parameter")
func _input(event):
	if Input.is_action_pressed("inventory"):
		if is_open:
			close()
		else:
			open()
		
	
func close():
	visible= false
	is_open= false
	
func open():
	visible= true
	is_open= true

func updateSlots():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])

