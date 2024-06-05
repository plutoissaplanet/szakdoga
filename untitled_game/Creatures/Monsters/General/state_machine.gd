extends CharacterBody2D

class_name StateMachine

var state
var player
var animation
var SPEED = 30.0
@export var stats = Statistics.new()

enum {
	ATTACK,
	MOVE,
	HIT,
	IDLE,
	HURT
}

#func print_init():
	#print("State machineban vagy! ", state)
	
func update(delta, enemy):
	if player == null:
		print("Player object is null!")
		return
		
	match state:
		MOVE:
			move(player, delta, enemy)

		IDLE:
			pass
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

func attack(target):
	#print("enemy attack points:",stats.AttackPoints)
	target.stats.HealthPoints -= stats.AttackPoints
	if target.stats.HealthPoints<=0:
		print("player dead")
		
func enemy_hit(damage, obj):
	if animation != null:
		animation.play("enemy_hurt")
	stats.HealthPoints-=damage
	if stats.HealthPoints <=0:
		print("enemy died")
		enemy_death(obj)
	
func enemy_death(enemy):
	if animation != null:
		animation.play("enemy_death")
	enemy.queue_free()
	
func set_stats(healthpoints, attackpoints):
	stats.AttackPoints=attackpoints
	stats.HealthPoints=healthpoints


