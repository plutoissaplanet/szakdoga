extends Node2D


var random = RandomNumberGenerator.new()
var containerBackground = load("res://Game Assets/GUI/backdrop3.png")
var font = preload("res://Game Assets/Font/CraftPixNet Survival Kit.otf")
var downloadTexture = preload("res://Game Assets/MapEditor/Icons/download.png")
var checkmark = preload("res://Game Assets/MapEditor/Icons/checked.png")
var playTexture = preload("res://Game Assets/MapEditor/Icons/play.png")
var deleteTexture = preload("res://Game Assets/MapEditor/Icons/Icons_03.png")
var mapDatas

func _ready():
	var parallax = PARALLAX.new()
	add_child(parallax)
	_get_maps_from_database()
	_create_public_map_containers()

	$"CanvasLayer/TabContainer/Public maps/ScrollContainer/GridContainer".add_theme_constant_override("v_separation", 40)
	$"CanvasLayer/TabContainer/Downloaded maps/ScrollContainer/GridContainer".add_theme_constant_override("v_separation", 40)

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


func _get_maps_from_database():
	var query: FirestoreQuery = FirestoreQuery.new()
	query.from("maps")
	var results = await Firebase.Firestore.query(query)
	
	return results
	
func _create_public_map_containers():
	mapDatas = await _get_maps_from_database()
	
	for maps in mapDatas:
		if maps.document.get("user").get("stringValue") == UserData.username:
			mapDatas.erase(maps)
			
	for map in mapDatas:
		var container = Container.new()
		container.size = Vector2(420, 30)
		container.set_meta("MAP_NAME", map)
		var background = TextureRect.new()
		background.size = container.size
		background.texture = containerBackground
		background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		background.stretch_mode = TextureRect.STRETCH_SCALE
		
		var mapNameLabel = Label.new()
		mapNameLabel.text = map.doc_name
		mapNameLabel.add_theme_color_override("font_color", Color("#3d253b"))
		mapNameLabel.add_theme_font_override("font", font)
		mapNameLabel.add_theme_font_size_override("font_size", 28)
		
		var downloadButton = TextureButton.new()
		downloadButton.texture_normal = downloadTexture
		downloadButton.stretch_mode = TextureButton.STRETCH_SCALE
		downloadButton.ignore_texture_size = true
		downloadButton.size = Vector2(24, 24)
		downloadButton.position = Vector2(390, 3)
		downloadButton.name = 'DownloadButton'
		downloadButton.pressed.connect(_download_map.bind(map.doc_name, map.document.get("mapData"), container ,downloadButton))
	
	
		container.add_child(background)
		container.add_child(mapNameLabel)
		container.add_child(downloadButton)
		$"CanvasLayer/TabContainer/Public maps/ScrollContainer/GridContainer".add_child(container)
		

func _download_map(mapName: String, data, cont, downloadButton: TextureButton):
	var jsonFormat = {
			"enemy": {},
			"items": {},
			"minigames": {},
			"keys": {},
			"tiles": {},
			"rooms": {},
			"difficulty": null,
			"creation_date": null,
			"already_generated": '0',
			"doors": {}
		}
	print(data)
	var asd = JSON.parse_string((data.get("stringValue"))).get("map_data")
	jsonFormat["notOwnMap"] = true
	print("jsonFormat: ", jsonFormat)
	for field in asd.keys():
		if field == "difficulty":
			jsonFormat[field] = str(asd.get(field).get("stringValue"))
		else:
			jsonFormat[field] = JSON.parse_string(asd.get(field).get("stringValue"))
			
		
		
	print(jsonFormat)
	
	downloadButton.texture_normal = checkmark
	createNewScene.create_public_map(mapName, jsonFormat)

	

func _load_downloaded_maps():
	var downloadedMapNames = []
	for file in FileLoader.get_directory_filenames(UserData.userFolderPath + "/DownloadedMaps/"):
		if file.ends_with(".tscn"):
			downloadedMapNames.append(file.get_basename())
	for map in downloadedMapNames:
		var container = Container.new()
		container.size = Vector2(420, 30)
		var background = TextureRect.new()
		background.size = container.size
		background.texture = containerBackground
		background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		background.stretch_mode = TextureRect.STRETCH_SCALE
		
		var mapNameLabel = Label.new()
		mapNameLabel.text = map
		mapNameLabel.add_theme_color_override("font_color", Color("#3d253b"))
		mapNameLabel.add_theme_font_override("font", font)
		mapNameLabel.add_theme_font_size_override("font_size", 28)
		
		var playButton = TextureButton.new()
		playButton.texture_normal = playTexture
		playButton.pressed.connect(_on_play_clicked.bind(map))
		playButton.stretch_mode = TextureButton.STRETCH_SCALE
		playButton.ignore_texture_size = true
		playButton.size = Vector2(24, 24)
		playButton.position = Vector2(360, 3)
		
		var deleteButton = TextureButton.new()
		deleteButton.texture_normal = deleteTexture
		deleteButton.pressed.connect(_on_delete_map.bind(map, container))
		deleteButton.stretch_mode = TextureButton.STRETCH_SCALE
		deleteButton.ignore_texture_size = true
		deleteButton.size = Vector2(24, 24)
		deleteButton.position = Vector2(390, 3)
		
		container.add_child(background)
		container.add_child(playButton)
		container.add_child(deleteButton)
		container.add_child(mapNameLabel)
		$"CanvasLayer/TabContainer/Downloaded maps/ScrollContainer/GridContainer".add_child(container)
	

func _on_play_clicked(mapName):
	var mapPath = UserData.userFolderPath + "/DownloadedMaps/" + mapName + ".tscn"
	get_tree().change_scene_to_file(mapPath)
	
func _on_delete_map(mapName, container):
	var mapPath = UserData.userFolderPath + "/DownloadedMaps/" + mapName + ".tscn"
	var jsonPath = UserData.userFolderPath + "/DownloadedMaps/" + mapName + ".json"
	var dir = DirAccess.open(mapPath.get_base_dir())
	if dir:
		dir.remove(mapPath)
		dir.remove(jsonPath)
		$"CanvasLayer/TabContainer/Downloaded maps/ScrollContainer/GridContainer".remove_child(container)


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_tab_container_tab_selected(tab):
	if tab == 1:
		mapDatas = await _get_maps_from_database()
	elif tab == 2:
		for child in $"CanvasLayer/TabContainer/Downloaded maps/ScrollContainer/GridContainer".get_children():
			$"CanvasLayer/TabContainer/Downloaded maps/ScrollContainer/GridContainer".remove_child(child)
		_load_downloaded_maps()
