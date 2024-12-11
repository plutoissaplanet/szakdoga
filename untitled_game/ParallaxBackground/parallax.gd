extends Node
class_name PARALLAX


var currentSystemTime

func _ready():
	var nightTimeParallaxBackgroundLoad = load("res://MainMenuThings/Background/Assets/Nighttime/mainMenuParallaxNighttime.tscn")
	var dayTimeParallaxBackgroundLoad  = load("res://MainMenuThings/Background/Assets/Clearing/mainMenuParallaxDaytime.tscn")
	
	var nightTimeParallaxBackground = nightTimeParallaxBackgroundLoad.instantiate()
	var dayTimeParallaxBackground = dayTimeParallaxBackgroundLoad.instantiate()

	currentSystemTime = Time.get_datetime_dict_from_system()

	if currentSystemTime.hour >= 17:
		add_child(nightTimeParallaxBackground)
	else:
		add_child(dayTimeParallaxBackground)
