extends Node2D

class_name TILEMAP_TO_JSON

var floorTilemap
var wallTilemap
var boundaryTilemap

var TILES_TO_PLACE = {
	0: {},
	1: {},
	2: {}
}


func _init(_floorTileMap: TileMap, _wallTileMap: TileMap, _boundaryTileMap):
	floorTilemap = _floorTileMap
	wallTilemap = _wallTileMap
	boundaryTilemap = _boundaryTileMap
	

func get_tiles_to_place():
	_floor_data()
	_wall_data()
	_decor_data()
	
	return TILES_TO_PLACE
	
func _floor_data():
	var floorTiles = floorTilemap.get_used_cells(0)
	for tile in floorTiles:
		var globalPosition = floorTilemap.map_to_local(Vector2i(tile))
		TILES_TO_PLACE.get(0)[globalPosition] = {}
		TILES_TO_PLACE.get(0).get(globalPosition)["atlasCoords"] = floorTilemap.get_cell_atlas_coords(0, Vector2i(tile))
		TILES_TO_PLACE.get(0).get(globalPosition)["sourceId"] = floorTilemap.get_cell_source_id(0, Vector2i(tile))
	
	
func _wall_data():
	var wallTiles = wallTilemap.get_used_cells(1)
	for tile in wallTiles:
		var globalPosition = wallTilemap.map_to_local(Vector2i(tile))
		TILES_TO_PLACE.get(1)[globalPosition] = {}
		TILES_TO_PLACE.get(1).get(globalPosition)["atlasCoords"] = wallTilemap.get_cell_atlas_coords(1, Vector2i(tile))
		TILES_TO_PLACE.get(1).get(globalPosition)["sourceId"] = wallTilemap.get_cell_source_id(1, Vector2i(tile))
	
func _decor_data():
	var floorTiles = floorTilemap.get_used_cells(0)
	for tile in floorTiles:
		if floorTilemap.get_cell_source_id(2, Vector2i(tile)) != -1:
			var globalPosition = floorTilemap.map_to_local(Vector2i(tile))
			TILES_TO_PLACE.get(2)[globalPosition] = {}
			TILES_TO_PLACE.get(2).get(globalPosition)["atlasCoords"] = floorTilemap.get_cell_atlas_coords(2, Vector2i(tile))
			TILES_TO_PLACE.get(2).get(globalPosition)["sourceId"] = floorTilemap.get_cell_source_id(2, Vector2i(tile))
	

