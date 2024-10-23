extends Node2D


const flooringTilesID = [0, 1] #The possible tile cell ID's
const sourceID = "sourceID"
const atlasCoords = "atlasCoords"
const type = "type"
const windowSize = Vector2i(1152,648)
const tileSize = Vector2i(32,32)
const chosenSizeLabelPosition = Vector2i(453, 512)
const floorGridPositionOffset = Vector2i(234, 186)
const wallGridPositionOffset = Vector2i(234, 122)

const possibleLayerIDs = { #The possible layers
	0: "Floors",
	1: "Walls",
	2: "Decor"
}

const tiles = { #the tiles in a dictionary. The main keys are the layer id's, the next ones are the name of each tile (string) and their sourceID's (int) and  atlas coords (Vector2i)
	0: { # the layer
		TileNames.PANEL_FLOOR: {
			sourceID: 0,
			atlasCoords: Vector2i(0,0),
		},
		TileNames.DARK_PANEL_FLOOR: {
			sourceID: 0,
			atlasCoords: Vector2i(4,0)
		},
		TileNames.STONE_FLOOR: {
			sourceID: 0,
			atlasCoords: Vector2i(9,0)
		},
		TileNames.LIGHT_FLOOR: {
			sourceID: 0,
			atlasCoords: Vector2i(13,0)
		}
	},
	
	1: { #the layer
		TileNames.DARK_GREEN_WALL: {
			sourceID: 1,
			atlasCoords: Vector2i(0,0)
		},
		TileNames.DARK_RED_PANEL_WALL: {
			sourceID: 1,
			atlasCoords: Vector2i(1,0)
		},
		TileNames.DARK_RED_WALL: {
			sourceID: 1,
			atlasCoords: Vector2i(2,0)
		},
		TileNames.ORANGE_TILE_WALL: {
			sourceID: 1,
			atlasCoords: Vector2i(3,0)
		},
		TileNames.LIGHT_GREEN_WALL: {
			sourceID: 1,
			atlasCoords: Vector2i(4,0)
		},
		TileNames.ORANGE_PANEL_WALL: {
			sourceID: 1,
			atlasCoords: Vector2i(5,0)
		},
		TileNames.CREAM_WALL: {
			sourceID: 1,
			atlasCoords: Vector2i(6,0)
		}
	},
	
	2: {
		TileNames.CHAIR_OAK_FRONT: {
			sourceID: 1,
			atlasCoords: Vector2i(8,0)
		},
		TileNames.CHAIR_OAK_SIDE: {
			sourceID: 1,
			atlasCoords: Vector2i(9,0)
		},
		TileNames.CHAIR_WHITE_BACK: {
			sourceID: 1,
			atlasCoords: Vector2i(7,0)
		},
		TileNames.CHAIR_WHITE_FRONT: {
			sourceID: 1,
			atlasCoords: Vector2i(5,0)
		},
		TileNames.CHAIR_WHITE_SIDE: {
			sourceID: 1,
			atlasCoords: Vector2i(6,0)
		},
		TileNames.COFFEE_TABLE_ORANGE: {
			sourceID: 1,
			atlasCoords: Vector2i(0,0)
		},
		TileNames.COFFEE_TABLE_ORANGE_SIDE: {
			sourceID: 1,
			atlasCoords: Vector2i(2,0)
		},
		TileNames.COFFEE_TABLE_PINE: {
			sourceID: 1,
			atlasCoords: Vector2i(3,0)
		},
		TileNames.COFFEE_TABLE_PINE_SIDE: {
			sourceID: 1,
			atlasCoords: Vector2i(4,0)
		},
		TileNames.RUG_BIG: {
			sourceID: 1,
			atlasCoords: Vector2i(10,2)
		},
		TileNames.RUG_ROUND: {
			sourceID: 1,
			atlasCoords: Vector2i(8,3)
		},
		TileNames.RUG_SMALL: {
			sourceID: 1,
			atlasCoords: Vector2i(8,2)
		},
		TileNames.RUG_SMALL_SIDE: {
			sourceID: 1,
			atlasCoords: Vector2i(7,2)
		},
		TileNames.SMALL_ROUND_CHAIR: {
			sourceID: 1,
			atlasCoords: Vector2i(12, 0)
		},
		TileNames.TABLE_ROTUND_ORANGE: {
			sourceID: 1,
			atlasCoords: Vector2i(11, 0)
		},
		
	}
}


const roomPositions = {
	1: Vector2i(0,0),
	2: Vector2i(1152, 0),
	3: Vector2i(2304, 0),
	4: Vector2i(3456, 0),
	5: Vector2i(4608, 0),
	6: Vector2i(5760, 0)
}

const floorGridPositions = {
	1: Vector2i(234,186),
	2: Vector2i(1386, 186),
	3: Vector2i(2538, 186),
	4: Vector2i(3690, 186),
	5: Vector2i(4842, 186),
	6: Vector2i(5994, 186)
}

const wallGridPositions  = {
	1: Vector2i(234,122),
	2: Vector2i(1386, 122),
	3: Vector2i(2538, 122),
	4: Vector2i(3690, 122),
	5: Vector2i(4842, 122),
	6: Vector2i(5994, 122)
}


var currentLayer: int #The current layer the user is "painting on"
var selectedTile: int #The tile currently selected and ready to be placed
var roomNumber: int = 1
var selectedRoomNumber: int = 1
var wallButtonsAdded = false
var decorButtonsAdded = false
var loadedFloors = {}
var loadedWalls = {}
var loadedDecor = {}
var buttonsAndTheirTextures = {}
var floorArea: Area2D
var wallArea: Area2D
var roomSize: Vector2i
var roomSizeString: String = "small"
var floorGridSizes: Vector2i
var wallGridSizes: Vector2i
var roomsWithSetSizes: Dictionary = {}

signal editor_mode_changed(mode: String) #For the editor type (eg. radír, or rectangular tile placement, or singular)
signal layer_changed(layer: int) #For when a new tab in the decorator tab is selected, it emits the new layer we are on, it emits an integer
signal mouse_in_floor_area(event: InputEvent) #For when the user has entered the area where they can actually edit the map
signal mouse_in_wall_area(event: InputEvent) # For when the user has entered the wall area where they can put down walls
signal tile_to_place_changed(tile: String, sourceID: int) #For when the player chose a new texture by clicking on a button
signal save_button_pressed() # For when the player wants to save the map and they pressed the right buttons
signal discard_button_pressed()
signal room_number_changed(number: int)
signal difficulty_selected(difficulty: String)
signal set_difficulty()
signal room_size_set(roomSizeInString: String)
signal selected_room_changed(roomNumber: int)
signal is_room_size_set(roomNumber: int, roomSizeString: String)
signal disable_size_selection(sizeString: String)
signal set_room_size_at_beginning_of_editing(room: int, sizeString: String)

var floorTileMap: TileMap
var wallTileMap: TileMap



func _ready():
	floorTileMap = get_node("FloorTileMap")
	wallTileMap = get_node("WallTileMap")
	floorArea = get_node("Control/Area2D")
	wallArea = get_node("Control/WallAreaDetector")
	
	roomSize = REQUIREMENTS.room_sizes.get("small")
	
	$Control/Rooms/GridContainer/Room1.pressed.connect(_on_room_button_pressed.bind($Control/Rooms/GridContainer/Room1.get_meta("ROOM_NUMBER")))
	is_room_size_set.connect(_is_room_size_set)
	disable_size_selection.connect(_disable_size_button)
	
	loadedFloors = _load_textures(0)
	if loadedFloors.size() != 0:
		_add_texture_buttons_to_grid(loadedFloors, $Control/DecoratorSelection/DecorationTabContainer/Floors/ScrollContainer/GridContainer)
	_add_size_options_to_options_button()


func open_difficulty_dialog()-> void:
	var inputDialog = load("res://shared/dialogs/input-dialog.tscn").instantiate()
	inputDialog.create_input_dialog("Difficulty level")
	inputDialog.error_message("You won't be able to change this later!")
	inputDialog._open_selection_input_dialog(REQUIREMENTS.difficulty.keys())
	inputDialog.input_entered.connect(_difficulty_selected.bind(inputDialog))
	add_child(inputDialog)

func _difficulty_selected(difficulty, dialog) -> void:
	remove_child(dialog)
	dialog.queue_free()
	difficulty_selected.emit(difficulty)
	
func set_number_of_rooms(number: int):
	roomNumber = number
	if roomNumber != 1:
		for num in range(roomNumber-1):
			_create_new_room(num+2)
	
func _add_floor_grid(sizing: String):
	var grid = GridContainer.new()
	var size = REQUIREMENTS.room_sizes.get(sizing)
	var numberOfColumns = size.x
	var numberOfRows = size.y
	var styleboxTexture = StyleBoxTexture.new()
	styleboxTexture.texture = load("res://Game Assets/MapEditor/grid_floor.png")
	grid.size = size * tileSize
	grid.columns = numberOfColumns
	grid.position = roomPositions.get(selectedRoomNumber) + floorGridPositionOffset
	print(grid.position)
	grid.add_theme_constant_override("h_separation", 0)
	grid.add_theme_constant_override("v_separation", 0)
	grid.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(grid)
	
	for i in range(0, numberOfRows*numberOfColumns):
		var newPanel = Panel.new()
		newPanel.custom_minimum_size = tileSize
		newPanel.add_theme_stylebox_override("panel", styleboxTexture)
		newPanel.mouse_filter = Control.MOUSE_FILTER_PASS
		grid.add_child(newPanel)

		
func _add_wall_grid(sizing: String):
	var grid = GridContainer.new()
	var styleboxTexture = StyleBoxTexture.new()
	var size = REQUIREMENTS.room_sizes.get(sizing)
	styleboxTexture.texture = load("res://Game Assets/MapEditor/grid_wall.png")
	floorGridSizes = Vector2i(640, 288)
	var numberOfColumns = size.x
	grid.columns = numberOfColumns
	grid.size.x = size.x * tileSize.x
	grid.size.y = tileSize.y * 2
	grid.position = roomPositions.get(selectedRoomNumber) + wallGridPositionOffset
	add_child(grid)
	grid.add_theme_constant_override("h_separation", 0)
	grid.add_theme_constant_override("v_separation", 0)
	grid.mouse_filter = Control.MOUSE_FILTER_PASS
	for i in range(numberOfColumns):
		var newPanel = Panel.new()
		newPanel.custom_minimum_size = tileSize
		newPanel.custom_minimum_size.y = tileSize.y * 2
		newPanel.add_theme_stylebox_override("panel", styleboxTexture)
		newPanel.mouse_filter = Control.MOUSE_FILTER_PASS
		grid.add_child(newPanel)

func _add_boundary_to_map(sizeString: String) -> void: #THIS TILEMAP WILL HAVE TO BE SAVED TO THE .TSCN TOO!!!!!!!
	pass
	var size = REQUIREMENTS.room_sizes.get(sizeString)
	var boundaryTileMap: TileMap = $MapBoundary
	var localizeMapToTileMapPosition = boundaryTileMap.local_to_map(roomPositions.get(selectedRoomNumber)) 
	const boundarySourceID = 2
	print(boundaryTileMap.tile_set.get_source_id(0))
	const boundaryAtlasCoords = Vector2i(0, 0)
	
	for i in range(size.y):
		boundaryTileMap.set_cell(0, Vector2i(-1, i) + localizeMapToTileMapPosition, boundarySourceID, Vector2i(0,0), 1)
		boundaryTileMap.set_cell(0, Vector2i(size.x, i) + localizeMapToTileMapPosition, boundarySourceID, Vector2i(0,0), 2)
	
	for i in range(size.x):
		boundaryTileMap.set_cell(0, Vector2i(i, size.y) + localizeMapToTileMapPosition, boundarySourceID, Vector2i(0,0), 3)
	
func _on_floor_area_detector_input_event(viewport, event, shape_idx):
	mouse_in_floor_area.emit(event)
	
func _on_wall_area_detector_input_event(viewport, event, shape_idx):
	mouse_in_wall_area.emit(event)

func _on_tab_changed(tab): #on the tab's change the current layer changes too
	layer_changed.emit(tab)
	currentLayer = tab
	if tab == 1 :
		if loadedWalls.size() == 0:
			loadedWalls = _load_textures(currentLayer)
			_add_texture_buttons_to_grid(loadedWalls, $Control/DecoratorSelection/DecorationTabContainer/Walls/ScrollContainer/GridContainer)
	elif tab == 2:
		if loadedDecor.size() == 0:
			loadedDecor = _load_textures(currentLayer)
			_add_texture_buttons_to_grid(loadedDecor, $Control/DecoratorSelection/DecorationTabContainer/Decor/ScrollContainer/GridContainer)


func _load_textures(layer: int): # For adding the different elements to the grid containers
	var filePath = "res://Game Assets/MapEditor/" + possibleLayerIDs.get(layer)
	var dictionary = FileLoader.load_assets_1_level_deep(filePath, ".png")
	return dictionary

func _add_texture_buttons_to_grid(textures: Dictionary, grid: GridContainer) -> void:
	for key in textures.keys():
		var textureButton = TextureButton.new();
		textureButton.texture_normal = textures.get(key);
		textureButton.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		textureButton.stretch_mode = TextureButton.STRETCH_SCALE
		textureButton.ignore_texture_size = true
		textureButton.custom_minimum_size = Vector2(58, 58)
		textureButton.pressed.connect(_on_texture_button_pressed.bind(textureButton));
		buttonsAndTheirTextures[textureButton] = key;
		grid.add_child(textureButton)

func _on_texture_button_pressed(button: TextureButton):
	var textureName = buttonsAndTheirTextures.get(button)
	var sourceId = tiles.get(currentLayer).get(textureName).get(sourceID)
	tile_to_place_changed.emit(textureName, sourceId)

func _on_draw_button_pressed(): #The tile placement is the standard placement
	editor_mode_changed.emit("Place")

func _on_rectangle_draw_button_pressed(): # The tile placement is rectangle placement
	editor_mode_changed.emit("Rectangle")

func _on_eraser_button_pressed(): # The tile placement is eraser
	editor_mode_changed.emit("Delete")

func _on_save_button_pressed(): # Save the map button
	save_button_pressed.emit()

func _on_discard_button_pressed(): # Discard the changes
	var confirmationDialog = load("res://shared/dialogs/confirmation-dialog.tscn").instantiate()
	confirmationDialog.set_label_text("Are you sure you want to discard the changes?")
	confirmationDialog.position=  roomPositions.get(selectedRoomNumber) + windowSize/2 - Vector2i(confirmationDialog.get_node("TileMap/Background").size)/2
	get_tree().paused= true
	add_child(confirmationDialog)
	confirmationDialog.ok_button_pressed.connect(_discard_confirmed.bind(confirmationDialog))
	confirmationDialog.confirmation_cancelled.connect(_confirmation_cancelled.bind(confirmationDialog))
	
func _discard_confirmed(dialog):
	get_tree().paused= false
	discard_button_pressed.emit()
	remove_child(dialog)
	dialog.queue_free()
	
func _confirmation_cancelled(dialog):
	get_tree().paused= false
	remove_child(dialog)
	dialog.queue_free()

func _on_decorator_mode_pressed():
	pass # Replace with function body.

func _on_enemy_mode_pressed():
	pass # Replace with function body.

func _on_logic_mode_pressed():
	pass # Replace with function body.

func _on_ok_button_pressed():
	var confirmationDialog = load("res://shared/dialogs/confirmation-dialog.tscn").instantiate()
	confirmationDialog.set_label_text("You will not be able to change this room's size later")
	confirmationDialog.position = roomPositions.get(selectedRoomNumber) + windowSize/2 - Vector2i(confirmationDialog.get_node("TileMap/Background").size)/2
	confirmationDialog.ok_button_pressed.connect(_on_size_accepted.bind(confirmationDialog))

	get_tree().paused= true
	add_child(confirmationDialog)

func _on_option_button_item_selected(index):
	var size = REQUIREMENTS.room_sizes.keys()[index]
	roomSize = REQUIREMENTS.room_sizes.get(size)
	roomSizeString = size

	
func _on_size_accepted( dialog) -> void:
	room_size_set.emit(roomSizeString)
	get_tree().paused= false
	remove_child(dialog)
	dialog.queue_free()

func _add_size_options_to_options_button() -> void:
	for key in REQUIREMENTS.room_sizes.keys():
		$Control/RoomSize/OptionButton.add_item(key, REQUIREMENTS.room_sizes.keys().find(key))

func _create_new_room(number: int):
	var roomButton = $Control/Rooms/GridContainer.get_child(0).duplicate(8)
	roomButton.get_child(0).text = "Room " + str(number)
	roomButton.set_meta("ROOM_NUMBER", number)
	roomButton.pressed.connect(_on_room_button_pressed.bind(roomButton.get_meta("ROOM_NUMBER")))
	$Control/Rooms/GridContainer.add_child(roomButton)
	
func _on_new_room_button_pressed():
	if roomNumber <= 6 :
		roomNumber += 1
		room_number_changed.emit(roomNumber)
		_create_new_room(roomNumber)
	else:
		print("you cant make any more rooms") #make an error toast

func _on_room_button_pressed(room: int):
	selectedRoomNumber = room
	if not roomsWithSetSizes.has(room):
		_able_size_button()
	$Control.position = roomPositions.get(selectedRoomNumber)
	$Camera2D.position = roomPositions.get(selectedRoomNumber)
	$Control/ChosenSize.position = chosenSizeLabelPosition + Vector2i(roomPositions.get(selectedRoomNumber))
	selected_room_changed.emit(selectedRoomNumber)
	
func _is_room_size_set(roomNumber: int, sizeString: String): #if its set then remove size button
	print("room number: ", roomNumber)
	if not roomsWithSetSizes.has(roomNumber):
		selectedRoomNumber = roomNumber
		_add_floor_grid(sizeString)
		_add_wall_grid(sizeString)
		_add_boundary_to_map(roomSizeString)
		selectedRoomNumber = 1
	roomsWithSetSizes[roomNumber] = sizeString
	disable_size_selection.emit(sizeString)
	
func _disable_size_button(sizeString: String):
	$Control/RoomSize.visible = false
	$Control/ChosenSize.text = "Room size: " + sizeString
	
func _able_size_button():
	$Control/RoomSize.visible = true




