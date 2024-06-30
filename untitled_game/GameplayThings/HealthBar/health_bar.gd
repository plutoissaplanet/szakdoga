extends ProgressBar

class_name HealthBar
var player

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_loss(player)
	
func update_total_health(newHealth:int):
	self.max_value=newHealth

func health_loss(player):
	self.value=player.stats.HealthPoints
