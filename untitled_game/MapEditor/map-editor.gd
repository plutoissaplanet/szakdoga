extends Node2D

var screenWidth: float
var screenHeight: float
var decorationEditor
var currentLayer: int #The current layer the user is "painting on"
var selectedTileId: int #The tile currently selected and ready to be placed (source_id)
var selectedTileName: String #The name of the current tile, like "LIGHT_FLOOR"
var selectedTilesAtlasCoord: Dictionary
var tiles: Dictionary
var tileEditorMode: String #Modes include: deleting, placing, placing in rectangle
var sourceIDString: String
var mapName: String
var atlasCoordsString: String
var previousTileMaps: Array
var selectedRoom: int = 1


var tileMap: TileMap
var floorTileMap: TileMap
var wallTileMap: TileMap

const roomSizeMetaKey = "ROOM_SIZE_NUMBER_"


#TODO
# add the editor nodes needed for editing
# load every item
# save button

func _ready():
	decorationEditor = preload("res://MapEditor/EditorModes/decorator-mode.tscn").instantiate()
	_add_editor_nodes_to_map()
	screenWidth = get_viewport_rect().size.x
	screenHeight = get_viewport_rect().size.y
	var size = get_viewport_rect().size
	
	if get_meta_list().size() == 0: #Check if the room has any meta, if not, set it 
		_set_map_information()

	
	if get_meta_list().has("NUMBER_OF_ROOMS"): #If the room has the number of rooms meta, initialize the number of rooms in the editor, so that the correct number of buttons show at the beginning of editing
		decorationEditor.set_number_of_rooms(get_meta("NUMBER_OF_ROOMS"))
	
	if get_children().size() > 1: #If the loaded tscn file already has children, and the children are TileMap's initialize the editor's tilemaps with the tscn's saved tilemaps
		for child in get_children():
			if child is TileMap:
				child.visible
				var duplicate = child.duplicate()
				previousTileMaps.append(child.duplicate())
				remove_child(child)
				child.queue_free()
				for editorChild in decorationEditor.get_children():
					if editorChild is TileMap and editorChild.name == duplicate.name:
						decorationEditor.remove_child(editorChild)
						editorChild.queue_free()
						decorationEditor.add_child(duplicate)
						if editorChild.name == "FloorTileMap":
							decorationEditor.floorTileMap = duplicate
							floorTileMap = decorationEditor.floorTileMap
						else:
							decorationEditor.wallTileMap = duplicate
							wallTileMap = decorationEditor.wallTileMap
	else:
		floorTileMap = decorationEditor.floorTileMap
		wallTileMap = decorationEditor.wallTileMap
		
	print(get_children())
	tiles = decorationEditor.tiles
	sourceIDString = decorationEditor.sourceID
	atlasCoordsString = decorationEditor.atlasCoords
	
	tileEditorMode = "Place"
	currentLayer = 0
	
	decorationEditor.editor_mode_changed.connect(_editor_mode_changed)
	decorationEditor.mouse_in_floor_area.connect(_input_event_on_floor_area_collision)
	decorationEditor.mouse_in_wall_area.connect(_input_event_on_wall_area_collision)
	decorationEditor.layer_changed.connect(_layer_changed)
	decorationEditor.tile_to_place_changed.connect(_tile_to_place_changed)
	decorationEditor.save_button_pressed.connect(_map_is_ready_to_save)
	decorationEditor.discard_button_pressed.connect(_discard_button_pressed)
	decorationEditor.room_number_changed.connect(_room_number_changed)
	decorationEditor.difficulty_selected.connect(_set_difficulty)
	decorationEditor.set_difficulty.connect(_set_difficulty_if_not_set)
	decorationEditor.selected_room_changed.connect(_selected_room_changed)
	decorationEditor.room_size_set.connect(_room_size_set)

	
	_check_room_sizes()
	_set_difficulty_if_not_set()
	

func _set_map_information():
	set_meta("MAP_NAME", '')
	set_meta("MAP_DIFFICULTY", '')
	set_meta("NUMBER_OF_ROOMS", 1)
	set_meta("CREATION_DATE", Time.get_datetime_dict_from_system())

func _input_event_on_floor_area_collision(event: InputEvent): #for when the player wants to either place or delete a tile
	if event.is_action_pressed("room_changer_click") and selectedTileName and (currentLayer == 0 or currentLayer == 2):
		_editing_logic(floorTileMap)

func _input_event_on_wall_area_collision(event: InputEvent): #if the player wants to place a wall
	if event.is_action_pressed("room_changer_click") and selectedTileName and currentLayer == 1:
		_editing_logic(wallTileMap)
		
func _editing_logic(currentTileMap: TileMap):
	var worldPosition = currentTileMap.get_global_mouse_position()
	match tileEditorMode:
		"Delete":
			_delete_tile(worldPosition, currentTileMap)
		"Place":
			_place_tile(selectedTileId, worldPosition, currentTileMap)
		"Rectangle":
			pass

func _place_tile(tileToPlace: int, pos: Vector2i, currentTileMap: TileMap) -> void:
	if currentLayer == 1:
		pos = pos - Vector2i(234, 122)
	else:
		pos = pos -Vector2i(234, 186)
	var localizedPosition = currentTileMap.local_to_map(pos)
	var sourceID = tiles.get(currentLayer).get(selectedTileName).get(sourceIDString)
	var atlasCoordinatesOfSelectedTile = tiles.get(currentLayer).get(selectedTileName).get(atlasCoordsString)
	currentTileMap.set_cell(currentLayer, localizedPosition, sourceID, atlasCoordinatesOfSelectedTile)


func _delete_tile(pos: Vector2i, currentTileMap: TileMap) -> void:
	if currentLayer == 1:
		pos = pos - Vector2i(234, 122)
	else:
		pos = pos - Vector2i(234, 186)
	var localizedPosition = currentTileMap.local_to_map(pos)
	currentTileMap.set_cell(currentLayer, localizedPosition)

func _editor_mode_changed(newMode: String) -> void:
	tileEditorMode = newMode

func _layer_changed(layer: int):
	currentLayer = layer
	selectedTileName = ""

func _tile_to_place_changed(tile: String, sourceId: int): #for when another tile is selected
	selectedTileName = tile
	selectedTileId = tiles.get(currentLayer).get(selectedTileName).get(sourceIDString)
	
func _add_editor_nodes_to_map():
	add_child(decorationEditor)
	
func _map_is_ready_to_save(): #Takes out the editor node, and makes the tileMaps the tscn's children
	var rootNode = get_tree().current_scene

	remove_child(decorationEditor)
	floorTileMap = decorationEditor.floorTileMap.duplicate()
	wallTileMap = decorationEditor.wallTileMap.duplicate()
	
	rootNode.add_child(floorTileMap)
	floorTileMap.set_owner(rootNode)
	
	rootNode.add_child(wallTileMap)
	wallTileMap.set_owner(rootNode)

	createNewScene.map_on_save_button_pressed(rootNode)
	
func _discard_button_pressed():
	get_tree().reload_current_scene()
	
func _room_number_changed(number: int): #if a new room was added or removed, set the new meta data
	set_meta("NUMBER_OF_ROOMS", number)
	
func _set_difficulty(difficulty) -> void:
	set_meta("MAP_DIFFICULTY", difficulty)

func _set_difficulty_if_not_set() -> void:
	if not get_meta_list().has("MAP_DIFFICULTY") or not get_meta("MAP_DIFFICULTY"):
		decorationEditor.open_difficulty_dialog()
	
func _selected_room_changed(number: int):
	selectedRoom = number
	
func _room_size_set(size: String):
	set_meta(roomSizeMetaKey + str(selectedRoom), size)
	decorationEditor.is_room_size_set.emit(selectedRoom, size)
	
func _check_room_sizes():
	for meta in get_meta_list():
		if meta.begins_with(roomSizeMetaKey):
			decorationEditor.is_room_size_set.emit(int(meta.get_slice("_", 3)), get_meta(meta))


