extends Node2D

@onready var player = get_node("Player")




func _ready():
	#door.player_detector.body_entered.connect(_on_player_detector_body_entered)
	#nanogram.solvedSignal.connect(openChest)
	$NonogramLocation.initialize( "easy","res://Game Assets/MapEditor/MinigamePlaces/LARGE_BOOKCASE_OAK.png","res://MiniGames/SimonSays/simon-says.tscn",  "asd")
	
	#_difficulty: String, _texturePath: String, _minigamePath: String, _reward: String
	pass
	



