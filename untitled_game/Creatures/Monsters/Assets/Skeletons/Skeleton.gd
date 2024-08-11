extends CharacterBody2D

var state_machine=StateMachine.new()
var player

@onready var timer=get_node("Timer")
@onready var enemy = $AnimatedSprite2D
@onready var animationTree = $AnimationTree
@onready var animPlayer = $AnimationPlayer

@export var animationPath: String
 

var animation_files = AnimationLibrary.new()

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
	var animTreeMaker = AnimationTreeMaker.new()
	load_animations(animationPath)

	enemy.scale.x=0.1
	enemy.scale.y=0.1
	
func _physics_process(delta):
	state_machine.update(delta, self)

func _on_timer_timeout():
	state_machine.state=state_machine.ATTACK
	animationTree.set("parameters/conditions/enemyIsAttacking", true)
	timer.start()
	
func load_animations(path: String): #not gonna need this
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var files = dir.get_next()
		while files != "":
			var name = files.get_slice("_",1).get_slice(".",0)
			var anim_path = path + files
			var animation = load(anim_path)
			animation_files.add_animation(name, animation)
			files=dir.get_next()
	animPlayer.add_animation_library("enemyAnimation", animation_files)


