extends Node


var filePath = "res://Player Maps/asdasd.tscn" #TODO make it so the player can input a name, maybe a parameter in map_editor_button_on_click

func create_new_scene():
	var rootNode = Node2D.new()
	var script = load("res://MapEditor/map-editor.gd")
	if script:
		rootNode.set_script(script)
	var newScene = PackedScene.new()
	newScene.pack(rootNode)
	ResourceSaver.save(newScene, filePath)
	_load_scene()

func _load_scene():
	get_tree().change_scene_to_file(filePath)



func map_on_save_button_pressed():
	pass
	#TODO
	#remove every editor specific node
	#save map

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

