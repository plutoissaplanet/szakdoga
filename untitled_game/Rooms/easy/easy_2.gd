extends Node2D

@onready var animation= get_node("Door/AnimationPlayer")
@onready var player = get_node("Player")
var functions =load("res://FunctionsToUse.gd")
var mapDifficulty = 'hard'
var notOwnMap = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var enemy = load("res://Creatures/Monsters/Skeleton.tscn").instantiate()
	enemy.player = $Player
	var enemydata = ENEMY_DATA.new(56,"Mummy", "Mummy1", "melee", 20, "easy", 100, 10)
	enemy.set_enemy_data(enemydata)
	add_child(enemy)
	
	var enemy2 = load("res://Creatures/Monsters/Skeleton.tscn").instantiate()
	enemy2.player = $Player
	var enemydata2 = ENEMY_DATA.new(56,"Mummy", "Mummy1", "melee", 20, "easy", 100, 10)
	enemy.set_enemy_data(enemydata2)
	add_child(enemy2)
	#
#func _process(delta):
	#var detector = get_overlapping_bodies()

#speed = _speed
	#enemyType = _enemyType
	#enemyVariant = _enemyVariant
	#enemyAttackType = _enemyAttackType
	##enemyRangedAttackType = _enemyRangedAttackType
	#enemyShootTime = _enemyShootTime
	#enemyDifficulty = _enemyDifficulty
	#healthPoints = _healthPoints
	#attackPoints = _attackPoints
