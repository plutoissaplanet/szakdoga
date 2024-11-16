extends StaticBody2D

@onready var animation = get_node("AnimationPlayer")
@onready var doorBlocker = get_node("DoorCollision")
@onready var door = get_node(".")
@onready var near_the_door_detector = get_node("near_the_door_detector")
@onready var entered= false
@onready var alreadyOpen = false

var positionToTeleportTo


var ID
var player
var FINAL_DOOR: bool = false
var GO_BACK_DOOR: bool = false



func _on_texture_rect_gui_input(event):
	if event.is_action_pressed("room_changer_click"):
		print("entered: ",entered)
		print("go back door: ",GO_BACK_DOOR)
		print("already open: ",alreadyOpen)
	
	if event.is_action_pressed("room_changer_click") and entered and GO_BACK_DOOR:
		_open_door()
		print("first if")
	if event.is_action_pressed("room_changer_click") and not alreadyOpen and entered and _check_if_player_has_correct_key():
		_open_door()
		print("second if")
	elif event.is_action_pressed("room_changer_click") and entered and alreadyOpen:
		_open_door()
		print("third if")
	
	
func _open_door():
	animation.play("door_opening")
	await  animation.animation_finished
	doorBlocker.set_disabled(true)
	alreadyOpen = true
	_teleport_palyer_to_next_room()


func _check_if_player_has_correct_key():
	var specialInventory
	var correctKey = false
	if player:
		for child in player.get_children():
			if child.name == "SpecialInventory":
				specialInventory = child.get_children()[0]
		if specialInventory:
			for child in specialInventory.get_children():
				print(child.get_meta("ID"))
				if child.get_meta("ID") == ID:
					correctKey = true
					specialInventory.remove_child(child)

	return correctKey

func _teleport_palyer_to_next_room():
	if not FINAL_DOOR:
		player.position = positionToTeleportTo
	else:
		print("EXIT!")


func _on_near_the_door_detector_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		entered = true
		print("entered")


func _on_near_the_door_detector_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		entered = false
		print("exited")


