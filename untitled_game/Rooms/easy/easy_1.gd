extends Node2D

@onready var player = get_node("Player")
@onready var door= get_node("Container/Door")
@onready var cont = get_node("Container")
@onready var nanogram= get_node("NonogramLocation/CenterContainer/nanogram_cells")
@onready var chest = get_node("ChestGen")
@onready var spawn_node=get_node("EnemySpawnpoint")

func _ready():
	door.player_detector.body_entered.connect(_on_player_detector_body_entered)
	nanogram.solvedSignal.connect(openChest)
	spawn_node.player=player
	spawn_node.room=self
	
func _on_player_detector_body_entered(body):
	var shared_wall=get_node("Room1/MapTiles")
	if body == player:
		door.WallZIndexChanger(shared_wall, door)
		
func openChest():
	chest.openSesame=true


