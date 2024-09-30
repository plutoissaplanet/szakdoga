extends Node2D


const flooringTilesID = [0, 1] #The possible tile cell ID's
const atlasCoordinatesFlooring = {
	0: {
		TileNames.PANEL_FLOOR: Vector2i(0, 0),
		TileNames.DARK_PANEL_FLOOR: Vector2i(4,0),
		TileNames.STONE_FLOOR: Vector2i(8, 0),
	},
	
	1: {
		TileNames.LIGHT_PANEL_FLOOR: Vector2i(6,6),
		TileNames.LIGHT_FLOOR: Vector2i(10,6)
	}
}

const atlasCoordinatesWall = {
	2: {
		TileNames.DARK_GREEN_WALL: Vector2i(2,1),
		TileNames.DARK_RED_PANEL_WALL: Vector2i(6, 1),
		TileNames.DARK_RED_WALL: Vector2i(10, 1),
		TileNames.ORANGE_TILE_WALL: Vector2i(14, 1)
	},
	
	3: {
		TileNames.LIGHT_GREEN_WALL: Vector2i(2,1),
		TileNames.ORANGE_PANEL_WALL: Vector2i(6,1),
		TileNames.CREAM_WALL: Vector2i(10,1)
	}
}
var currentLayer: int #The current layer the user is "painting on"
var selectedTile: int #The tile currently selected and ready to be placed
var screenWidth = DisplayServer.screen_get_size().x
var screenHeight = DisplayServer.screen_get_size().y
signal editor_mode_changed(mode: String)

@onready var tileMap: TileMap = $TileMap

func _process(delta):
	screenWidth = DisplayServer.screen_get_size().x
	screenHeight = DisplayServer.screen_get_size().y

func _on_texture_button_pressed():
	editor_mode_changed.emit("Delete")
