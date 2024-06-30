extends Node

class_name AnimationTreeMaker

@export var targetEntity: CharacterBody2D
@export var animPlayer: AnimationPlayer
var animationTree: AnimationTree

enum {
	
}

func _ready():
	animationTree.tree_root = AnimationNodeStateMachine.new()

func add_animations_to_tree(animations: Array):
	for animation in animations:
		match String(animation):
			"idle":
				animationTree.add_node("idle", animation)
			"walk":
				animationTree.add_node("walk", animation)
			"hurt":
				animationTree.add_node("hurt", animation)
			"death":
				animationTree.add_node("death", animation)
			"attack":
				animationTree.add_node("attack", animation)

func add_transitions_between_nodes(animation_tree: AnimationTree):
	for animationNodes in animation_tree.tree_root.get_node():
		match animationNodes:
			"idle":
				animationTree.add_transition("idle", "attack", AnimationNodeTransition.new())
				animationTree.add_transition("idle", "walk", AnimationNodeTransition.new())
				animationTree.add_transition("idle", "hurt", AnimationNodeTransition.new())
				animationTree.add_transition("idle", "death", AnimationNodeTransition.new())
		
	
func add_completed_tree_to_target_entity():
	pass


