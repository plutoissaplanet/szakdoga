extends Node2D

var entered: bool = false
var alreadySolved: bool = false
var player

var minigamePath: String
var difficulty: String
var texturePath: String
var reward: String #Should be Object

var texture
var fallbackTexture
var game


signal initialized


func initialize(_difficulty: String, _texturePath: String, _minigamePath: String, _reward: String):
	minigamePath = _minigamePath
	difficulty = _difficulty
	texturePath = _texturePath
	reward = _reward
	initialized.emit()


func _ready():
	initialized.connect(_on_ready)


func _on_ready():
	_load_and_add_minigame()
	_load_texture()
	

func _load_texture():
	texture = load(texturePath)
	fallbackTexture = load("res://Game Assets/MapEditor/MinigamePlaces/LARGE_BOOKCASE_BIRCH.png")
	if texture == null:
		texture = fallbackTexture
	print(texture)
		
	$MinigameButton.texture_normal = texture
	

func _process(delta):
	var overlappingBodies = $Area2D.get_overlapping_bodies()
	if overlappingBodies.size() > 0:
		for body in overlappingBodies:
			if body.is_in_group("Enemy") || body.is_in_group("Player"):
				if body.position.y > self.get_global_position().y + texture.get_height()/2 - 10:
					body.z_index = 100
					self.z_index = 99
				else:
					body.z_index = 99
					self.z_index = 100


func _load_and_add_minigame():
	game = load(minigamePath).instantiate()
	game.difficulty = difficulty
	game.minigame_completed.connect(_on_minigame_solved) 


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		entered = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		entered = false
		player = body
		if $Minigame.visible:
			$Minigame.visible = false
			if $Minigame.get_child_count() > 0:
				$Minigame.remove_child($Minigame.get_child(0))


func _on_minigame_button_pressed():
	if entered and not alreadySolved:
		$Minigame.visible = true
		#$Minigame.position = Vector2(376, 124)
		if $Minigame.get_child_count() == 0:
			$Minigame.add_child(game)
		

func _on_minigame_solved():
	$Minigame.visible = false
	alreadySolved = true
	#THROW THE ITEM ON THE GROUND
	
