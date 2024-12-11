extends Control


func _ready():
	$Points/GridContainer.add_theme_constant_override("v_separation", 20)
	$Points/GridContainer.add_theme_constant_override("h_separation", 20)
	

	

func set_up_winner_screen():
	$RichTextLabel.text = "YOU WON!"
	$Points/GridContainer/PointsLostLabel.text = "Points gained:"
	$Points/GridContainer/PointsTotalLabel.text = "Total points:"
	$RetryButton.visible = false

func _on_retry_button_pressed():
	get_tree().reload_current_scene()

func _on_back_to_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_exit_game_button_pressed():
	get_tree().quit()

func display_points(pointsLost: int, pointsTotal: int):
	$Points.visible = true
	$Points/GridContainer/PointsLost.text = str(pointsLost)
	$Points/GridContainer/PointsTotal.text = str(pointsTotal)
