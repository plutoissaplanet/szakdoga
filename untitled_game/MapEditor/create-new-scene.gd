extends Node


var filePath = "res://PlayerMaps/EditorMaps/"


func create_new_scene(mapName: String):
	var mapFilePath = filePath + mapName + ".tscn"
	var rootNode = Node2D.new()
	var script = load("res://MapEditor/map-editor.gd")
	var mapPath = mapFilePath
	if script:
		rootNode.set_script(script)
	else:
		print("failed to load script")
	var newScene = PackedScene.new()
	newScene.pack(rootNode)
	ResourceSaver.save(newScene, mapPath)
	
	SelectedMap.FILE_PATH = mapFilePath
	SelectedMap.FILE_NAME = mapName
	load_scene(mapPath)
	
func create_public_map(mapName: String, data):
	var mapFilePath = "res://OtherMaps/Downloaded/"+mapName+".tscn"
	var jsonFilePath = "res://OtherMaps/Downloaded/"+mapName+".json"
	
	var rootNode = Node2D.new()
	var script = load("res://MapEditor/MapParser/playable_map.gd")
	if script:
		rootNode.set_script(script)
	else:
		print("failed to load script")
	
	var newScene = PackedScene.new()
	newScene.pack(rootNode)
	ResourceSaver.save(newScene, mapFilePath)
	JSON_FILE_FUNCTIONS.save_json_file(jsonFilePath, JSON.stringify(data))
	

func load_scene(mapFilePath):
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
		
func save_map(node, filePath, optionalScript = null):
	if optionalScript:
		node.set_script(optionalScript)
	var newScene = PackedScene.new()
	var result = newScene.pack(node)
	
	if result == OK:
		var saveResult = ResourceSaver.save(newScene, filePath)
		if saveResult == OK:
			print("Save was successful!")
		else:
			print("Save failed!")
	else:
		print("Error packing the scene.")


	
func delete_map():
	pass
	#TODO
	# delete map from database

