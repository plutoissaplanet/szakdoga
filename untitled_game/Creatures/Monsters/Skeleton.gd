extends CharacterBody2D

var state_machine=StateMachine.new()
var player

@onready var timer=get_node("Timer")

func _ready():
	state_machine.player=player
	state_machine.state=state_machine.MOVE
	state_machine.set_stats(60, 10)
	
func _physics_process(delta):
	state_machine.update(delta, self)

func _on_timer_timeout():
	state_machine.state=state_machine.ATTACK
	timer.start()

	
