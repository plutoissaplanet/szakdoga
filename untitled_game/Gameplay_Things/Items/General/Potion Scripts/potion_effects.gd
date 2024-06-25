extends Sprite2D

@export var POTION: ITEM
@export var player: PLAYER
@onready var timer = get_node("Timer")
var potion
var originalSpeed
var originalAttackPoints


enum {
	HEALTH_POTIONS,
	ATTACK_POTION,
	SPEED_POTION
}

func _ready():
	if POTION:
		texture = POTION.ITEM_TEXT
		potion=get_potion_class(POTION)
	else:
		printerr("texture not found.")
		
	if player.consumed_potion:
		match potion:
			HEALTH_POTIONS:
				drink_health_potion(POTION.HEALTH_RESTORED)
			ATTACK_POTION:
				drink_attack_potion(POTION.ATTACK_BONUS)
			SPEED_POTION:
				drink_speed_potion(POTION.SPEED_BONUS)
		

func get_potion_class(poti):
	var classtype
	if poti is HEALTH_POTIONS:
		classtype=HEALTH_POTIONS
	elif poti is ATTACK_POTION:
		classtype=ATTACK_POTION
	elif poti is SPEED_POTION:
		classtype=SPEED_POTION
		
	return classtype
	
func drink_health_potion(bonus: int):
	print("player hp: ",player.stats.HealthPoints)
	if player.stats.HealthPoints == 100:
		print("max hp")
	else:
		var addedHealth = (player.MAX_HEALTH_POINTS * bonus / 100)
		if (addedHealth+player.stats.HealthPoints) > 100:
			player.stats.HealthPoints = player.MAX_HEALTH_POINTS
			player.health_bar.value=player.stats.HealthPoints
		else:
			player.stats.HealthPoints += addedHealth
			player.health_bar.value=player.stats.HealthPoints

func drink_attack_potion(bonus: int):
	originalAttackPoints = player.stats.AttackPoints
	player.stats.AttackPoints += (player.stats.AttackPoints*bonus/100) 

func drink_speed_potion(bonus: int):
	originalSpeed= player.SPEED
	player.SPEED+=player.SPEED*bonus/100
	timer.start()
	
func _on_timer_timeout():
	if potion == SPEED_POTION:
		player.SPEED = originalSpeed
	else:
		player.stats.AttackPoints = originalAttackPoints
