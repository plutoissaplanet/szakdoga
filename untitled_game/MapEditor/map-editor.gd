extends Node2D

var screenWidth: float
var screenHeight: float
var enemyEditor = preload("res://MapEditor/EditorModes/enemy-mode.tscn").instantiate()
var gameplayEditor = preload("res://MapEditor/EditorModes/gameplay-mode.tscn").instantiate()
var decorationEditor = preload("res://MapEditor/EditorModes/decorator-mode.tscn").instantiate()
var areaDetector = preload("res://MapEditor/EditorModes/area_detector.tscn").instantiate()

var currentLayer: int #The current layer the user is "painting on"
var selectedTile: int #The tile currently selected and ready to be placed (source_id)
var selectedTileName: String #The name of the current tile, like "LIGHT_FLOOR"
var selectedTilesAtlasCoord: Dictionary
var tileEditorMode: String #Modes include: deleting, placing, placing in rectangle

@onready var tileMap: TileMap


#TODO
# add the editor nodes needed for editing
# load every item
# save button

func _ready():
	_add_editor_nodes_to_map()
	screenWidth = get_viewport_rect().size.x
	screenHeight = get_viewport_rect().size.y
	var size = get_viewport_rect().size
	print("viewport size to local: ", to_local(size))
	print("viewport size to gloval: ", to_global(size))
	get_viewport().size_changed.connect(_resize_and_reposition)
	tileMap = decorationEditor.tileMap
	tileEditorMode = "Place"
	decorationEditor.editor_mode_changed.connect(_editor_mode_changed)
	areaDetector.mouse_in_area.connect(_input_event_on_area_collision)
	selectedTile = 0
	currentLayer = 0
	selectedTileName = TileNames.PANEL_FLOOR
	selectedTilesAtlasCoord = decorationEditor.atlasCoordinatesFlooring


func _place_tile(tileToPlace: int, pos: Vector2i) -> void:
	pos = pos + Vector2i(16,16)
	var localizedPosition = tileMap.local_to_map(pos)
	var atlasCoordinatesBySourceID = selectedTilesAtlasCoord.get(selectedTile)
	var atlasCoordinatesOfSelectedTile =atlasCoordinatesBySourceID.get(selectedTileName)
	tileMap.set_cell(currentLayer, localizedPosition, selectedTile, atlasCoordinatesOfSelectedTile)

func _delete_tile(pos: Vector2i) -> void:
	pos = pos + Vector2i(16,16)
	var localizedPosition = tileMap.local_to_map(pos)
	tileMap.set_cell(currentLayer, localizedPosition)

func _editor_mode_changed(newMode: String) -> void:
	tileEditorMode = newMode
	print(tileEditorMode)
	
func _add_editor_nodes_to_map():
	add_child(decorationEditor)
	add_child(areaDetector)
	
	
func _input_event_on_area_collision(event: InputEvent):
	if event.is_action_pressed("room_changer_click"):
		var worldPosition = tileMap.get_global_mouse_position()
		match tileEditorMode:
			"Delete":
				_delete_tile(worldPosition)
			"Place":
				_place_tile(selectedTile, worldPosition)

func _resize_and_reposition():
	var newScreenSizeWidth = get_tree().root.size.x
	print(newScreenSizeWidth)


