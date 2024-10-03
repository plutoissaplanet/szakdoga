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
var atlasCoordsString: String

@onready var tileMap: TileMap


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
	print("viewport size to local: ", to_local(size))
	print("viewport size to gloval: ", to_global(size))
	
	tileMap = decorationEditor.tileMap
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
	
func _input_event_on_floor_area_collision(event: InputEvent): #for when the player wants to either place or delete a tile
	print(selectedTileName, " ", selectedTileId, " ", "layer: ", currentLayer)
	if event.is_action_pressed("room_changer_click") and selectedTileName and (currentLayer == 0 or currentLayer == 2):
		_editing_logic()

func _input_event_on_wall_area_collision(event: InputEvent): #if the player wants to place a wall
	if event.is_action_pressed("room_changer_click") and selectedTileName and currentLayer == 1:
		_editing_logic()
		
func _editing_logic():
	var worldPosition = tileMap.get_global_mouse_position()
	match tileEditorMode:
		"Delete":
			_delete_tile(worldPosition)
		"Place":
			_place_tile(selectedTileId, worldPosition)

func _place_tile(tileToPlace: int, pos: Vector2i) -> void:
	pos = pos + Vector2i(16,16)
	var localizedPosition = tileMap.local_to_map(pos)
	var sourceID = tiles.get(currentLayer).get(selectedTileName).get(sourceIDString)
	var atlasCoordinatesOfSelectedTile = tiles.get(currentLayer).get(selectedTileName).get(atlasCoordsString)
	tileMap.set_cell(currentLayer, localizedPosition, sourceID, atlasCoordinatesOfSelectedTile)

func _delete_tile(pos: Vector2i) -> void:
	pos = pos + Vector2i(16,16)
	var localizedPosition = tileMap.local_to_map(pos)
	tileMap.set_cell(currentLayer, localizedPosition)

func _editor_mode_changed(newMode: String) -> void:
	tileEditorMode = newMode
	print(tileEditorMode)
	
func _layer_changed(layer: int):
	currentLayer = layer
	selectedTileName = ""
	print("current layer: ", currentLayer)
	
func _tile_to_place_changed(tile: String, sourceId: int): #for when another tile is selected
	selectedTileName = tile
	selectedTileId = tiles.get(currentLayer).get(selectedTileName).get(sourceIDString)
	
func _add_editor_nodes_to_map():
	add_child(decorationEditor)


