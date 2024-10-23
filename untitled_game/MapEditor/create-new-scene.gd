extends Node


var filePath = "res://PlayerMaps/"


func create_new_scene(mapName: String):
	var mapFilePath = filePath + mapName + ".tscn"
	var rootNode = Node2D.new()
	var script = load("res://MapEditor/map-editor.gd")
	var mapPath = mapFilePath
	if script:
		rootNode.set_script(script)
	var newScene = PackedScene.new()
	newScene.pack(rootNode)
	ResourceSaver.save(newScene, mapPath)
	
	SelectedMap.FILE_PATH = mapFilePath
	SelectedMap.FILE_NAME = mapName
	_load_scene(mapPath)

func _load_scene(mapFilePath):
	get_tree().change_scene_to_file(mapFilePath)

func map_on_save_button_pressed(node: Node2D):
	var mapPath = SelectedMap.FILE_PATH
	var newScene = PackedScene.new()
	var result = newScene.pack(node)
	
	if result == OK:
		var saveResult = ResourceSaver.save(newScene, mapPath)
		if saveResult == OK:
			print("Save was successful!")
		else:
			print("Save failed!")
	else:
		print("Error packing the scene.")


func save_map_into_database():
	pass
	#TODO
	#transform .tscn file into a type that can be uploaded to firebase
	#add it to firebase
	# document properties: username, creation date, difficulty, likes, dislikes, number of users that played
	# document key: randomly generated
	# save it to users personal collection, and also into a general map collection
	
func delete_map():
	pass
	#TODO
	# delete map from database

