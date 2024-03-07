extends Node2D

@onready var animation= get_node("Door/AnimationPlayer")
@onready var player = get_node("Player")
var functions =load("res://FunctionsToUse.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_container_gui_input(event):
	var doorBlocker= get_node("Door/DoorBlocker")
	functions._DoorOpener(animation, doorBlocker)

func _on_player_detector_body_entered(body):
	var sharedWall = get_node("Room1/Room1Tiles")
	var door = get_node("Door")

	if body == player:
		functions._WallZIndexChanger(sharedWall, door)

