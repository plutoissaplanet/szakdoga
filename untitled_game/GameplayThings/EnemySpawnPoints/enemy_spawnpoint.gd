extends Marker2D

const skeletonEnemy=preload("res://Creatures/Monsters/Skeleton.tscn")
var player
var maxEnemies
var room
#TODO make it so that enemyData is adjustable from other script (eg. when player edits a map and chooses what enemy to spawn)
var enemyData: ENEMY_DATA = ENEMY_DATA.new(0.1, 'Mummy', 'Mummy1', 'Ranged', 'OneTime', 3, 'Instant')
#_speed: float, _enemyType: String, _enemyVariant: String, _enemyAttackType: String, _enemyRangedAttackType: String, _enemyShootTime: int, _enemyWalkStrategy: String

@onready var node = get_node(".")

func _on_timer_timeout():
	spawn_monsters(room) 
		
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
