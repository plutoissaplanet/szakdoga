extends Node2D

@export var item : ITEM

@onready var area = $Area2D
@onready var keySprite= $Container/Sprite2D
@onready var node=get_node(".")
@onready var entered = false
var player = null

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		player = body
		entered=true
		print("beért a kulcs sugarába")


func _on_area_2d_body_exited(body):
	if body is CharacterBody2D:
		entered=false
		print("kiment a kulcs sugarába")
		
func _on_container_gui_input(event):
	if Input.is_action_pressed("room_changer_click") && entered:
		player.pick_stuff_up(item)
		node.visible = false
		
