extends CharacterBody2D

class_name PLAYER


@export var MAX_HEALTH_POINTS = 100
signal consumed_potion #this signal need to be hooked up to the potions in the inventory, so when the player wants to consume the potion, this signal is emitted

# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var  deathScreen = load("res://GameplayThings/Death Screen/death_screen.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var enemyArea = get_node("EnemyAttackArea")
@onready var attackEnemy = get_node("AttackTheEnemyArea")
@onready var character = get_node("AnimatedSprite2D")
@onready var animationPlayer = $AnimationPlayer
@onready var healthBar = get_node("HealthBar/ProgressBar")
@onready var animationTree = $AnimationTree
@onready var inventory = $Inventory
var animationMachine = AnimationMachine.new()
var ENEMY_CONDITIONS
var PLAYER_CONDITIONS = {
	
}
var state
var SPEED
var totalHealth: int
var playerConfig = PlayerConfig.new()
@export var stats = Statistics


enum {
	WALK,
	ATTACK,
	IDLE,
	DEATH,
	HURT
}

func _ready():

	get_tree().paused=false
	animationTree.active=true
	_set_up_animations()

	totalHealth = playerConfig.STARTER_HEALTH_POINTS
	stats.HealthPoints = playerConfig.STARTER_HEALTH_POINTS
	stats.AttackPoints= playerConfig.STARTER_ATTACK_PONTS
	SPEED= playerConfig.SPEED
	healthBar.value=totalHealth
	healthBar.player=self
	ENEMY_CONDITIONS=animationMachine.ENEMY_CONDITIONS
	PLAYER_CONDITIONS=animationMachine.PLAYER_CONDITIONS
	
func _process(event):
	match state:
			IDLE:
				_set_state("idle", PLAYER_CONDITIONS.playerIdle)
			WALK:
				_set_state("walk", PLAYER_CONDITIONS.playerWalk)
			ATTACK:
				_set_state("attack", PLAYER_CONDITIONS.playerAttack)
			HURT:
				_set_state("hurt", PLAYER_CONDITIONS.playerHurt)
			DEATH:
				_set_state("death", PLAYER_CONDITIONS.playerDead)
				if animationTree.get("parameters/playback").get_current_node() == "End":
					get_tree().paused=true
					var deathScreenInstance = deathScreen.instantiate()
					deathScreenInstance.z_index=100
					deathScreenInstance.position.y-=100
					self.add_child(deathScreenInstance)
			
			
	healthBar.value=stats.HealthPoints
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
				
func _set_up_animations():
	var animationMaker = ANIMATION_MAKER.new()
	print(UserData.characterType)
	await animationMaker.make_animation('Player/Assets', UserData.characterType, UserData.character, 0.07, 'AnimatedSprite2D:texture', animationPlayer, 'playerLibrary', $AnimatedSprite2D)
	animationMaker.add_points_to_blendspace(animationTree, 'playerLibrary/', animationPlayer )

func _set_state(new_state: String, condition: String):
	# Reset all conditions
	for key in PLAYER_CONDITIONS.keys():
		animationTree.set(PLAYER_CONDITIONS[key], false)

	# Set the new condition
	animationTree.set(condition, true)
	state = new_state

func _physics_process(_delta):
	var move_right = Input.is_action_pressed("move_right")
	var move_left = Input.is_action_pressed("move_left")
	var move_up = Input.is_action_pressed("move_up")
	var move_down = Input.is_action_pressed("move_down")

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
	inventory.pick_up_item(item)

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

		_set_state("attack", PLAYER_CONDITIONS.playerAttack)
		body.animationTree.set(ENEMY_CONDITIONS.enemyHurt, true)
		body.animationTree.set(ENEMY_CONDITIONS.enemyIsIdle, false)
		body.animationTree.set(ENEMY_CONDITIONS.enemyIsAttacking, false)
		body.timer.stop()
		body.set_meta("timer_started", false)
		body.state_machine.enemy_hit(stats.AttackPoints, body)

		
	
