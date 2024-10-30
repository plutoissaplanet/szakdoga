extends Marker2D

class_name ENEMY_SPAWN_POINT

var numberOfEnemiesToSpawn
var timerSpeed
var enemyData
var map

const skeletonEnemy=preload("res://Creatures/Monsters/Skeleton.tscn")
var player

#TODO make it so that enemyData is adjustable from other script (eg. when player edits a map and chooses what enemy to spawn)

#_speed: float, _enemyType: String, _enemyVariant: String, _enemyAttackType: String, _enemyRangedAttackType: String, _enemyShootTime: int, _enemyWalkStrategy: String

@onready var node = get_node(".")

func _init(_numberOfEnemiesToSpawn: int, _timerSpeed: int, _enemyData: ENEMY_DATA, ):
	numberOfEnemiesToSpawn = _numberOfEnemiesToSpawn
	timerSpeed = _timerSpeed
	enemyData = _enemyData
	
func return_dictionary():
	return {
		"numberOfEnemiesToSpawn": numberOfEnemiesToSpawn,
		"timerSpeed": timerSpeed,
		"enemyData": {
			"speed": enemyData.speed,
			"enemyType": enemyData.enemyType,
			"enemyVariant": enemyData.enemyVariant,
			"enemyAttackType": enemyData.enemyAttackType,
			"enemyShootTime": enemyData.enemyShootTime,
			"enemyDifficulty": enemyData.enemyDifficulty,
			"healthPoints": enemyData.healthPoints,
			"attackPoints": enemyData.attackPoints
			},
	}

#func _on_timer_timeout():
	#spawn_monsters(map) 
		#
func spawn_monsters(r):
	var randomNumberOfEnemies = 1#randi_range(1,2) #the 3 will need to be changed to maxenemies when making different levels of maps and for the editor mode.
	for i in range(randomNumberOfEnemies):
		var enemyinstance=skeletonEnemy.instantiate()
		enemyinstance.enemyObject = enemyData
		var randomOffsetX = randf_range(-10, 10)
		var randomOffsetY = randf_range(-10, 10)
		enemyinstance.player=player
		enemyinstance.position.x=node.global_position.x+randomOffsetX
		enemyinstance.position.y=node.global_position.y+randomOffsetY
		r.add_child(enemyinstance)
