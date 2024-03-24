extends Node

static func _DoorOpener(animation, doorBlocker):
	if Input.is_action_pressed("room_changer_click"):
		animation.play("door_open")
		await  animation.animation_finished
		doorBlocker.set_disabled(true)

static func _WallZIndexChanger(sharedWall, door):
	if sharedWall.get_z_index() == 0:
		print("entered")
		sharedWall.set_z_index(2)
		door.set_z_index(2)
	elif sharedWall.get_z_index() == 2:
		print("entered")
		sharedWall.set_z_index(0)
		door.set_z_index(0)


