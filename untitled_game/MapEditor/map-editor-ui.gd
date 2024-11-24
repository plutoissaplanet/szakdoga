extends Node2D

var loadedPrivatedMaps = {}
var containerHeight = 40
var containerWidth
var privateScrollContainer: ScrollContainer
var privateGridContainer: GridContainer
var publicScrollContainer: ScrollContainer
var publicGridContainer: GridContainer
var editorMapDirectory = "res://PlayerMaps/EditorMaps/"
var publicMapdirectory = "res://PlayerMaps/PlayableMaps/"
var editorMapNames = []
var publicMapNames = []

var EDITED_MAP_DATA

var editButtonTexture = preload("res://Game Assets/MapEditor/Icons/pencil.png")
var deleteButtonTexture = preload("res://Game Assets/MapEditor/Icons/Icons_03.png")
var shareButtonTexture = preload("res://Game Assets/MapEditor/Icons/Icons_51.png")
var startButtonTexture = preload("res://Game Assets/MapEditor/Icons/play.png")
var unshareButtonTexture = preload("res://Game Assets/MapEditor/Icons/Icons_37.png")
var containerBackground = preload("res://Game Assets/GUI/backdrop3.png")
var font = preload("res://Game Assets/Font/CraftPixNet Survival Kit.otf")


func _ready():
	privateGridContainer = $"CanvasLayer/TabContainer/Privated Rooms/ScrollContainer/GridContainer"
	privateScrollContainer =$"CanvasLayer/TabContainer/Privated Rooms/ScrollContainer"
	publicGridContainer = $"CanvasLayer/TabContainer/Public rooms/ScrollContainer/GridContainer"
	publicScrollContainer = $"CanvasLayer/TabContainer/Public rooms/ScrollContainer"
	containerWidth = privateScrollContainer.size.x
	get_tree().paused = false
	_load_all_map_names()
	_load_public_map_names()
	add_parallax()
	
	var file = JSON_FILE_FUNCTIONS.load_json_file("res://PlayerMaps/edited-maps.json")
	EDITED_MAP_DATA = JSON.parse_string(file.get_as_text())


func _load_all_map_names():
	for file in FileLoader.get_directory_filenames(editorMapDirectory):
		if file.ends_with(".tscn"):
			editorMapNames.append(file.get_basename())
	for map in editorMapNames:
		_make_private_map_container(map, editorMapDirectory+map+".tscn")


func _load_public_map_names():
	for file in FileLoader.get_directory_filenames(publicMapdirectory):
		if file.ends_with(".tscn"):
			publicMapNames.append(file.get_basename())
	for map in publicMapNames:
		_make_public_map_container(map, publicMapdirectory+map+".tscn")


func _make_private_map_container(mapName: String, filePath: String):
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
	privateGridContainer.add_child(container)
	
	editButton.pressed.connect(_on_edit_button_pressed.bind(filePath,mapName))
	deleteButton.pressed.connect(_on_delete_button_pressed.bind(mapName,filePath, container))
	shareButton.pressed.connect(_on_share_map.bind(mapName, filePath, container))


func _make_public_map_container(mapName: String, filePath: String):
	var container = Container.new()
	container.size = Vector2(containerWidth, containerHeight)
	container.set_meta("FILE_PATH", filePath)
	container.set_meta("FILE_NAME", mapName)

	var background = TextureRect.new()
	background.size = Vector2(containerWidth, containerHeight-4)
	background.texture = containerBackground
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_SCALE
	
	var unshareButton = TextureButton.new()
	var startButton = TextureButton.new()
	
	unshareButton.ignore_texture_size = true
	startButton.ignore_texture_size = true
	
	unshareButton.stretch_mode = TextureButton.STRETCH_SCALE
	startButton.stretch_mode = TextureButton.STRETCH_SCALE

	unshareButton.texture_normal = unshareButtonTexture
	startButton.texture_normal = startButtonTexture
	
	unshareButton.size = Vector2(24, 24)
	startButton.size = Vector2(24, 24)
	
	unshareButton.position = Vector2(containerWidth-70, 6)
	startButton.position = Vector2(containerWidth-110,6)
	
	var mapNameLabel = Label.new()

	mapNameLabel.text = mapName
	mapNameLabel.add_theme_color_override("font_color", Color("#3d253b"))
	mapNameLabel.add_theme_font_override("font", font)
	mapNameLabel.add_theme_font_size_override("font_size", 28)
	
	container.add_child(background)
	container.add_child(mapNameLabel)
	container.add_child(unshareButton)
	container.add_child(startButton)
	publicGridContainer.add_child(container)
	
	unshareButton.pressed.connect(_on_unshare_map_button_pressed.bind(mapName, filePath, container))
	startButton.pressed.connect(_on_start_map_button_pressed.bind(mapName, filePath))


func _on_edit_button_pressed(mapFilePath: String, mapName: String):
	SelectedMap.FILE_PATH = mapFilePath
	SelectedMap.FILE_NAME = mapName
	var mapInstance = load(mapFilePath).instantiate()
	
	if mapInstance.get_script() != null:
		mapInstance.set_script(load("res://MapEditor/map-editor.gd"))
		get_tree().root.add_child(mapInstance)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = mapInstance
	else:
		createNewScene.load_scene(mapFilePath)


func _on_start_map_button_pressed(mapName: String, filePath: String):
	var playableMapScript = load("res://MapEditor/MapParser/playable_map.gd")
	await createNewScene.save_map(load(filePath).instantiate(), filePath, playableMapScript)
	get_tree().change_scene_to_file(filePath)


func _on_unshare_map_button_pressed(mapName: String, filePath: String, container: Container):
	var publishedDir = "res://PlayerMaps/PlayableMaps/"
	var editorDir = "res://PlayerMaps/EditorMaps/"
	
	var sourceDir = DirAccess.open(filePath.get_base_dir())
	var targetDir = editorDir + mapName + ".tscn"
	
	var jsonSourceDirPath = publishedDir + mapName + ".json"
	var jsonTargetDirPath = editorDir + mapName + ".json"
	
	if sourceDir.file_exists(filePath):
		sourceDir.rename(filePath, targetDir)

	if sourceDir.file_exists(jsonSourceDirPath):
		sourceDir.rename(jsonSourceDirPath, jsonTargetDirPath)
		var firestoreCollection : FirestoreCollection = Firebase.Firestore.collection("maps")
		var document: FirestoreDocument = await firestoreCollection.get_doc(mapName)
		await firestoreCollection.delete(document)
		$"CanvasLayer/TabContainer/Public rooms/ScrollContainer/GridContainer".remove_child(container)
	
	


func _on_delete_button_pressed(mapName: String, filePath: String, container: Container):
	var dialog = load("res://shared/dialogs/confirmation-dialog.tscn").instantiate()
	
	dialog.set_label_text("Delete map? This action is not reversable.")
	add_child(dialog)
	dialog.ok_button_pressed.connect(_confirm_delete_map.bind(mapName, filePath, container, dialog))
	dialog.confirmation_cancelled.connect(_abort_deletion.bind(dialog))


func _abort_deletion(dialog):
	remove_child(dialog)
	dialog.queue_free()
	
	
func _confirm_delete_map(mapName: String, filePath: String, container: Container, dialog):
	var dir = DirAccess.open(filePath.get_base_dir())
	if dir:
		dir.remove(filePath)
		if dir.file_exists(mapName +".json"):
			dir.remove(mapName +".json")
		privateGridContainer.remove_child(container)
		remove_child(container)
		

func _on_share_map(mapName: String, filePath: String, container: Container):
	var editorDir = "res://PlayerMaps/EditorMaps/"
	if EDITED_MAP_DATA.get(editorDir+mapName+".tscn"):
		var dialog = load("res://shared/dialogs/confirmation-dialog.tscn").instantiate()
		dialog.set_label_text("Share map with others?")
		add_child(dialog)
		dialog.ok_button_pressed.connect(_confirm_share_map.bind(dialog, mapName, filePath, container))
		dialog.confirmation_cancelled.connect(_abort_share.bind(dialog))


func _confirm_share_map(dialog, mapName, filePath: String, container):
	privateGridContainer.remove_child(container)
	
	var publishedDir = "res://PlayerMaps/PlayableMaps/"
	var editorDir = "res://PlayerMaps/EditorMaps/"
	
	var sourceDir = DirAccess.open(filePath.get_base_dir())
	var targetDir = publishedDir + mapName + ".tscn"
	
	var jsonSourceDirPath = editorDir + mapName + ".json"
	var jsonTargetDirPath = publishedDir + mapName + ".json"
	
	if sourceDir.file_exists(filePath):
		sourceDir.rename(filePath, targetDir)

	if sourceDir.file_exists(jsonSourceDirPath):
		sourceDir.rename(jsonSourceDirPath, jsonTargetDirPath)
		remove_child(dialog)
		dialog.queue_free()
		var file = FileAccess.open(jsonTargetDirPath, FileAccess.READ)
		if file:
			var json_data = file.get_as_text()
			file.close()
			
			var json = JSON.parse_string(json_data)
			
			var firestore_data = {"map_data": {}}
			for key in json.keys():
				firestore_data["map_data"][key] = {}
				firestore_data["map_data"][key] = {"stringValue": str(json.get(key))}
			
			print(mapName)
			print(firestore_data)
			await Firebase.Firestore.collection("maps").add(mapName,{"mapData": str(firestore_data), "user": UserData.username})
			
func _abort_share(dialog):
	remove_child(dialog)
	dialog.queue_free()

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
	if editorMapNames.has(editorMapNames) || publicMapNames.has(editorMapNames):
		dialog.error_message("Map name is already used.")
	else:
		get_tree().paused = false
		createNewScene.create_new_scene(mapName)
	
	
	#createNewScene.create_new_scene()



func _reload_maps(private: bool):
	if private:
		editorMapNames.clear()
		for child in privateGridContainer.get_children():
			privateGridContainer.remove_child(child)
		_load_all_map_names()
	else:
		publicMapNames.clear()
		for child in publicGridContainer.get_children():
			publicGridContainer.remove_child(child)
		_load_public_map_names()


func _on_tab_container_tab_selected(tab):
	if tab == 0:
		_reload_maps(true)
	else:
		_reload_maps(false)


func add_parallax():
	var parallax = PARALLAX.new()
	add_child(parallax)


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
