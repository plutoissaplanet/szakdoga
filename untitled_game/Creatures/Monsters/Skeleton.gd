extends CharacterBody2D

var state_machine=StateMachine.new()
var player: CharacterBody2D

@onready var timer=get_node("Timer")
@onready var enemy = $AnimatedSprite2D
@onready var animationTree = $AnimationTree
@onready var animPlayer = $AnimationPlayer
@export var monsterType: String
@export var variant: String
@export var speed: float
var enemyObject: ENEMY_DATA
var projectileArray = []
var animation_files = AnimationLibrary.new()
var libraryName: String
var rangedAndIdleEnemyArea: Area2D
var rangedAndIdleEnemyCollision: CollisionShape2D

enum {
	SKELETON_1
}


func _ready():
	if player != null:
		state_machine.player = player 
		rangedAndIdleEnemyArea = player.overlappingProjectileHitArea
		rangedAndIdleEnemyCollision = rangedAndIdleEnemyArea.get_children()[0]
	
	state_machine.projectile_hit.connect(_projectile_hit)
	state_machine.state=state_machine.MOVE
	state_machine.enemySprite=enemy
	state_machine.enemy = self
	state_machine.animationTree = animationTree
	
	
	self.add_to_group(enemyObject.enemyAttackType)
	
	enemy.scale.x = 0.1
	enemy.scale.y = 0.1
	
	animationTree.active=true
	var animationMaker = ANIMATION_MAKER.new()
	animationMaker.make_animation('Monsters/Assets', enemyObject.enemyType, enemyObject.enemyVariant, float(enemyObject.speed), '', animPlayer, 'enemyLibrary', enemy)
	animationMaker.add_points_to_blendspace(animationTree, 'enemyLibrary/', animPlayer )

func set_enemy_data(enemyData: ENEMY_DATA):
	enemyObject = enemyData
	state_machine.enemyObject = enemyObject
	state_machine.set_stats(int(enemyObject.healthPoints), int(enemyObject.attackPoints))
	
func _physics_process(delta):
	state_machine.update(delta, self)
	
func _process(delta):
	if player:
		if projectileArray.size() != 0:
			for projectile in projectileArray:
				var direction = (player.position - projectile.position).normalized()
				projectile.position = projectile.position + direction * delta * 100
		if enemyObject.enemyAttackType == 'Ranged' and state_machine.state != state_machine.ATTACK :
			var enemyDistanceFromPlayer = player.position.distance_to(self.position)
			if enemyDistanceFromPlayer < rangedAndIdleEnemyCollision.shape.radius+10:
				timer.stop()
				state_machine.state = state_machine.WALK_AWAY
			elif timer.is_stopped():
				timer.start()
		#if enemyDistanceFromPlayer > rangedAndIdleEnemyCollision.shape.radius+10:
			#state_machine.state = state_machine.MOVE

func _on_timer_timeout():
	state_machine.state=state_machine.ATTACK
	animationTree.set("parameters/conditions/enemyIsAttacking", true)
	timer.start()
	
func _projectile_hit(projectileToErase: Area2D):
	projectileArray.erase(projectileToErase)
	projectileToErase.queue_free()
