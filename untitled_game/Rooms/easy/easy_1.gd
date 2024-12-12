extends Node2D

@onready var player = get_node("Player")

var mapDifficulty = "easy"
var notOwnMap = false


func _ready():
	#initialize(_difficulty: String, _texturePath: String, _minigamePath: String, _reward: String):
	
	$NonogramLocation.initialize( "easy","res://Game Assets/MapEditor/MinigamePlaces/LARGE_BOOKCASE_OAK.png","res://MiniGames/SimonSays/simon-says.tscn", "Key")
	$NonogramLocation.keyID = "FINAL_DOOR"
	$Door.ID = "FINAL_DOOR"
	$Door.FINAL_DOOR = true
	
	



