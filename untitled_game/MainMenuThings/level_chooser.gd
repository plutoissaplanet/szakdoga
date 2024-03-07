extends Node2D


var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _file_counter(path):
	var NumOfFiles = 0
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var files = dir.get_next()
		while files != "":
			if files.ends_with(".tscn"):
				NumOfFiles+=1
			files = dir.get_next()
	print("numbers of .tscn files in " , path , " " , NumOfFiles)
	return NumOfFiles

func change_rooms(path):
		var NumOfFiles = _file_counter(path)
		var index = str(random.randi_range(1, NumOfFiles))
		get_tree().change_scene_to_file(path + index + ".tscn")

func _on_EasyButton_pressed():
	change_rooms("res://Rooms/easy/")
	#get_tree().change_scene_to_file("res://Rooms/easy/2.tscn")
	
func _on_MediumButton_pressed():
	change_rooms("res://Rooms/medium/")

func _on_HardButton_pressed():
	change_rooms("res://Rooms/hard/")



func _on_button_pressed():
	get_tree().change_scene_to_file("res://Rooms/easy/1.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Rooms/easy/2.tscn")
