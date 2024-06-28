extends CharacterBody2D

class_name PLAYER

@export var SPEED = 180.0
@export var MAX_HEALTH_POINTS = 100
signal consumed_potion #this signal need to be hooked up to the potions in the inventory, so when the player wants to consume the potion, this signal is emitted

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var enemyArea = get_node("EnemyAttackArea")
@onready var attackEnemy = get_node("AttackTheEnemyArea")
@onready var character = get_node("AnimatedSprite2D")
@onready var animation = get_node("AnimationPlayer")
@onready var health_bar = get_node("HealthBar/ProgressBar")
@onready var animationTree = $AnimationTree
@onready var player=get_node(".")
var animationMachine = AnimationMachine.new()
var ENEMY_CONDITIONS
var PLAYER_CONDITIONS
var state
@export var inventory : Inventory
@export var stats = Statistics


enum {
	WALK,
	ATTACK,
	IDLE,
	DEATH
}

func _ready():
	stats.HealthPoints = 50
	stats.AttackPoints= 30
	health_bar.value=100
	health_bar.player=player
	ENEMY_CONDITIONS=animationMachine.ENEMY_CONDITIONS
	PLAYER_CONDITIONS=animationMachine.PLAYER_CONDITIONS
	
func _process(delta):
	
	match (state):
		WALK:
			SPEED = 180.0
			animationTree.set(PLAYER_CONDITIONS.playerIdle, false)
			animationTree.set(PLAYER_CONDITIONS.playerWalk, true)
		IDLE:
			animationTree.set(PLAYER_CONDITIONS.playerWalk, false)
			animationTree.set(PLAYER_CONDITIONS.playerIdle, true)
			animationTree.set(PLAYER_CONDITIONS.playerAttack, false)
		ATTACK:
			animationTree.set(PLAYER_CONDITIONS.playerAttack, true)
			SPEED = 0
		DEATH:
			animationTree.set(PLAYER_CONDITIONS.playerDead, true)
			SPEED = 0
			
			
	health_bar.value=stats.HealthPoints
	var overlapping_bodies = attackEnemy.get_overlapping_bodies()
	var overlapping_bodies_attack= enemyArea.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("Enemy"):
			if body.state_machine.stats.HealthPoints > 0:
				attack_enemy(body)
	for body in overlapping_bodies_attack:
		if body.is_in_group("Enemy"):
			body.state_machine.SPEED=0;
			if not body.get_meta("timer_started"):
				body.timer.start()
				body.set_meta("timer_started", true)
				body.animationTree.set(ENEMY_CONDITIONS.enemyIsIdle, true)
				body.animationTree.set(ENEMY_CONDITIONS.enemyWalking, false)
			
func _physics_process(_delta):
	#Fel-le nyilaakkal karaktermozgatás
	var move_right = Input.is_action_pressed("move_right")
	var move_left = Input.is_action_pressed("move_left")
	var move_up = Input.is_action_pressed("move_up")
	var move_down = Input.is_action_pressed("move_down")
	
	#WASD gombokkal karaktermozgatás
	
	var move_w = Input.is_action_pressed("w_up")
	var move_a = Input.is_action_pressed("a_left")
	var move_s= Input.is_action_pressed("s_down")
	var move_d = Input.is_action_pressed("d_right")
	
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var input_direction_wasd = Input.get_vector("a_left", "d_right", "w_up","s_down")
	var direction_wasd = Input.get_axis("a_left", "d_right")
	var direction = Input.get_axis("move_left", "move_right")
	#Alapjáraton a RUN animáció-beli framek jobbra néznek, az alábbi 4 sor azt csinálja, hogy ha balra megy akkor megfordul a Player
	if direction == -1 || direction_wasd == -1:
		character.flip_h=true
	elif direction == 1 || direction_wasd == 1:
		character.flip_h= false
	#Jobbra balra futás megvalósítása
	if move_right || move_left || move_up || move_down :
		velocity = input_direction * SPEED
		state=WALK
	elif move_a || move_d || move_s || move_w:
		velocity = input_direction_wasd * SPEED
		state=WALK
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		state=IDLE
	move_and_slide()
	
func pick_stuff_up(item):
	inventory.pickup(item)

func _on_enemy_attack_area_body_exited(body):
	if body.is_in_group("Enemy"):
		body.timer.stop()
		body.set_meta("timer_started", false)
		body.state_machine.SPEED=30.0;
		body.state_machine.state=body.state_machine.MOVE
		body.animationTree.set(ENEMY_CONDITIONS.enemyIsIdle, false)
		body.animationTree.set(ENEMY_CONDITIONS.enemyHurt, false)
		body.animationTree.set(ENEMY_CONDITIONS.enemyWalking, true)
		
func attack_enemy(body):
	if Input.is_action_just_pressed("room_changer_click"):
		state=ATTACK
		animationTree.set(PLAYER_CONDITIONS.playerAttack, true)
		body.animationTree.set(ENEMY_CONDITIONS.enemyHurt, true)
		body.animationTree.set(ENEMY_CONDITIONS.enemyIsIdle, false)
		body.animationTree.set(ENEMY_CONDITIONS.enemyIsAttacking, false)
		body.timer.stop()
		body.set_meta("timer_started", false)
		body.state_machine.enemy_hit(stats.AttackPoints, body)
		print(body.state_machine.stats.HealthPoints)
	
