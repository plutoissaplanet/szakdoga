extends ProgressBar

class_name HealthBar
var player

@onready var bar = get_node(".")

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_loss(player)


func health_loss(player):
	bar.value=player.stats.HealthPoints
