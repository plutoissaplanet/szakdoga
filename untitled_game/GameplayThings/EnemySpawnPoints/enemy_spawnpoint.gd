extends Marker2D

const skeletonEnemy=preload("res://Creatures/Monsters/Assets/Skeletons/Skeleton.tscn")
var player
var maxEnemies
var room
@onready var node = get_node(".")

func _on_timer_timeout():
	spawn_monsters(room)
		
func spawn_monsters(r):
	var randomNumberOfEnemies = 1#randi_range(1,2) #the 3 will need to be changed to maxenemies when making different levels of maps and for the editor mode.
	for i in range(randomNumberOfEnemies):
		#print("enemy spawned")
		var enemyinstance=skeletonEnemy.instantiate()
		enemyinstance.animationPath="res://Creatures/Monsters/Animations/Ent/"
		
		var randomOffsetX = randf_range(-10, 10)
		var randomOffsetY = randf_range(-10, 10)
		enemyinstance.player=player
		enemyinstance.position.x=node.global_position.x+randomOffsetX
		enemyinstance.position.y=node.global_position.y+randomOffsetY
		r.add_child(enemyinstance)
