extends Node2D

var entered: bool = false
var alreadySolved: bool = false
var player

var minigamePath: String
var difficulty: String
var texturePath: String
var reward: String
var keyID

var texture
var fallbackTexture
var game




signal initialized
signal minigame_solved(minigame)


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


func _make_reward():
	if reward == "Item":
		var item = load("res://GameplayThings/Items/general_scene_for_items.tscn").instantiate()
		item.position = self.position + Vector2(0, 50)
		self.get_parent().add_child(item)
	else:
		var key = load("res://GameplayThings/Key/key.tscn").instantiate()
		key.position = self.position + Vector2(0,50)
		if keyID:
			key.set_door_to_open(keyID)
		
		self.get_parent().add_child(key)


func _load_texture():
	texture = load(texturePath)
	fallbackTexture = load("res://Game Assets/MapEditor/MinigamePlaces/LARGE_BOOKCASE_BIRCH.png")
	if texture == null:
		texture = fallbackTexture

	$MinigameButton.texture_normal = texture
	

func _process(delta):
	var overlappingBodies = $Area2D.get_overlapping_bodies()

	if overlappingBodies.size() > 0:
		for body in overlappingBodies:
			if body.is_in_group("Enemy") || body.is_in_group("Player"):
				if body.is_in_group("Player"):
					player = body
				if body.position.y > self.get_global_position().y + texture.get_height()/2 - 10:
					body.z_index = 100
					self.z_index = 99
				else:
					body.z_index = 99
					self.z_index = 100


func _load_and_add_minigame():
	game = load(minigamePath).instantiate()
	game.difficulty = difficulty
	game.minigame_completed.connect(on_minigame_solved) 


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		entered = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		entered = false
		player = body
		
		get_tree().paused = false
		if player.get_node("Camera2D/MinigameLayer").visible:
			player.get_node("Camera2D/MinigameLayer").visible = false
			player.get_node("Camera2D/MinigameLayer").remove_child(game)
		

func _on_minigame_button_pressed():
	print("pressing")
	print(get_tree().paused)
	if entered and not alreadySolved and player and not get_tree().paused:
		if player.get_node("Camera2D/MinigameLayer"):
			player.get_node("Camera2D/MinigameLayer").visible = true
			player.get_node("Camera2D/MinigameLayer").add_child(game)
			if difficulty == "medium" or difficulty == "hard" or minigamePath == "res://MiniGames/Labrynth/labrynth.tscn" or "res://MiniGames/Maze/maze.tscn":
				get_tree().paused = true
				
	elif get_tree().paused:
		get_tree().paused = false
		player.get_node("Camera2D/MinigameLayer").visible = false
		player.get_node("Camera2D/MinigameLayer").remove_child(game)
		

func on_minigame_solved():
	if player.get_node("Camera2D/MinigameLayer"):
		player.get_node("Camera2D/MinigameLayer").visible = false
		player.get_node("Camera2D/MinigameLayer").remove_child(game)
		minigame_solved.emit(self)
		alreadySolved = true
		get_tree().paused = false
		_make_reward()


	
