extends Node

class_name AnimationTreeMaker



#func add_animations_to_tree(animations: Array):
	#var i = 0
	#for state in STATES.values():
		#var node = AnimationNodeAnimation.new()
		#node.animation = animations[i]
		#stateMachine.add_node(node, state)
		#i+=1
	#

#func add_transitions_between_nodes():
	#for animationNodes in animationTree.tree_root.get_node():
		#match animationNodes:
			#"idle":
				#stateMachine.add_transition("idle", "attack", AnimationNodeStateMachineTransition.new())
				#stateMachine.add_transition("idle", "walk", AnimationNodeStateMachineTransition.new())
				#stateMachine.add_transition("idle", "hurt", AnimationNodeStateMachineTransition.new())
			#"attack":
				#stateMachine.add_transition("attack", "idle", AnimationNodeStateMachineTransition.new())
				#stateMachine.add_transition("attack", "walk", AnimationNodeStateMachineTransition.new())
				#stateMachine.add_transition("attack", "hurt", AnimationNodeStateMachineTransition.new())
			#"walk":
				#stateMachine.add_transition("walk", "attack", AnimationNodeStateMachineTransition.new())
				#stateMachine.add_transition("walk", "idle", AnimationNodeStateMachineTransition.new())
				#stateMachine.add_transition("walk", "hurt", AnimationNodeStateMachineTransition.new())
			#"death":
				#state_machine.add_transition("death", )
		

		
#func add_tree_to_target_entity(animations: Array, target: CharacterBody2D):
	#add_animations_to_tree(animations)
	#add_points_to_blendspace()
	#target.add_child(animationTree)
	
	
	

