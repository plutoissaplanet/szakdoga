extends Node2D

@onready var player_detector = $StaticBody2D/player_detector
@onready var nanogame = get_node("CenterContainer/nanogram_cells")
@onready var cont = $CenterContainer
var entered = false
var alreadySolved


func _process(delta):
	alreadySolved = nanogame.solved
	if alreadySolved:
		cont.visible=false

		
func _on_container_gui_input(event):
	if Input.is_action_pressed("room_changer_click") && entered && !alreadySolved:
		cont.visible=true
	
	 
func _on_player_detector_body_entered(body):
	if body is PLAYER:
		entered=true

func _on_player_detector_body_exited(body):
	if cont.visible == true:
		cont.visible = false
	if body is PLAYER:
		entered=false
