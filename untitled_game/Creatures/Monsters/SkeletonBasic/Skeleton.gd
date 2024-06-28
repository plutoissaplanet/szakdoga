extends CharacterBody2D

var state_machine=StateMachine.new()
var player

@onready var timer=get_node("Timer")
@onready var enemy = $AnimatedSprite2D
@onready var animationTree = $AnimationTree

func _ready():
	state_machine.player=player
	state_machine.state=state_machine.MOVE
	state_machine.enemySprite=enemy
	state_machine.animationTree = animationTree
	state_machine.set_stats(60, 10)
	enemy.scale.x=0.1
	enemy.scale.y=0.1
	
func _physics_process(delta):
	state_machine.update(delta, self)

func _on_timer_timeout():
	state_machine.state=state_machine.ATTACK
	animationTree.set("parameters/conditions/enemyIsAttacking", true)
	timer.start()

	
