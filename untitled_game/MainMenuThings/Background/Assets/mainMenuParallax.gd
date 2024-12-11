extends Camera2D

@export var scroll_speed : Vector2 = Vector2(50, 0)


func _process(delta):
	offset += scroll_speed * delta
	set_offset(offset)
