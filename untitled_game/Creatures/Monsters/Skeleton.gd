extends CharacterBody2D

var state_machine=StateMachine.new()
var player

@onready var timer=get_node("Timer")
@onready var enemy = $AnimatedSprite2D
@onready var animationTree = $AnimationTree
@onready var animPlayer = $AnimationPlayer

@export var monsterType: String
@export var variant: String
@export var speed: float

var animation_files = AnimationLibrary.new()
var libraryName: String

enum {
	SKELETON_1
}


func _ready():
	state_machine.player=player
	state_machine.state=state_machine.MOVE
	state_machine.enemySprite=enemy
	state_machine.animationTree = animationTree
	animationTree.active=true
	state_machine.set_stats(60, 10)
	var animationMaker = ANIMATION_MAKER.new()
	enemy.scale.x = 0.1
	enemy.scale.y = 0.1
	animationMaker.make_animation('Monsters/Assets', monsterType, variant, speed, '', animPlayer, 'enemyLibrary', enemy)
	animationMaker.add_points_to_blendspace(animationTree, 'enemyLibrary/', animPlayer )
	
func _physics_process(delta):
	state_machine.update(delta, self)

func _on_timer_timeout():
	state_machine.state=state_machine.ATTACK
	animationTree.set("parameters/conditions/enemyIsAttacking", true)
	timer.start()
	

