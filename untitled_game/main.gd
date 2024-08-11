extends Node2D

@onready var nodes=load("res://nodes.gd")
var currentSystemTime

func _ready():
	get_tree().paused = false
	var parallax = PARALLAX.new()
	add_child(parallax)


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://MainMenuThings/level_chooser.tscn")


func _on_leader_b_pressed():
	get_tree().change_scene_to_file("res://MainMenuThings/LeaderBoard.tscn")


func _on_exit_pressed():
	get_tree().quit()
