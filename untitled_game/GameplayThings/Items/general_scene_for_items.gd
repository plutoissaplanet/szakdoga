extends Node2D

class_name ItemFactory

var entered = false
var player = null
var items = []
var finalItem
var selectedRarity: String
var ARMOR: int
var itemConfig = ItemConfig.new()

func _ready():
	selectedRarity = get_random_rarity()
	load_every_item_rescource(selectedRarity)
	get_random_item()
	finalItem = get_random_item()
	$Sprite2D.texture = finalItem.ITEM_TEXT
	if not finalItem.ITEM_NAME == "Sword":
		ARMOR = finalItem.ARMOR

func load_every_item_rescource(rarity: String):
	var folderDirectory=itemConfig.ITEMS_DICT+rarity+"/"
	for file in DirAccess.get_files_at(folderDirectory):
		if file.get_extension()=="tres":
			items.append(load(folderDirectory+file))

func _on_detect_player_body_entered(body):
	if body.is_in_group("Player"):
		player=body
		entered=true
	
func _on_detect_player_body_exited(body):
	if body.is_in_group("Player"):
		player=null
		entered=false

func _on_container_gui_input(event):
	if event.is_action_pressed("room_changer_click") and entered:
		player.pick_stuff_up(self)
		
func get_random_rarity():
	var randomRarity = randi_range(0,99)
	var selectedRarity: String
	var selectedItem
	
	if randomRarity <= itemConfig.COMMON_MAX:
		selectedRarity = itemConfig.COMMON
	elif randomRarity >itemConfig.COMMON_MAX and randomRarity <= itemConfig.RARE_MAX:
		selectedRarity = itemConfig.RARE
	else:
		selectedRarity = itemConfig.EPIC
	
	return selectedRarity

func get_random_item() -> Resource:
	var randomIndex=randi_range(0, items.size()-1)
	return items[randomIndex]
	
	
