extends Node2D

signal minigame_completed
var difficulty

var character
var diamond

var positions = {}

var mazeSizes = {
	'easy': Vector2i(4,4),
	'medium': Vector2i(6,6),
	'hard': Vector2i(10,10)
}

var numberOfObstacles = {
	"easy": 3,
	"medium": 10,
	'hard': 25
}


var stepCounter
var mazeMatrix = []
var shortest
var astar = AStar2D.new()


func _ready():
	_generate_matrix()
	_select_special_positions()
	_place_tiles()

func _process(delta):
	if Input.is_action_just_pressed("move_up"):
		_character_movement('up')
	elif Input.is_action_just_pressed("move_right"):
		_character_movement('right')
	elif Input.is_action_just_pressed("move_down"):
		_character_movement('down')
	elif Input.is_action_just_pressed("move_left"):
		_character_movement('left')

func _generate_matrix():
	var size = mazeSizes.get(difficulty)
	
	for y in range(0, size.y):
		var innerArray = []
		innerArray.resize(size.x)
		innerArray.fill(0)
		mazeMatrix.append(innerArray)
	
func _special_places(isObject = false):
	var randomRow 
	var randomCol 
	
	if isObject:
		randomRow = randi_range(1, mazeSizes.get(difficulty).y-2) 
		randomCol = randi_range(1, mazeSizes.get(difficulty).x-2)
		while mazeMatrix[randomRow][randomCol] != 0:
			randomCol = randi_range(1, mazeSizes.get(difficulty).x-2)
	else:
		randomRow = randi_range(0, mazeSizes.get(difficulty).y-1) 
		randomCol = randi_range(0, mazeSizes.get(difficulty).x-1)
		while mazeMatrix[randomRow][randomCol] != 0:
			randomCol = randi_range(0, mazeSizes.get(difficulty).x-1)
		
	return Vector2i(randomRow, randomCol)

func _select_special_positions():
	var finishPos = _special_places()
	mazeMatrix[finishPos.x][finishPos.y] = 3
	_add_object(finishPos, "res://MiniGames/Maze/finish.png")
	positions['finish'] = finishPos
	
	var mazeSizeX = mazeSizes.get(difficulty).x
	var mazeSizeY = mazeSizes.get(difficulty).y
	
	var objectPos = _special_places(true)
	while objectPos == Vector2i(0,0) or objectPos == Vector2i(0,mazeSizeY) or objectPos == Vector2i(mazeSizeX, 0) or objectPos == Vector2i(mazeSizeX, mazeSizeY):
		objectPos = _special_places()
	mazeMatrix[objectPos.x][objectPos.y] = 4
	_add_object(objectPos, "res://MiniGames/Maze/diamond.png")
	positions['diamond'] = objectPos
	_select_obstacle_positions(objectPos, finishPos, objectPos)
	 
	while true:
		var charPos = _special_places()
		mazeMatrix[charPos.x][charPos.y] = 2
		if BFS.bfs(charPos, finishPos, mazeMatrix, mazeSizes.get(difficulty)):
			_add_object(charPos, "res://MiniGames/Maze/Idle_000.png", true)
			positions['character'] = charPos
			break
		else:
			mazeMatrix[charPos.x][charPos.y] = 0
			
func _select_obstacle_positions(starterPoint, finishPoint, objectPos):
	var obstacleNumber = numberOfObstacles.get(difficulty)
	var attempts = 0
	for i in range(0, obstacleNumber -1 ):
		while true:
			var obstaclePos = _special_places()
			mazeMatrix[obstaclePos.x][obstaclePos.y] = 1
			if _is_neighbouring_object(obstaclePos):
				mazeMatrix[obstaclePos.x][obstaclePos.y] = 0
				continue
				
			if BFS.bfs(starterPoint, finishPoint, mazeMatrix, mazeSizes.get(difficulty),objectPos):
#startPoint: Vector2i, finishPoint: Vector2i, matrix ,objectPos = null, size = null
				break
			else:
				mazeMatrix[obstaclePos.x][obstaclePos.y] = 0


func _is_neighbouring_object(pos):
	for direction in BFS.eightDirections:
		var neighbor = pos + direction
		if BFS.is_in_bounds(neighbor, mazeSizes.get(difficulty)):
			if mazeMatrix[neighbor.x][neighbor.y] == 4: 
				return true
	return false


func _place_tiles():
	var tilePosition = Vector2i(0,0)
	
	for row in mazeMatrix:
		for col in row:
			if col == 0 or col == 1:
				$TileMap.set_cell(0, $TileMap.local_to_map(tilePosition), col, Vector2i(0,0))
			else:
				$TileMap.set_cell(0, $TileMap.local_to_map(tilePosition), 0, Vector2i(0,0))
			tilePosition = Vector2i(tilePosition.x,tilePosition.y+32)
		tilePosition = Vector2i(tilePosition.x+32, 0)
		

func _add_object(charPos, texturePath, isPlayer = false):
	var texture = load(texturePath)
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.scale = Vector2(32,32) / Vector2(texture.get_width(), texture.get_height())
	sprite.position = charPos * Vector2i(32,32) + Vector2i(16,16)
	if isPlayer:
		character = sprite
	else:
		diamond = sprite
	add_child(sprite)
	
func _character_movement(direction: String):
	var dir = BFS.directionsDictionary.get(direction)
	var charPos = positions.get('character')
	var size = mazeSizes.get(difficulty)
	
	var newPos = charPos + dir
	
	if BFS.is_in_bounds(newPos, size) and (mazeMatrix[newPos.x][newPos.y] == 0 or mazeMatrix[newPos.x][newPos.y] == 3):
		character.position = newPos * Vector2i(32, 32) + Vector2i(16,16)
		positions['character'] = newPos
		mazeMatrix[charPos.x][charPos.y] = 0
		mazeMatrix[newPos.x][newPos.y] = 2
	elif (mazeMatrix[newPos.x][newPos.y] == 4 and BFS.is_in_bounds(newPos+dir, size)):
		var diamondPos = positions.get('diamond')
		var newDiamondPos = diamondPos + dir
		character.position = newPos * Vector2i(32, 32) + Vector2i(16,16)
		diamond.position = newDiamondPos * Vector2i(32, 32) + Vector2i(16,16)
		_check_win(newDiamondPos)
		
		positions['character'] = newPos
		positions['diamond'] = newDiamondPos
		
		mazeMatrix[charPos.x][charPos.y] = 0
		mazeMatrix[newPos.x][newPos.y] = 2
		
		mazeMatrix[diamondPos.x][diamondPos.y] = 0
		mazeMatrix[newDiamondPos.x][newDiamondPos.y] = 4
		

func _check_win(diamondPos):
	var finishPos = positions.get('finish')
	if diamondPos == finishPos:
		minigame_completed.emit()
		


