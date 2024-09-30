extends Node2D

signal mouse_in_area(event: InputEvent)


func _on_input_event(viewport, event, shape_idx):
	mouse_in_area.emit(event)
