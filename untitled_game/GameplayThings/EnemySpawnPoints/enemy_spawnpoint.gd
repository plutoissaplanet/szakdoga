extends Marker2D

class_name ENEMY_SPAWN_POINT

var numberOfEnemiesToSpawn
var timerSpeed
var enemyData


const skeletonEnemy=preload("res://Creatures/Monsters/Skeleton.tscn")
var player
var numberOfEnemiesSpawned = 0

#TODO make it so that enemyData is adjustable from other script (eg. when player edits a map and chooses what enemy to spawn)

#_speed: float, _enemyType: String, _enemyVariant: String, _enemyAttackType: String, _enemyRangedAttackType: String, _enemyShootTime: int, _enemyWalkStrategy: String

@onready var node = get_node(".")


func initialitze(_numberOfEnemiesToSpawn: int, _timerSpeed: int, _enemyData: ENEMY_DATA, _player = null ):
	numberOfEnemiesToSpawn = _numberOfEnemiesToSpawn
	timerSpeed = _timerSpeed
	enemyData = _enemyData
	player = _player
	
	
	
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

func _on_timer_timeout():
	if numberOfEnemiesSpawned == numberOfEnemiesToSpawn:
		$Timer.stop()
		get_parent().remove_child(self)
	else:
		spawn_monsters(get_parent())
		numberOfEnemiesSpawned += 1
		
func spawn_monsters(r):
	var enemyinstance=skeletonEnemy.instantiate()
	enemyinstance.set_enemy_data(enemyData)
	var randomOffsetX = randf_range(-10, 10)
	var randomOffsetY = randf_range(-10, 10)
	enemyinstance.player=player
	enemyinstance.position.x=node.global_position.x+randomOffsetX
	enemyinstance.position.y=node.global_position.y+randomOffsetY
	r.add_child(enemyinstance)

	
