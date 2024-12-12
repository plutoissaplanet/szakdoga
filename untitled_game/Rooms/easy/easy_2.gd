extends Node2D

@onready var animation= get_node("Door/AnimationPlayer")
@onready var player = get_node("Player")
var functions =load("res://FunctionsToUse.gd")
var mapDifficulty = "easy"
var notOwnMap = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var enemy = load("res://Creatures/Monsters/Skeleton.tscn").instantiate()
	enemy.player = $Player
	var enemydata = ENEMY_DATA.new(0.07,"Mummy", "Mummy1", "Melee", 20, "easy", 100, 10)
	enemy.set_enemy_data(enemydata)
	enemy.position= $Player.position - Vector2(70,29)
	add_child(enemy)
	
	#var enemyData = ENEMY_DATA.new(float(enemyDataDictionary.speed), enemyDataDictionary.enemyType, enemyDataDictionary.enemyVariant, enemyDataDictionary.enemyAttackType, int(enemyDataDictionary.enemyShootTime), enemyDataDictionary.enemyDifficulty, int(enemyDataDictionary.healthPoints), int(enemyDataDictionary.attackPoints))
	
	var enemy2 = load("res://Creatures/Monsters/Skeleton.tscn").instantiate()
	enemy2.player = $Player
	var enemydata2 = ENEMY_DATA.new(0.07,"Mummy", "Mummy1", "Melee", 20, "easy", 100, 10)
	enemy2.set_enemy_data(enemydata2)
	enemy2.position= $Player.position + Vector2(100,20)
	
	add_child(enemy2)
	

	$NonogramLocation.initialize( "easy","res://Game Assets/MapEditor/MinigamePlaces/LARGE_BOOKCASE_OAK.png","res://MiniGames/MemoryGame/memory_game.tscn", "Key")
	$NonogramLocation.keyID = "FINAL_DOOR"
	$NonogramLocation2.initialize( "easy","res://Game Assets/MapEditor/MinigamePlaces/LARGE_BOOKCASE_OAK.png","res://MiniGames/Maze/maze.tscn", "Item")
	$Door.ID = "FINAL_DOOR"
	$Door.FINAL_DOOR = true
