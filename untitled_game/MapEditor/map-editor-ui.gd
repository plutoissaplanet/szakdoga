extends Node2D

var loadedPrivatedMaps = {}
var containerHeight = 40
var containerWidth
var scrollContainer: ScrollContainer
var gridContainer: GridContainer

var mapDirectory = "res://PlayerMaps/"
var mapNames = []

var editButtonTexture = preload("res://Game Assets/MapEditor/Icons/pencil.png")
var deleteButtonTexture = preload("res://Game Assets/MapEditor/Icons/Icons_03.png")
var shareButtonTexture = preload("res://Game Assets/MapEditor/Icons/Icons_51.png")
var containerBackground = preload("res://Game Assets/GUI/backdrop3.png")
var font = preload("res://Game Assets/Font/CraftPixNet Survival Kit.otf")

# TODO
# section for all the maps the user already has
# published and unpublished section
# if clicked on the editor tool, the user can edit it
# if clicked on the "publish" button, the user can make it available to every other user
# if clicked on the delete --> user can delete it
# show likes and dislikes on the published maps
# user can unpublish maps, and edit them and then republish --> every stat gets lost
# creare new map button
# "go back" button

func _ready():
	gridContainer = get_node("TabContainer/Privated Rooms/ScrollContainer/GridContainer")
	scrollContainer = get_node("TabContainer/Privated Rooms/ScrollContainer")
	containerWidth = scrollContainer.size.x
	get_tree().paused = false
	_load_all_map_names()

func _load_all_map_names():
	for file in FileLoader.get_directory_filenames(mapDirectory):
		if file.ends_with(".tscn"):
			mapNames.append(file.get_basename())
	for map in mapNames:
		_make_map_container(map, mapDirectory+map+".tscn")

func _make_map_container(mapName: String, filePath: String):
	var container = Container.new()
	container.size = Vector2(containerWidth, containerHeight)
	container.set_meta("FILE_PATH", filePath)
	container.set_meta("FILE_NAME", mapName)

	var background = TextureRect.new()
	background.size = Vector2(containerWidth, containerHeight-4)
	background.texture = containerBackground
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_SCALE
	
	var editButton = TextureButton.new()
	var deleteButton = TextureButton.new()
	var shareButton = TextureButton.new()
	
	editButton.ignore_texture_size = true
	deleteButton.ignore_texture_size = true
	shareButton.ignore_texture_size = true
	
	editButton.stretch_mode = TextureButton.STRETCH_SCALE
	deleteButton.stretch_mode = TextureButton.STRETCH_SCALE
	shareButton.stretch_mode = TextureButton.STRETCH_SCALE
	
	editButton.texture_normal = editButtonTexture
	deleteButton.texture_normal = deleteButtonTexture
	shareButton.texture_normal = shareButtonTexture
	
	editButton.size = Vector2(24, 24)
	deleteButton.size = Vector2(24, 24)
	shareButton.size = Vector2(24, 24)
	
	editButton.position = Vector2(containerWidth-110,6)
	deleteButton.position = Vector2(containerWidth-70, 6)
	shareButton.position = Vector2(containerWidth-30,6)
	
	var mapNameLabel = Label.new()

	mapNameLabel.text = mapName
	mapNameLabel.add_theme_color_override("font_color", Color("#3d253b"))
	mapNameLabel.add_theme_font_override("font", font)
	mapNameLabel.add_theme_font_size_override("font_size", 28)
	
	container.add_child(background)
	container.add_child(mapNameLabel)
	container.add_child(editButton)
	container.add_child(deleteButton)
	container.add_child(shareButton)
	gridContainer.add_child(container)
	
	editButton.pressed.connect(_on_edit_button_pressed.bind(editButton.get_parent().get_meta("FILE_PATH"),editButton.get_parent().get_meta("FILE_NAME") ))
	deleteButton.pressed.connect(_on_delete_button_pressed.bind(deleteButton.get_parent().get_meta("FILE_PATH")))
	#shareButton.pressed.connect()

func _on_edit_button_pressed(mapFilePath: String, mapName: String):
	SelectedMap.FILE_PATH = mapFilePath
	SelectedMap.FILE_NAME = mapName
	createNewScene.load_scene(mapFilePath)
	
func _on_delete_button_pressed(mapFilePath: String):
	pass

func _on_create_new_map_pressed():
	var inputDialog = load("res://shared/dialogs/input-dialog.tscn").instantiate()
	inputDialog.create_input_dialog("Enter map name!")
	add_child(inputDialog)
	inputDialog.input_cancelled.connect(_remove_input_dialog.bind(inputDialog))
	inputDialog.input_entered.connect(_create_new_map.bind(inputDialog))
	get_tree().paused = true

func _remove_input_dialog(dialog) -> void:
	remove_child(dialog)
	get_tree().paused = false
	
func _create_new_map(mapName: String, dialog)->void:
	if mapNames.has(mapName):
		dialog.error_message("Map name is already used.")
	else:
		get_tree().paused = false
		createNewScene.create_new_scene(mapName)
	
	
	#createNewScene.create_new_scene()
