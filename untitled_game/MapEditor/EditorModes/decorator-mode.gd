extends Node2D


const flooringTilesID = [0, 1] #The possible tile cell ID's
const sourceID = "sourceID"
const atlasCoords = "atlasCoords"
const type = "type"
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
			atlasCoords: Vector2i(8,0)
		},
		TileNames.LIGHT_FLOOR: {
			sourceID: 1,
			atlasCoords: Vector2i(10,6)
		}
	},
	
	1: { #the layer
		TileNames.DARK_GREEN_WALL: {
			sourceID: 2,
			atlasCoords: Vector2i(2,1)
		},
		TileNames.DARK_RED_PANEL_WALL: {
			sourceID: 2,
			atlasCoords: Vector2i(6, 1)
		},
		TileNames.DARK_RED_WALL: {
			sourceID: 2,
			atlasCoords: Vector2i(10, 1)
		},
		TileNames.ORANGE_TILE_WALL: {
			sourceID: 2,
			atlasCoords: Vector2i(14, 1)
		},
		TileNames.LIGHT_GREEN_WALL: {
			sourceID: 3,
			atlasCoords: Vector2i(2,1)
		},
		TileNames.ORANGE_PANEL_WALL: {
			sourceID: 3,
			atlasCoords: Vector2i(6,1)
		},
		TileNames.CREAM_WALL: {
			sourceID: 3,
			atlasCoords: Vector2i(10,1)
		}
	}
}


var currentLayer: int #The current layer the user is "painting on"
var selectedTile: int #The tile currently selected and ready to be placed
var screenWidth = DisplayServer.screen_get_size().x
var screenHeight = DisplayServer.screen_get_size().y
var wallButtonsAdded = false
var decorButtonsAdded = false
var loadedFloors = {}
var loadedWalls = {}
var loadedDecor = {}
var buttonsAndTheirTextures = {}

signal editor_mode_changed(mode: String) #For the editor type (eg. radír, or rectangular tile placement, or singular)
signal layer_changed(layer: int) #For when a new tab in the decorator tab is selected, it emits the new layer we are on, it emits an integer
signal mouse_in_floor_area(event: InputEvent) #For when the user has entered the area where they can actually edit the map
signal mouse_in_wall_area(event: InputEvent) # For when the user has entered the wall area where they can put down walls
signal tile_to_place_changed(tile: String, sourceID: int) #For when the player chose a new texture by clicking on a button

@onready var tileMap: TileMap = $TileMap

func _ready():
	loadedFloors = _load_textures(0)
	if loadedFloors.size() != 0:
		_add_texture_buttons_to_grid(loadedFloors, $DecorationTabContainer/Floors/GridContainer)
	print(loadedFloors)

func _process(delta):
	screenWidth = DisplayServer.screen_get_size().x
	screenHeight = DisplayServer.screen_get_size().y

func _on_placement_mode_button_pressed():
	editor_mode_changed.emit("Delete")

func _on_tab_changed(tab): #on the tab's change the current layer changes too
	layer_changed.emit(tab)
	currentLayer = tab
	if tab == 1 :
		if loadedWalls.size() == 0:
			loadedWalls = _load_textures(currentLayer)
			_add_texture_buttons_to_grid(loadedWalls, $DecorationTabContainer/Walls/GridContainer)
	elif tab == 2:
		if loadedDecor.size() == 0:
			loadedDecor = _load_textures(currentLayer)
			_add_texture_buttons_to_grid(loadedDecor, $DecorationTabContainer/Decor/GridContainer)

func _on_floor_area_detector_input_event(viewport, event, shape_idx):
	mouse_in_floor_area.emit(event)
	
func _on_wall_area_detector_input_event(viewport, event, shape_idx):
	mouse_in_wall_area.emit(event)

func _load_textures(layer: int): # For adding the different elements to the grid containers
	var filePath = "res://Game Assets/MapEditor/" + possibleLayerIDs.get(layer)
	var dictionary = FileLoader.load_assets_1_level_deep(filePath, ".png")
	return dictionary
	#open the files, maybe make a global file loader thingy bc i do this many many times

func _add_texture_buttons_to_grid(textures: Dictionary, grid: GridContainer) -> void:
	for key in textures.keys():
		var textureButton = TextureButton.new();
		textureButton.texture_normal = textures.get(key);
		textureButton.stretch_mode = TextureButton.STRETCH_SCALE
		textureButton.size = Vector2(50,50)
		textureButton.pressed.connect(_on_texture_button_pressed.bind(textureButton));
		buttonsAndTheirTextures[textureButton] = key;
		grid.add_child(textureButton)

func _on_texture_button_pressed(button: TextureButton):
	var textureName = buttonsAndTheirTextures.get(button)
	var sourceId = tiles.get(currentLayer).get(textureName).get(sourceID)
	tile_to_place_changed.emit(textureName, sourceId)
	


