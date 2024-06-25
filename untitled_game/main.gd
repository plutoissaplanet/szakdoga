extends Node2D

@onready var nodes=load("res://nodes.gd")
var currentSystemTime

# Called when the node enters the scene tree for the first time.
func _ready():
	var nightTimeParallaxBackgroundLoad = load("res://MainMenuThings/Background/Assets/Nighttime/mainMenuParallaxNighttime.tscn")
	var dayTimeParallaxBackgroundLoad  = load("res://MainMenuThings/Background/Assets/Clearing/mainMenuParallaxDaytime.tscn")
	
	var nightTimeParallaxBackground = nightTimeParallaxBackgroundLoad.instantiate()
	var dayTimeParallaxBackground = dayTimeParallaxBackgroundLoad.instantiate()
	var  node = get_node(".")
	currentSystemTime = Time.get_datetime_dict_from_system()

	if currentSystemTime.hour >= 17:
		add_child(nightTimeParallaxBackground)
	else:
		add_child(dayTimeParallaxBackground)
		
		
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://MainMenuThings/level_chooser.tscn")


func _on_leader_b_pressed():
	get_tree().change_scene_to_file("res://MainMenuThings/LeaderBoard.tscn")


func _on_exit_pressed():
	get_tree().quit()
