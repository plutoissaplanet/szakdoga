extends Node2D

@onready var player_detector = $Container/player_detector
@onready var sprite = $Container/Sprite2D
var isEntered = false
var opened = false
@onready var chest_ui = $ChestUI


const possible_drops = {
	"key": "res://GameplayThings/Key/key.tscn",
	"item": "res://GameplayThings/Items/general_scene_for_items.tscn"
}

var shouldOpenWithoutKey: bool
var ID
var itemToDrop
var player


func make_item(drop):
	itemToDrop = load(possible_drops.get(drop)).instantiate()
	itemToDrop.position = self.position + Vector2(20,0)


func _on_player_detector_body_entered(body):
	if body.is_in_group("Player") && !isEntered:
		player = body
		isEntered = true
		print("entered")


func _on_player_detector_body_exited(body):
	if body.is_in_group("Player"):
		isEntered = false
		player = null
		print("exited")


func _on_container_gui_input(event):
	if Input.is_action_pressed("room_changer_click") && isEntered && !opened and _check_if_player_has_correct_key():
		opened = true
		self.get_parent().add_child(itemToDrop)
		print("chest click correctKEy: ", _check_if_player_has_correct_key())
		print("chest click id: ", ID)
		
		
func _check_if_player_has_correct_key():
	var specialInventory
	var correctKey = false
	if player:
		for child in player.get_children():
			if child.name == "SpecialInventory":
				specialInventory = child.get_children()[0]
		if specialInventory:
			for child in specialInventory.get_children():
				print("ches key id:",child.get_meta("ID"))
				if child.get_meta("ID") == ID:
					correctKey = true
					specialInventory.remove_child(child)
					
	return correctKey
