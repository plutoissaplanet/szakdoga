extends Node2D

@onready var player_detector = $Container/player_detector
@onready var sprite = $Container/Sprite2D
@onready var isEntered = false
@onready var chest_ui = $ChestUI
@onready var openSesame = false

func _ready():
	pass

func _on_player_detector_body_entered(body):
	if body is CharacterBody2D && !isEntered:
		isEntered = true
		print("entered")


func _on_player_detector_body_exited(body):
	if body is CharacterBody2D && isEntered:
		isEntered = false
		if chest_ui.visible==true:
			chest_ui.visible=false
		print("exited")


func _on_container_gui_input(event):
	if Input.is_action_pressed("room_changer_click") && isEntered && openSesame:
		sprite.texture = load("res://Gameplay_Things/Chests/chest_opened.png")
		chest_ui.visible = true
