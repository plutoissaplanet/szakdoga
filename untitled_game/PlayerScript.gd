extends CharacterBody2D


const SPEED = 200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var character = get_node("AnimatedSprite2D")
@onready var animation = get_node("AnimationPlayer")


func _physics_process(_delta):
	
	#Fel-le nyilaakkal karaktermozgatás
	var move_right = Input.is_action_pressed("move_right")
	var move_left = Input.is_action_pressed("move_left")
	var move_up = Input.is_action_pressed("move_up")
	var move_down = Input.is_action_pressed("move_down")
	
	#WASD gombokkal karaktermozgatás
	
	var move_w = Input.is_action_pressed("w_up")
	var move_a = Input.is_action_pressed("a_left")
	var	move_s= Input.is_action_pressed("s_down")
	var move_d = Input.is_action_pressed("d_right")
	
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var input_direction_wasd = Input.get_vector("a_left", "d_right", "w_up","s_down")
	var direction = Input.get_axis("a_left", "d_right")
	#Alapjáraton a RUN animáció-beli framek jobbra néznek, az alábbi 4 sor azt csinálja, hogy ha balra megy akkor megfordul a Player
	if direction == -1:
		character.flip_h=true
	elif direction == 1:
		character.flip_h= false
	
	
	#Jobbra balra futás megvalósítása
	if move_right || move_left || move_up || move_down :
		velocity = input_direction * SPEED
		animation.play("Run")
	elif move_a || move_d || move_s || move_w:
		velocity = input_direction_wasd * SPEED
		animation.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		animation.play("Idle")

	move_and_slide()
