extends Node2D


@onready var player= get_node("Player")
@onready var animation= get_node("Door/AnimationPlayer")
var functions =load("res://FunctionsToUse.gd")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_panel_gui_input(event):
#	if Input.is_action_pressed("room_changer_click"):
#		player.position=(Vector2(545,170))

func _on_container_gui_input(event):
	var doorBlocker= get_node("Door/DoorBlocker")
	functions._DoorOpener(animation, doorBlocker)
	
func _on_player_detector_body_entered(body):
	var shared_wall=get_node("Room1/MapTiles")
	var door = get_node("Door")
	
	if body == player:
		functions._WallZIndexChanger(shared_wall, door)
	
