extends Node

class_name ENEMY_DATA

var speed: float # The walking speed of the enemy
var enemyType: String # The general type of the enemy, eg. Mummy, Ent, Demon etc.
var enemyVariant: String # The variant of the type, eg. Mummy1, Ent2 etc.
var enemyAttackType: String # The attack type of the enemy. It can be ranged or melee
var enemyRangedAttackType: String # The ranged attack type's missle trajectory type. The trajectile can either follow the enemy until player destroys it, or it can collide with things
var enemyShootTime: int # The time interval the ranged enemy shoots their projectile
var enemyWalkStrategy: String # The enemy's walking strategy. The enemy can follow the player from the time it spawns, or the enemy can stay idle until player enters its area

func _init(_speed: float, _enemyType: String, _enemyVariant: String, _enemyAttackType: String, _enemyRangedAttackType: String, _enemyShootTime: int, _enemyWalkStrategy: String):
	speed = _speed
	enemyType = _enemyType
	enemyVariant = _enemyVariant
	enemyAttackType = _enemyAttackType
	enemyRangedAttackType = _enemyRangedAttackType
	enemyShootTime = _enemyShootTime
	enemyWalkStrategy = _enemyWalkStrategy


