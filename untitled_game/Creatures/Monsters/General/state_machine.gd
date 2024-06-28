extends CharacterBody2D

class_name StateMachine

var state
var player
var animation
var SPEED = 30.0
@export var stats = Statistics.new()
@export var enemySprite: AnimatedSprite2D
@export var animationTree: AnimationTree

enum {
	ATTACK,
	MOVE,
	HIT,
	IDLE,
	HURT
}

func update(delta, enemy):
	if player == null:
		print("Player object is null!")
		return
		
	match state:
		MOVE:
			move(player, delta, enemy)
		IDLE:
			animationTree.set("parameters/conditions/enemyIsIdle", true)
			#animationTree.set("parameters/conditions/enemyIsAttacking", false)
			animationTree.set("parameters/conditions/enemyHurt", false)
		HIT:
			pass
		ATTACK:
			attack(player)
			state=IDLE
			
func move(target, delta, node):
	var target_pos=target.position
	var direction=(target_pos-node.position).normalized()
	var new_pos = node.position + direction * SPEED * delta
	node.position= new_pos
	if direction.x < 0:
		enemySprite.flip_h=true
	else:
		enemySprite.flip_h=false
	

func attack(target):
	animationTree.set("parameters/conditions/enemyIsIdle", false)
	target.stats.HealthPoints -= stats.AttackPoints
	if target.stats.HealthPoints<=0:
		target.state=target.DEATH
	animationTree.set("parameters/conditions/enemyIsAttacking", false)
	

func enemy_hit(damage, obj):
	stats.HealthPoints-=damage
	if stats.HealthPoints <=0:
		print("enemy died")
		enemy_death(obj)
	state=IDLE

	
func enemy_death(enemy):
	if animation != null:
		animation.play("enemy_death")
	enemy.queue_free()
	
func set_stats(healthpoints, attackpoints):
	stats.AttackPoints=attackpoints
	stats.HealthPoints=healthpoints	


