extends Node2D

var floorTileMap
var wallTileMap
var boundaryTileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	floorTileMap = $FloorTileMap
	boundaryTileMap = $BoundaryTileMap
	wallTileMap = $WallTileMap

