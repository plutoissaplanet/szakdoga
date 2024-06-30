extends Control


func _on_retry_button_pressed():
	get_tree().reload_current_scene()

func _on_back_to_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_exit_game_button_pressed():
	get_tree().quit()
