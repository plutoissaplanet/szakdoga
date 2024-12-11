extends Node2D

var difficulty: String
signal minigame_completed

var mazeMatrix = []
var mazeSizes = {
	'easy': Vector2i(4,4),
	'medium': Vector2i(6,6),
	'hard': Vector2i(10,10)
}
var size

var positions = {
	'character': Vector2(1,1),
	'finish': null
}

var character

func _ready():
	difficulty = 'medium'
	size = mazeSizes.get(difficulty)
	positions['finish'] = Vector2(size.x * 2 , size.y * 2 )
	_generate_labyrinth_matrix()
	mazeMatrix = BFS.generate_maze(mazeMatrix, Vector2i(1,1), Vector2i(size.x * 2 , size.y * 2 ), mazeSizes.get(difficulty))
	_place_cells()
	_place_sprites()


func _process(delta):
	if Input.is_action_just_pressed("move_up"):
		_character_movement('up')
	elif Input.is_action_just_pressed("move_right"):
		_character_movement('right')
	elif Input.is_action_just_pressed("move_down"):
		_character_movement('down')
	elif Input.is_action_just_pressed("move_left"):
		_character_movement('left')


func _generate_labyrinth_matrix():
	for y in range(0, size.y * 2 + 1):
		var innerArray = []
		innerArray.resize(size.x * 2 + 1)
		innerArray.fill(1)
		mazeMatrix.append(innerArray)

func _place_cells():
	var tilePosition = Vector2i(0,0)
	for row in mazeMatrix:
		for col in row:
			$TileMap.set_cell(0, $TileMap.local_to_map(tilePosition), col, Vector2i(0, 0))
			tilePosition = Vector2i(tilePosition.x,tilePosition.y+32)
		tilePosition = Vector2i(tilePosition.x+32, 0)

func _place_sprites():
	var playerSprite = Sprite2D.new()
	var finishSprite = Sprite2D.new()
	
	var playerTexture = load("res://MiniGames/Maze/Idle_000.png")
	var finishTexture = load("res://MiniGames/Maze/finish.png")
	
	playerSprite.texture = playerTexture
	finishSprite.texture = finishTexture
	
	playerSprite.scale = Vector2(32,32) / Vector2(playerTexture.get_width(), playerTexture.get_height())
	finishSprite.scale = Vector2(32,32) / Vector2(finishTexture.get_width(), finishTexture.get_height())
	
	playerSprite.position = Vector2i(1,1) * Vector2i(32, 32) + Vector2i(16,16)
	finishSprite.position = Vector2i(size.x * 2 , size.y * 2 ) * Vector2i(32, 32) - Vector2i(16,16)
	
	character = playerSprite
	
	add_child(playerSprite)
	add_child(finishSprite)
	

func _character_movement(direction: String):
	var dir = BFS.directionsDictionary.get(direction) as Vector2
	var charPos = positions.get('character')
	var size = mazeSizes.get(difficulty) * 2 + Vector2i(1, 1)
	
	var newPos = charPos + dir
	
	if BFS.is_in_bounds(newPos, size) and (mazeMatrix[newPos.x][newPos.y] == 0 or mazeMatrix[newPos.x][newPos.y] == 3):
		character.position = newPos * Vector2(32, 32) + Vector2(16,16)
		positions['character'] = newPos
		mazeMatrix[charPos.x][charPos.y] = 0
		mazeMatrix[newPos.x][newPos.y] = 2
		_check_win(character.position)
		

func _check_win(charPos):
	var finishPos = positions.get('finish') * Vector2(32, 32)
	print(finishPos)
	print(charPos)
	if charPos + Vector2(16,16) == finishPos:
		minigame_completed.emit()
		print("finished")
