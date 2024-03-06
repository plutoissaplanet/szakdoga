extends Node2D
@onready var player= get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_panel_5_gui_input(event):
#	if Input.is_action_pressed("room_changer_click"):
#		player.position=(Vector2(600,400))


func _on_panel_gui_input(event):
	if Input.is_action_pressed("room_changer_click"):
		player.position=(Vector2(545,170))
