extends CharacterBody2D

class_name StateMachine

var state
var player
var animation
var SPEED = 30.0
var animationStateMachine: AnimationNodeStateMachine
var animationMachine = AnimationMachine.new()
var ENEMY_CONDITIONS = animationMachine.ENEMY_CONDITIONS

@export var stats = Statistics.new()
@export var enemySprite: AnimatedSprite2D
@export var animationTree: AnimationTree

var enemy
var enemyObject: ENEMY_DATA
var projectile: Sprite2D
signal projectile_hit(projectile: Area2D)
@onready var animationPlayer = $AnimationPlayer

enum {
	ATTACK,
	MOVE,
	HIT,
	IDLE,
	HURT,
	WALK_AWAY
}

enum {
	ROAM,
	FOLLOW 
}

var stateMap = {
	"move": MOVE,
	"attack": ATTACK,
	"idle": IDLE,
	"hurt": HURT
}



func _set_state(newState: String, condition: String):
	for key in ENEMY_CONDITIONS.keys():
		if ENEMY_CONDITIONS[key] != condition:
			animationTree.set(ENEMY_CONDITIONS[key], false)
	animationTree.set(condition, true)
	state = stateMap.get(newState)

func update(delta, enemy):
	if player == null:
		return
	match state:
		MOVE:
			_set_state("move", ENEMY_CONDITIONS.enemyWalking)
			move(player, delta, enemy, 'To')
		IDLE:
			SPEED = 0
			_set_state("idle", ENEMY_CONDITIONS.enemyIsIdle)
		HIT:
			pass
		ATTACK:
			_set_state("attack", ENEMY_CONDITIONS.enemyIsAttacking)
			attack(player, delta)
			state = IDLE
		WALK_AWAY:
			_set_state("move", ENEMY_CONDITIONS.enemyWalking)
			move(player, delta, enemy, 'Away')

func move(target, delta, node, dir):
	SPEED = 30.0
	var target_pos=target.position
	var direction=(target_pos-node.position).normalized()
	if dir == 'To':
		var new_pos = node.position + direction * SPEED * delta
		node.position= new_pos
	else:
		var new_pos = node.position - direction * SPEED * delta
		node.position= new_pos
	if direction.x < 0:
		enemySprite.flip_h=true
	else:
		enemySprite.flip_h=false
	
func attack(target, delta):
	if enemyObject.enemyAttackType == 'MELEE':
		_melee_attack(target)
	else:
		_ranged_attack(target, enemyObject.enemyShootTime, delta)
		
func enemy_hit(damage, obj):
	stats.HealthPoints-=damage
	if stats.HealthPoints <=0:
		animationTree.set("parameters/conditions/enemyIsDead", false)
		enemy_death(obj)
	state=IDLE

func enemy_death(enemy):
	animationTree.set("parameters/conditions/enemyIsDead", true)
	if animationTree.animation_finished:
		enemy.queue_free()
	
func set_stats(healthpoints, attackpoints):
	stats.AttackPoints=attackpoints
	stats.HealthPoints=healthpoints

func _melee_attack(target):
	target.stats.HealthPoints -= stats.AttackPoints
	target.state = HURT
	if target.stats.HealthPoints<=0:
		target.state=target.DEATH
	_set_state("attack", ENEMY_CONDITIONS.enemyIsAttacking)
	
func _ranged_attack(target, shootInterval, delta):
	#Create the projectile
	var newProjectileSprite = Sprite2D.new()
	newProjectileSprite.texture = load("res://Creatures/Monsters/SpellsEffect.png")
	newProjectileSprite.scale = Vector2(0.2, 0.2)
	
	#create the projectile's player detection
	var newProjectileArea = Area2D.new()
	var collisionDetector = CollisionShape2D.new()
	collisionDetector.shape = CircleShape2D.new()
	collisionDetector.shape.radius = 20
	newProjectileArea.add_child(collisionDetector)
	newProjectileArea.add_child(newProjectileSprite)
	newProjectileArea.position = enemy.position
	newProjectileArea.add_to_group("Projectile")
	newProjectileArea.collision_layer = 1
	newProjectileArea.collision_mask = 1
	enemy.get_parent().add_child(newProjectileArea)
	
	#Connect it to the function
	newProjectileArea.body_entered.connect(_projectile_hit_body.bind(newProjectileArea))
	enemy.projectileArray.append(newProjectileArea)
	_set_state("idle", ENEMY_CONDITIONS.enemyIsIdle)

func _projectile_hit_body(target, projectile):
	if target.is_in_group("Player"):
		target.state = target.HURT
		target.stats.HealthPoints -= stats.AttackPoints
		projectile_hit.emit(projectile)
	
func _ranged_weapon_trajectory():
	pass
	#TODO one that follows the player and can only be destroyed if player "attacks" it and one that doesnt follow the player and just explodes if it reaches a furniture

func _walking_strategy(strategy: String):
	pass
	#TODO one that roams and only attack the player if the player get too close, and one that sees the player immediately
	

	
