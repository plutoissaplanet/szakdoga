extends Node2D


signal ok_button_pressed()
signal confirmation_cancelled()

func set_label_text(text: String) -> void:
	$Title.text = text

func _on_ok_button_pressed():
	ok_button_pressed.emit()


func _on_exit_pressed():
	confirmation_cancelled.emit()
