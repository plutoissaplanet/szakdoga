extends ITEM

class_name SWORDS

@export var ATTACK_POINTS: int

func _ready():
	SHOW_STATS=str(ATTACK_POINTS) #implement some kind of text for when the player hovers over the item, a small pop-up window will show all the details about this certain item
