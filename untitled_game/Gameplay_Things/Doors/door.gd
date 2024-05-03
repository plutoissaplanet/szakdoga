extends StaticBody2D

@onready var animation = get_node("AnimationPlayer")
@onready var doorBlocker = get_node("DoorCollision")
@onready var door = get_node(".")
@onready var player_detector = get_node("player_detector")
@onready var near_the_door_detector = get_node("near_the_door_detector")

@onready var entered= false
@onready var alreadyOpen = false

func _process(delta):
	if entered:
		DoorOpener()

func DoorOpener():
	if Input.is_action_pressed("room_changer_click"):
		animation.play("door_opening")
		await  animation.animation_finished
		doorBlocker.set_disabled(true)

func WallZIndexChanger(sharedWall, door_parm):
	if sharedWall.get_z_index() == 0:
		print("entered")
		sharedWall.set_z_index(2)
		door_parm.set_z_index(2)
	elif sharedWall.get_z_index() == 2:
		print("entered")
		sharedWall.set_z_index(0)
		door_parm.set_z_index(0)

func _on_near_the_door_detector_body_entered(body):
	print(body)
	if body is CharacterBody2D && !alreadyOpen:
		entered = true
		alreadyOpen= true
		return entered


func _on_near_the_door_detector_body_exited(body):
	if body is CharacterBody2D:
		entered = false
		return entered
