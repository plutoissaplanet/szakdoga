extends CharacterBody2D

class_name PLAYER


@export var MAX_HEALTH_POINTS = 100
signal consumed_potion #this signal need to be hooked up to the potions in the inventory, so when the player wants to consume the potion, this signal is emitted
signal game_won
# Get the gravity from the project settings to be synced with RigidBody nodes.
var  deathScreen = load("res://GameplayThings/Death Screen/death_screen.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var enemyArea = get_node("EnemyAttackArea")
@onready var attackEnemy = get_node("AttackTheEnemyArea")
@onready var character = get_node("AnimatedSprite2D")
@onready var animationPlayer = $AnimationPlayer
@onready var healthBar = get_node("HealthBar/ProgressBar")
@onready var animationTree = $AnimationTree
@onready var inventory = $Inventory
@onready var overlappingProjectileHitArea = $IdleAndRangedEnemyDetectArea
var animationMachine = AnimationMachine.new()
var ENEMY_CONDITIONS = {}
var PLAYER_CONDITIONS = {}
var state
var SPEED
var totalHealth: int
var playerConfig = PlayerConfig.new()

var mapDifficulty: String
var notOwnMap: bool

var speedBonus
var attackBonus


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
	game_won.connect(_game_won)
	consumed_potion.connect(_potion_consumed)
	
	var parent = get_parent()
	if parent:
		if parent.mapDifficulty and parent.notOwnMap:
			mapDifficulty = parent.mapDifficulty
			notOwnMap = parent.notOwnMap


func _process(event):
	if not $Timer2Container/AttackTimer.is_stopped():
		$Timer2Container/GridContainer/AttackTimer.text = str($Timer2Container/AttackTimer.time_left).left(2)
	if not $Timer2Container/SpeedTimer.is_stopped():
		$Timer2Container/GridContainer/SpeedTimer.text = str($Timer2Container/SpeedTimer.time_left).left(2)
		
	match state:
			IDLE:
				_set_state("idle", PLAYER_CONDITIONS.playerIdle)
				if stats.HealthPoints <=0:
					state=DEATH
			WALK:
				_set_state("walk", PLAYER_CONDITIONS.playerWalk)
			ATTACK:
				_set_state("attack", PLAYER_CONDITIONS.playerAttack)
			HURT:
				_set_state("hurt", PLAYER_CONDITIONS.playerHurt)
				if stats.HealthPoints <=0:
					state=DEATH
			DEATH:
				_set_state("death", PLAYER_CONDITIONS.playerDead)
				if animationTree.get("parameters/playback").get_current_node() == "End":
					get_tree().paused=true
					var deathScreenInstance = deathScreen.instantiate()
					deathScreenInstance.z_index=100
					deathScreenInstance.position.y-=100
					if notOwnMap:
						deathScreenInstance.display_points(REQUIREMENTS.map_values.get(mapDifficulty).get("deduct"), UserData.totalPoints - REQUIREMENTS.map_values.get(mapDifficulty).get("deduct"))
						POINTS_MANAGER.deduct_points(REQUIREMENTS.map_values.get(mapDifficulty).get("deduct"))
					self.add_child(deathScreenInstance)
			
			
	healthBar.value=stats.HealthPoints
	var overlappingBodies = $AttackTheEnemyArea.get_overlapping_bodies()
	var overlappingBodiesAttack= $EnemyAttackArea.get_overlapping_bodies()
	var overlappingBodiesRangedAttacker = $IdleAndRangedEnemyDetectArea.get_overlapping_bodies()
	
	
	for body in overlappingBodies:
		if body.is_in_group("Enemy"):
			if body.state_machine.stats.HealthPoints > 0:
				attack_enemy(body)
	for body in overlappingBodiesAttack:
		if body.is_in_group("Melee"):
			if not body.get_meta("timer_started"):
				body.timer.start()
				body.set_meta("timer_started", true)
				body.animationTree.set(ENEMY_CONDITIONS.enemyIsIdle, true)
				body.animationTree.set(ENEMY_CONDITIONS.enemyWalking, false)
	for body in overlappingBodiesRangedAttacker:
		if body.is_in_group("Ranged"):
			body.state_machine.SPEED=0;
			if not body.get_meta("timer_started"):
				body.timer.start()
				body.set_meta("timer_started", true)
				body.animationTree.set(ENEMY_CONDITIONS.enemyIsIdle, true)
				body.animationTree.set(ENEMY_CONDITIONS.enemyWalking, false)
	for body in overlappingBodiesAttack:
		if body.is_in_group("Ranged") or body.is_in_group("Enemy"):
			if body.position > position:
				body.z_index = 100
			else:
				body.z_index = 9


func _set_up_animations():
	var animationMaker = ANIMATION_MAKER.new()
	
	print("UserData.characterType: ", UserData.characterType)
	if UserData.characterType != null:
		await animationMaker.make_animation('Player/Assets', UserData.characterType, UserData.character, 0.07, 'AnimatedSprite2D:texture', animationPlayer, 'playerLibrary', $AnimatedSprite2D)
	else:
		await animationMaker.make_animation('Player/Assets', UserData.fallbackCharacterType, UserData.fallbackCharacter, 0.07, 'AnimatedSprite2D:texture', animationPlayer, 'playerLibrary', $AnimatedSprite2D)
	animationMaker.add_points_to_blendspace(animationTree, 'playerLibrary/', animationPlayer )

func _set_state(newState: String, condition: String):
	for key in PLAYER_CONDITIONS.keys():
		if PLAYER_CONDITIONS[key] != condition:
			animationTree.set(PLAYER_CONDITIONS[key], false)
	animationTree.set(condition, true)
	state = newState

func _physics_process(_delta):
	

	var move_w = Input.is_action_pressed("w_up")
	var move_a = Input.is_action_pressed("a_left")
	var move_s= Input.is_action_pressed("s_down")
	var move_d = Input.is_action_pressed("d_right")
	
	var input_direction_wasd = Input.get_vector("a_left", "d_right", "w_up","s_down")
	var direction_wasd = Input.get_axis("a_left", "d_right")
	var direction = Input.get_axis("move_left", "move_right")
	#Alapjáraton a RUN animáció-beli framek jobbra néznek, az alábbi 4 sor azt csinálja, hogy ha balra megy akkor megfordul a Player
	if direction == -1 || direction_wasd == -1:
		character.flip_h=true
	elif direction == 1 || direction_wasd == 1:
		character.flip_h= false
	#Jobbra balra futás megvalósítása
	if move_a || move_d || move_s || move_w:
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

func _game_won():
	var deathScreenInstance = deathScreen.instantiate()
	deathScreenInstance.z_index=100
	deathScreenInstance.position.y-=100
	if notOwnMap:
		deathScreenInstance.display_points(REQUIREMENTS.map_values.get(mapDifficulty).get("add"), UserData.totalPoints + REQUIREMENTS.map_values.get(mapDifficulty).get("add"))
		POINTS_MANAGER.add_points(REQUIREMENTS.map_values.get(mapDifficulty).get("add"))
	self.add_child(deathScreenInstance)
	deathScreenInstance.set_up_winner_screen()
	
func _potion_consumed(potion):
	
	$Timer2Container.visible = true
	
	if potion is HEALTH_POTIONS:
		stats.HealthPoints += potion.HEALTH_RESTORED
	elif potion is ATTACK_POTION:
		$Timer2Container/AttackTimer.start()
		stats.AttackPoints += potion.ATTACK_BONUS
		attackBonus = potion.ATTACK_BONUS
	else:
		$Timer2Container/SpeedTimer.start()
		SPEED += potion.SPEED_BONUS
		speedBonus = potion.SPEED_BONUS
		

func _on_attack_timer_timeout():
	$Timer2Container/GridContainer/AttackTimer.visible = false
	SPEED -= speedBonus
	speedBonus = 0

func _on_speed_timer_timeout():
	$Timer2Container/GridContainer/SpeedTimer.visible = false
	stats.AttackPoints -= attackBonus
	attackBonus = 0
	
