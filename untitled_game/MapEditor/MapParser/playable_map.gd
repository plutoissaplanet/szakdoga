extends Node

class_name PLAYABLE_MAP_PARSER

var loadedEnemyScript = load("res://Creatures/Monsters/Skeleton.tscn")
var loadedSpawnpointScript = load("res://GameplayThings/EnemySpawnPoints/enemy_spawnpoint.tscn")
var floorTileMap: TileMap
var wallTileMap: TileMap
var boundaryTileMap: TileMap

var mapName: String
var mapFilePath: String
var jsonFilePath: String

var isOwnMap: bool = true
var mapData
var player
var DOORS_PLACED = {}
var DOORS_TO_PLACE = {}
var finalDoorOrder = []

var chestsThatNeedKeys = []
var keysThatOpenDoorsArray = []
var chestNr = 0

var minigamesThatDropKey = {}

var mapDifficulty
var notOwnMap



var minigamesPaths = {
	"Memory Game": "res://MiniGames/MemoryGame/memory_game.tscn",
	"Nanogram": "res://MiniGames/Nanogram/nanogram_cells.tscn",
	"Puzzle": "res://MiniGames/Puzzle/puzzle.tscn",
	"Simon Says": "res://MiniGames/SimonSays/simon-says.tscn",
	"Wiring": "res://MiniGames/Wiring/wiring2.tscn",
	"Maze": "res://MiniGames/Maze/maze.tscn",
	"Diamond Maze": "res://MiniGames/Labrynth/labrynth.tscn"
}

var minigameAndFurniturePositions = []

func _ready():
	var fileSegments = scene_file_path.get_basename().split("/")
	jsonFilePath = scene_file_path.split(".")[0] +".json"
	mapFilePath = scene_file_path
	mapName = fileSegments[fileSegments.size()-1]
	if mapName and mapFilePath and jsonFilePath:
		start_game(mapName, mapFilePath, jsonFilePath)

func start_game(mapName, filePath, jsonFilePath: String):
	mapData = JSON.parse_string(JSON_FILE_FUNCTIONS.load_json_file(jsonFilePath).get_as_text())
	mapDifficulty = mapData.get("difficulty")
	
	if mapData.has("notOwnMap"):
		notOwnMap = mapData.get("notOwnMap")
	else:
		notOwnMap = false
	_generate_map(filePath)
	_place_minigames()
	_generate_door_connections()
	var rooms = mapData.get("rooms")
	for room in rooms.keys() :
		_place_boundary(rooms.get(room),int(room))
	_place_doors()
	_generate_door_keys()
	_place_items()
	_place_enemies()


func _generate_map(filePath: String):
	var node = Node2D.new()
	add_child(node)
	_make_tile_maps(node)


func _make_tile_maps(node: Node2D):
	var floorTileSet = load("res://MapEditor/Requirements/floor-tile-set.tres")
	var wallTileSet = load("res://MapEditor/Requirements/wall_tile_set.tres")
	var boundaryTileSet = load("res://MapEditor/Requirements/boundary-tile-set.tres")
	
	floorTileMap = TileMap.new()
	floorTileMap.tile_set = floorTileSet
	floorTileMap.add_layer(0)
	floorTileMap.add_layer(1)
	floorTileMap.add_layer(2)
	
	wallTileMap = TileMap.new()
	wallTileMap.tile_set = wallTileSet
	wallTileMap.add_layer(0)
	wallTileMap.add_layer(1)
	
	boundaryTileMap = TileMap.new()
	boundaryTileMap.tile_set = boundaryTileSet
	boundaryTileMap.add_layer(0)
	
	floorTileMap.position = Vector2(234,186)
	wallTileMap.position = Vector2(234, 122)
	boundaryTileMap.position = Vector2(234,186)
	
	node.add_child(floorTileMap)
	node.add_child(wallTileMap)
	node.add_child(boundaryTileMap)
	
	_place_cells(node)


func _place_cells(node: Node2D):
	var tilesDictionary = mapData.get("tiles")
	
	if tilesDictionary != null:
		for key in tilesDictionary.keys():
			if key == "0" or key == "2":
				for tile in tilesDictionary.get(key):
					var pos = Vector2(int(tile.split(",")[0]),int(tile.split(",")[1]))
					var atlasCoordString = tilesDictionary.get(key).get(tile).get("atlasCoords")
					var atlasCoordinates = Vector2i(int(atlasCoordString.split(",")[0]), int(atlasCoordString.split(",")[1]))
					floorTileMap.set_cell(int(key), floorTileMap.local_to_map(pos), tilesDictionary.get(key).get(tile).get("sourceId"), atlasCoordinates)
					if key == "2":
						minigameAndFurniturePositions.append(pos)
			else:
				for tile in tilesDictionary.get(key):
					var pos = Vector2i(int(tile.split(",")[0]),int(tile.split(",")[1]))
					var atlasCoordString = tilesDictionary.get(key).get(tile).get("atlasCoords")
					var atlasCoordinates = Vector2i(int(atlasCoordString.split(",")[0]), int(atlasCoordString.split(",")[1]))
					wallTileMap.set_cell(int(key), wallTileMap.local_to_map(pos), tilesDictionary.get(key).get(tile).get("sourceId"), atlasCoordinates)
					
func _place_boundary(roomSize: String, room: int) -> void: #THIS TILEMAP WILL HAVE TO BE SAVED TO THE .TSCN TOO!!!!!!!
	var size = REQUIREMENTS.room_sizes.get(roomSize)
	var roomPosition = REQUIREMENTS.roomPositions.get(room)
	var localizeMapToTileMapPosition = boundaryTileMap.local_to_map(roomPosition) 
	const boundarySourceID = 2
	const boundaryAtlasCoords = Vector2i(0, 0)
	
	for i in range(size.y):
		boundaryTileMap.set_cell(0, Vector2i(-1, i) + localizeMapToTileMapPosition, boundarySourceID, Vector2i(0,0), TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V)
		boundaryTileMap.set_cell(0, Vector2i(size.x, i) + localizeMapToTileMapPosition, boundarySourceID, Vector2i(0,0), TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H)
	
	for i in range(size.x):
		boundaryTileMap.set_cell(0, Vector2i(i, size.y) + localizeMapToTileMapPosition, boundarySourceID, Vector2i(0,0), TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V)
		
	for i in range(size.x):
		boundaryTileMap.set_cell(0, Vector2i(i, -1) + localizeMapToTileMapPosition, boundarySourceID, Vector2i(0,0))


func _place_enemies():
	var enemies = mapData.get("enemy")
	if enemies.keys().size() != 0:
		for enemy in enemies.keys():
			if enemies.get(enemy).get("type") == "enemy":
				var enemyInstance = loadedEnemyScript.instantiate()
				var enemyDataDictionary = enemies.get(enemy).get("enemy_data")
				var enemyData = ENEMY_DATA.new(float(enemyDataDictionary.speed), enemyDataDictionary.enemyType, enemyDataDictionary.enemyVariant, enemyDataDictionary.enemyAttackType, int(enemyDataDictionary.enemyShootTime), enemyDataDictionary.enemyDifficulty, int(enemyDataDictionary.healthPoints), int(enemyDataDictionary.attackPoints))
				enemyInstance.set_enemy_data(enemyData)
				enemyInstance.player = player #UNDO THIS IF YOU WANT THE ENEMIES TO MOVE!!!!
				var posString = str(enemies.get(enemy).get("position")).replace("(", "").replace(")","").split(",")
				var pos = Vector2(float(posString[0]), float(posString[1]))
				enemyInstance.position = pos
				add_child(enemyInstance)
			else:
				var spawnPointData = enemies.get(enemy)
				var spawnPointInstance = loadedSpawnpointScript.instantiate()
				var spawnPointEnemyData = enemies.get(enemy).get("enemyData")
				var enemyData = ENEMY_DATA.new(float(spawnPointEnemyData.speed), spawnPointEnemyData.enemyType, spawnPointEnemyData.enemyVariant, spawnPointEnemyData.enemyAttackType, int(spawnPointEnemyData.enemyShootTime), spawnPointEnemyData.enemyDifficulty, int(spawnPointEnemyData.healthPoints), int(spawnPointEnemyData.attackPoints))
				spawnPointInstance.initialitze(spawnPointData.get("numberOfEnemiesToSpawn"), spawnPointData.get("timerSpeed"),enemyData, player)
				var pos = _convert_position_string_to_vector(spawnPointData.get("position"))
				spawnPointInstance.position = pos
				add_child(spawnPointInstance)




func _place_minigames():
	var minigames = mapData.get("minigames")
	var minigamePlace = load("res://GameplayThings/MiniGameLocations/minigame-location.tscn")
	for minigame in minigames.keys():
		var minigameInstance = minigamePlace.instantiate()
		var currentMinigame = minigames.get(minigame)

		minigameInstance.position = _convert_position_string_to_vector(currentMinigame.get("position"))
		minigameAndFurniturePositions.append(minigameInstance.position)
		add_child(minigameInstance)
		minigameInstance.initialize(currentMinigame.get("difficulty"), currentMinigame.get("texturePath"), minigamesPaths.get(currentMinigame.get("minigame_name")), currentMinigame.get("reward"))
		minigameInstance.minigame_solved.connect(_miniames_completed)
		if currentMinigame.get("reward") == "Key":
			minigamesThatDropKey[minigameInstance] = currentMinigame.get("room")


func _get_random_coordinate_for_placeables(room):
	var roomStarterPositionX = REQUIREMENTS.roomPositions.get(room).x + 234 + 50
	var roomStarterPositionY = REQUIREMENTS.roomPositions.get(room).y +186 + 50
	var roomEndPositionX = (REQUIREMENTS.roomPositions.get(room) + REQUIREMENTS.room_sizes.get(mapData.get("rooms").get(str(room))) * Vector2i(32, 32)).x + 234 - 50
	var roomEndPositionY = (REQUIREMENTS.roomPositions.get(room) + REQUIREMENTS.room_sizes.get(mapData.get("rooms").get(str(room)))* Vector2i(32, 32)).y + 186 - 50
		
	var randomPosX = randi_range(roomStarterPositionX, roomEndPositionX)
	var randomPosY = randi_range(roomStarterPositionY, roomEndPositionY)
	var randomPos = Vector2i(randomPosX, randomPosY)
		
	if minigameAndFurniturePositions.has(randomPos):
		while minigameAndFurniturePositions.has(randomPos):
			randomPosX = randi_range(roomStarterPositionX, roomEndPositionX)
			randomPosY = randi_range(roomStarterPositionY, roomEndPositionY)
			randomPos = Vector2i(randomPosX, randomPosY)
			
	return randomPos


func _place_chests():
	var assignedToRoom
	var booleans = [true, false]
	var rooms: Array = mapData.get("rooms").keys()
	
	var chestScene = load("res://GameplayThings/Chests/chest_gen.tscn")
	assignedToRoom = rooms.pick_random()
	var chest = chestScene.instantiate()
	var pos: Vector2i = _get_random_coordinate_for_placeables(int(assignedToRoom))
	
	for obstacle in minigameAndFurniturePositions:
		if abs(pos - Vector2i(obstacle)) < Vector2i(40,40):
			while abs(pos - Vector2i(obstacle)) < Vector2i(40,40):
				pos = _get_random_coordinate_for_placeables(int(assignedToRoom))
		else:
			chest.position = pos
			
	add_child(chest)
	chest.name = "CHEST_NR_" + str(chestNr)
	chest.ID = "CHEST_NR_" + str(chestNr)
	chestsThatNeedKeys.append(chest.name)
	chest.make_item("item")
	chestNr += 1
	minigameAndFurniturePositions.append(chest.position)




func _place_items():
	var itemScene = load("res://GameplayThings/Items/general_scene_for_items.tscn")
	var difficulty = mapDifficulty
	var numberOfItemsToPlace = REQUIREMENTS.number_of_items_based_on_difficutly.get(difficulty) - chestNr
	var minigameItemsNumber = 0
	var totalMinigamesToPlace
	var rooms: Array = mapData.get("rooms").keys()
	var assignedItemsToRooms = []
	
	var roomStarterPositionX
	var roomStarterPositionY
	var roomEndPositionX
	var roomEndPositionY

	
	for minigame in mapData.get("minigames").keys():
		if mapData.get("minigames").get(minigame).get("reward") == "item":
			minigameItemsNumber += 1
		
	totalMinigamesToPlace = numberOfItemsToPlace - minigameItemsNumber
	
	for i in range(totalMinigamesToPlace):
		assignedItemsToRooms.append(int(rooms.pick_random()))
	
	for room in assignedItemsToRooms:
		var item = itemScene.instantiate()
		var pos = _get_random_coordinate_for_placeables(room)
		for obstacle in minigameAndFurniturePositions:
			if abs(pos - Vector2i(obstacle)) < Vector2i(40,40):
				while abs(pos - Vector2i(obstacle)) < Vector2i(40,40):
					pos = _get_random_coordinate_for_placeables(int(room))
			else:
				item.position = pos
			
		item.scale = Vector2(0.5, 0.5)
		add_child(item)


func _place_player(starterRoomPosition, starterRoomSize):
	player = load("res://Creatures/Player/Player.tscn").instantiate()
	player.position = starterRoomPosition + starterRoomSize 
	add_child(player)
	
func _convert_position_string_to_vector(posString: String) -> Vector2:
	var pos: Vector2
	var string = posString.replace("(", "").replace(")","").split(",")
	pos = Vector2(float(string[0]), float(string[1]))
	return pos

func _generate_door_connections():
	var doors = []
	var middleDoors = []
	var edgeDoors = []
	var rooms: Array = mapData.get("rooms").keys()
	
	if rooms.size() > 1:
		for room in rooms:
			doors.append(int(room))
			middleDoors.append(int(room))
			edgeDoors.append(int(room))
			DOORS_TO_PLACE[int(room)]={}
			
		var starterRoom = edgeDoors.pick_random()
		edgeDoors.erase(starterRoom)
		middleDoors.erase(starterRoom)
		
		_place_player(REQUIREMENTS.roomPositions.get(starterRoom), REQUIREMENTS.room_sizes.get(mapData.get("rooms").get(str(starterRoom))) * Vector2i(32, 32))
		
		var endRoom = edgeDoors.pick_random()
		edgeDoors.erase(starterRoom)
		middleDoors.erase(endRoom)

		while finalDoorOrder.size() != doors.size()-2:
			var random = middleDoors.pick_random()
			finalDoorOrder.append(random)
			middleDoors.erase(random)
			
		finalDoorOrder.insert(0, starterRoom)
		finalDoorOrder.append(endRoom)

		for door in finalDoorOrder:
			if door == starterRoom:
				DOORS_TO_PLACE.get(door)["pointsTo"] = finalDoorOrder[finalDoorOrder.find(door)+1]
			elif door == endRoom:
				DOORS_TO_PLACE.get(door)["pointsFrom"] = finalDoorOrder[finalDoorOrder.find(door)-1]
			else:
				DOORS_TO_PLACE.get(door)["pointsTo"] = finalDoorOrder[finalDoorOrder.find(door)+1]
				DOORS_TO_PLACE.get(door)["pointsFrom"] = finalDoorOrder[finalDoorOrder.find(door)-1]
				
		


func _place_doors(): #MAKE ONE LAST DOOR THAT IS FOR WHEN THE PLAYER WINS
	var doorScene = load("res://GameplayThings/Doors/door.tscn")
	var roomSizes = mapData.get("rooms")

	for room in DOORS_TO_PLACE.keys():
		var currentRoom = DOORS_TO_PLACE.get(room)
		if currentRoom.has("pointsFrom") and currentRoom.has("pointsTo"):
			var toDoorInstance = doorScene.instantiate()
			var fromDoorInstance = doorScene.instantiate()
			
			toDoorInstance.position = REQUIREMENTS.to_door_positions_in_rooms.get(roomSizes.get(str(room))) + REQUIREMENTS.roomPositions.get(room) +  Vector2i(218,0) - Vector2i(0,24)
			fromDoorInstance.position = REQUIREMENTS.from_door_positions_in_rooms.get(roomSizes.get(str(room))) + REQUIREMENTS.roomPositions.get(room) +  Vector2i(218,0) - Vector2i(0,24)
			
			toDoorInstance.positionToTeleportTo = REQUIREMENTS.roomPositions.get(currentRoom.get("pointsTo")) + Vector2i(234, 0) + REQUIREMENTS.from_door_positions_in_rooms.get(roomSizes.get(str(currentRoom.get("pointsTo"))))
			fromDoorInstance.positionToTeleportTo = REQUIREMENTS.roomPositions.get(currentRoom.get("pointsFrom")) + Vector2i(234, 0) + REQUIREMENTS.to_door_positions_in_rooms.get(roomSizes.get(str(currentRoom.get("pointsFrom"))))
			
			
			toDoorInstance.ID = "toDoor_" + str(room)
			fromDoorInstance.ID = "fromDoor_" + str(room)
			
			toDoorInstance.name = "toDoor_" + str(room)
			fromDoorInstance.name = "fromDoor_" + str(room)
			
			fromDoorInstance.GO_BACK_DOOR = true
			
			DOORS_PLACED[toDoorInstance.name] = currentRoom.get("pointsTo")

			
			add_child(toDoorInstance)
			add_child(fromDoorInstance)
			
			boundaryTileMap.set_cell(0, Vector2i(REQUIREMENTS.from_door_positions_in_rooms.get(roomSizes.get(str(room))).x/32, -1)+ REQUIREMENTS.roomPositions.get(room)/32- Vector2i(1,0), -1, Vector2i(-1,-1))
			boundaryTileMap.set_cell(0, Vector2i(REQUIREMENTS.to_door_positions_in_rooms.get(roomSizes.get(str(room))).x/32, -1)+ REQUIREMENTS.roomPositions.get(room)/32 - Vector2i(1,0), -1, Vector2i(-1,-1))
		
		elif currentRoom.has("pointsFrom"):
			var fromDoorInstance = doorScene.instantiate()
			fromDoorInstance.position = REQUIREMENTS.from_door_positions_in_rooms.get(roomSizes.get(str(room))) + REQUIREMENTS.roomPositions.get(room)+  Vector2i(218,0)- Vector2i(0,24)
			fromDoorInstance.positionToTeleportTo = REQUIREMENTS.roomPositions.get(currentRoom.get("pointsFrom")) + Vector2i(234, 0) + REQUIREMENTS.to_door_positions_in_rooms.get(roomSizes.get(str(currentRoom.get("pointsFrom"))))  
			fromDoorInstance.ID = "fromDoor_" + str(room)
			fromDoorInstance.name = "fromDoor_" + str(room)
			fromDoorInstance.GO_BACK_DOOR = true
			
			var exitRoom = doorScene.instantiate()
			exitRoom.position = REQUIREMENTS.to_door_positions_in_rooms.get(roomSizes.get(str(room))) + REQUIREMENTS.roomPositions.get(room)+  Vector2i(218,0)- Vector2i(0,24)
			exitRoom.FINAL_DOOR = true
			exitRoom.ID = "FINAL_DOOR"
			exitRoom.name = "FINAL_DOOR"
			
			DOORS_PLACED[exitRoom.name] = "FINAL_DOOR"
			
			add_child(fromDoorInstance)
			add_child(exitRoom)
			
			boundaryTileMap.set_cell(0,Vector2i(REQUIREMENTS.from_door_positions_in_rooms.get(roomSizes.get(str(room))).x/32, -1)+ REQUIREMENTS.roomPositions.get(room)/32- Vector2i(1,0), -1, Vector2(-1,-1))
		else:
			var toDoorInstance = doorScene.instantiate()
			toDoorInstance.position = REQUIREMENTS.to_door_positions_in_rooms.get(roomSizes.get(str(room))) + REQUIREMENTS.roomPositions.get(room) +  Vector2i(218,0) - Vector2i(0,24)
			toDoorInstance.positionToTeleportTo = REQUIREMENTS.roomPositions.get(currentRoom.get("pointsTo")) + Vector2i(234, 0) + REQUIREMENTS.from_door_positions_in_rooms.get(roomSizes.get(str(currentRoom.get("pointsTo")))) 
			toDoorInstance.ID = "toDoor_" + str(room)
			toDoorInstance.name = "toDoor_" + str(room)
			
			DOORS_PLACED[toDoorInstance.name] = currentRoom.get("pointsTo")
			
			add_child(toDoorInstance)
			
			boundaryTileMap.set_cell(0,Vector2i(REQUIREMENTS.to_door_positions_in_rooms.get(roomSizes.get(str(room))).x/32, -1)+ REQUIREMENTS.roomPositions.get(room)/32- Vector2i(1,0), -1, Vector2(-1,-1))
		

func _generate_door_keys():
	var numberOfDoorKeys = DOORS_PLACED.keys().size()-1
	var numberOfChestKeys = chestsThatNeedKeys.size()
	
	for door in finalDoorOrder:
		var minigamesInTheRoom = []
		for minigame in minigamesThatDropKey.keys():
			if int(minigamesThatDropKey.get(minigame)) == door:
				minigamesInTheRoom.append(minigame)
		
		var randomMinigame
		if minigamesInTheRoom:
			randomMinigame = minigamesInTheRoom.pick_random()
			minigamesThatDropKey.erase(randomMinigame)
		
			var doorID
			
			if not finalDoorOrder.find(door) == finalDoorOrder.size()-1:
				doorID = "toDoor_" + str(door)
			else:
				doorID = "FINAL_DOOR"
			
			randomMinigame.keyID = doorID
			
	_generate_chest_keys()

		
func _generate_chest_keys():
	for minigames in minigamesThatDropKey.keys():
		_place_chests()
	
	for minigames in minigamesThatDropKey.keys():
		var chest = chestsThatNeedKeys[minigamesThatDropKey.keys().find(minigames)]
		minigames.keyID = chest
		
		
func _miniames_completed(minigame):
	pass
	#TODO WHEN A MINIGAME IS COMPLETED, ADD IT TO COMPLETED MINIGAMES + THEIR ROOMS SO THE DOOR CAN ONLY OPEN IF THE PLAYER HAS THE KEY AND EVERY MINIGAME IS SOLVED 
