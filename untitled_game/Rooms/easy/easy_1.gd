extends Node2D
@onready var player= get_node("Player")
@onready var animation= get_node("Door/AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_panel_gui_input(event):
#	if Input.is_action_pressed("room_changer_click"):
#		player.position=(Vector2(545,170))

func _on_container_gui_input(event):
	var doorBlocker= get_node("Door/DoorBlocker")
	if Input.is_action_pressed("room_changer_click"):
		animation.play("door_open")
		await  animation.animation_finished
		#player.position=(Vector2(545,170))
		doorBlocker.queue_free()
