extends Node2D

signal difficulty_set(difficulty)
signal set_entities_to_palce(dictionary)


var greenColor = Color.CHARTREUSE
var redColor = Color.DARK_RED


var difficulty: String
var NUMBER_OF_ENEMIES = {}
var NUMBER_OF_MINIGAMES = {}
var NUMBER_OF_ROOMS = {}
var ENTITIES_TO_PLACE = {}
var parent

var numberOfRoomsLabel
var minRoomNumberLabel
var maxRoomNumberLabel

var placedNumberOfEnemiesLabel
var totalNumberOfEnemiesLabel

var placedNumberOfEnemiesLabel_SINGLE
var totalNumberOfEnemiesLabel_SINGLE
var placedNumberOfEasyEnemiesLabel_SINGLE
var totalNumberOfEasyEnemiesLabel_SINGLE
var placedNumberOfMediumEnemiesLabel_SINGLE
var totalNumberOfMediumEnemiesLabel_SINGLE
var placedNumberOfHardEnemiesLabel_SINGLE
var totalNumberOfHardEnemiesLabel_SINGLE

var placedNumberOfEnemiesLabel_MULTIPLE
var totalNumberOfEnemiesLabel_MULTIPLE
var placedNumberOfEasyEnemiesLabel_MULTIPLE
var totalNumberOfEasyEnemiesLabel_MULTIPLE
var placedNumberOfMediumEnemiesLabel_MULTIPLE
var totalNumberOfMediumEnemiesLabel_MULTIPLE
var placedNumberOfHardEnemiesLabel_MULTIPLE
var totalNumberOfHardEnemiesLabel_MULTIPLE

var placedNumberOfEasyMinigames
var placedNumberOfMediumMinigames
var placedNumberOfHardMinigames
var totalNumberOfEasyMinigames
var totalNumberOfMediumMinigames
var totalNumberOfHardMinigames

var placedSingleEnemyLabel = []
var placedMultipleEnemyLabel = []
var placedMinigameLabel = []

var DIFFICULTY = ["easy", "medium", "hard"]

signal MAX_AMOUNT_REACHED(type: String, diff: String)
signal MAX_AMOUNT_NOT_REACHED(type: String, diff: String)
signal minigame_changed(type: String, diff: String, added: bool, edited: bool)
signal MAP_PUBLISHABLE(publishable: bool)


# Called when the node enters the scene tree for the first time.
func _ready():
	difficulty_set.connect(_set_difficulty)
	_get_nodes()
	parent = get_parent()
	minigame_changed.connect(_amount_changed)

	if parent:
		parent.room_number_changed.connect(_set_room_number)
		if parent.get_parent():
			parent.get_parent().ENTITIES_TO_PLACE_CHANGED.connect(_amount_changed)
	set_entities_to_palce.connect(_set_up_dict)
			


func _get_nodes():
	numberOfRoomsLabel = $RequirementValues/NumberOfRooms
	minRoomNumberLabel = $RequirementValues/MinMaxRoom/MinNumberOfRooms
	maxRoomNumberLabel = $RequirementValues/MinMaxRoom/MaxNumberOfRooms
	
	placedNumberOfEnemiesLabel = $RequirementValues/NumberOfEnemies/PlacedNumberOfEnemies
	totalNumberOfEnemiesLabel = $RequirementValues/NumberOfEnemies/TotalNumberOfEnemies
	
	placedNumberOfEnemiesLabel_SINGLE = $RequirementValues/GridContainer/NumberOfEnemies2/PlacedNumberOfEnemies
	totalNumberOfEnemiesLabel_SINGLE = $RequirementValues/GridContainer/NumberOfEnemies2/TotalNumberOfEnemies
	placedNumberOfEasyEnemiesLabel_SINGLE = $RequirementValues/GridContainer/NumberOfMinigamesEasy/PlacedNumberOfEasyMinigames
	totalNumberOfEasyEnemiesLabel_SINGLE = $RequirementValues/GridContainer/NumberOfMinigamesEasy/TotalNumberOfEasyMinigames
	placedNumberOfMediumEnemiesLabel_SINGLE = $RequirementValues/GridContainer/NumberOfMinigamesMedium/PlacedNumberOfMediumMinigames
	totalNumberOfMediumEnemiesLabel_SINGLE = $RequirementValues/GridContainer/NumberOfMinigamesMedium/TotalNumberOfMediumMinigames
	placedNumberOfHardEnemiesLabel_SINGLE = $RequirementValues/GridContainer/NumberOfMinigamesHard/PlacedNumberOfHardMinigames
	totalNumberOfHardEnemiesLabel_SINGLE = $RequirementValues/GridContainer/NumberOfMinigamesHard/TotalNumberOfHardMinigames
	
	placedSingleEnemyLabel.append(placedNumberOfEasyEnemiesLabel_SINGLE)
	placedSingleEnemyLabel.append(placedNumberOfMediumEnemiesLabel_SINGLE)
	placedSingleEnemyLabel.append(placedNumberOfHardEnemiesLabel_SINGLE)

	placedNumberOfEnemiesLabel_MULTIPLE = $RequirementLabel/GridContainer/NumberOfEnemies2/PlacedNumberOfEnemies
	totalNumberOfEnemiesLabel_MULTIPLE = $RequirementLabel/GridContainer/NumberOfEnemies2/TotalNumberOfEnemies
	placedNumberOfEasyEnemiesLabel_MULTIPLE = $RequirementLabel/GridContainer/NumberOfMinigamesEasy/PlacedNumberOfEasyMinigames
	totalNumberOfEasyEnemiesLabel_MULTIPLE = $RequirementLabel/GridContainer/NumberOfMinigamesEasy/TotalNumberOfEasyMinigames
	placedNumberOfMediumEnemiesLabel_MULTIPLE = $RequirementLabel/GridContainer/NumberOfMinigamesMedium/PlacedNumberOfMediumMinigames 
	totalNumberOfMediumEnemiesLabel_MULTIPLE = $RequirementLabel/GridContainer/NumberOfMinigamesMedium/TotalNumberOfMediumMinigames
	placedNumberOfHardEnemiesLabel_MULTIPLE = $RequirementLabel/GridContainer/NumberOfMinigamesHard/PlacedNumberOfHardMinigames
	totalNumberOfHardEnemiesLabel_MULTIPLE = $RequirementLabel/GridContainer/NumberOfMinigamesHard/TotalNumberOfHardMinigames
	
	placedMultipleEnemyLabel.append(placedNumberOfEasyEnemiesLabel_MULTIPLE)
	placedMultipleEnemyLabel.append(placedNumberOfMediumEnemiesLabel_MULTIPLE)
	placedMultipleEnemyLabel.append(placedNumberOfHardEnemiesLabel_MULTIPLE)
	
	placedNumberOfEasyMinigames = $RequirementValues/NumberOfMinigamesEasy/PlacedNumberOfEasyMinigames
	placedNumberOfMediumMinigames = $RequirementValues/NumberOfMinigamesMedium/PlacedNumberOfMediumMinigames
	placedNumberOfHardMinigames = $RequirementValues/NumberOfMinigamesHard/PlacedNumberOfHardMinigames
	totalNumberOfEasyMinigames = $RequirementValues/NumberOfMinigamesEasy/TotalNumberOfEasyMinigames
	totalNumberOfMediumMinigames = $RequirementValues/NumberOfMinigamesMedium/TotalNumberOfMediumMinigames
	totalNumberOfHardMinigames = $RequirementValues/NumberOfMinigamesHard/TotalNumberOfHardMinigames
	
	placedMinigameLabel.append(placedNumberOfEasyMinigames)
	placedMinigameLabel.append(placedNumberOfMediumMinigames)
	placedMinigameLabel.append(placedNumberOfHardMinigames)
	
func _set_difficulty(diff: String):
	difficulty = diff
	if difficulty:
		_get_requirements(difficulty)
	

func _get_requirements(diff: String):
	NUMBER_OF_ENEMIES = REQUIREMENTS.number_of_enemies_to_place.get(diff)
	NUMBER_OF_MINIGAMES = REQUIREMENTS.number_of_minigames_to_place.get(diff)
	NUMBER_OF_ROOMS = REQUIREMENTS.number_of_rooms_based_on_difficulty.get(diff)
	_set_requirements()
	
func _set_requirements():
	minRoomNumberLabel.text = "Min.: " + str(NUMBER_OF_ROOMS.get("min"))
	maxRoomNumberLabel.text = "Max.: " + str(NUMBER_OF_ROOMS.get("max")) #TODO: so the player cant enter more rooms than the max and min
	numberOfRoomsLabel.add_theme_color_override("font_color", redColor)
	
	var maxNumberOfEnemies = 0
	var maxSpawnPoints = 0
	var maxSingleEnemy = 0
	
	var maxSingleEasyEnemy = 0
	var maxSingleMediumEnemy = 0
	var maxSingleHardEnemy = 0
	var singleArray = [maxSingleEasyEnemy, maxSingleMediumEnemy, maxSingleHardEnemy]
	
	var maxMultipleEasyEnemy = 0
	var maxMultipleMediumEnemy = 0
	var maxMultipleHardEnemy = 0
	var multipleArray = [maxMultipleEasyEnemy, maxMultipleMediumEnemy, maxMultipleHardEnemy]
	
	for type in NUMBER_OF_ENEMIES.keys():
		for max in NUMBER_OF_ENEMIES.get(type):
			if type == "single":
				singleArray[NUMBER_OF_ENEMIES.get(type).keys().find(max)] = NUMBER_OF_ENEMIES.get(type).get(max).get("max")
				maxSingleEnemy += NUMBER_OF_ENEMIES.get(type).get(max).get("max")
			else:
				multipleArray[NUMBER_OF_ENEMIES.get(type).keys().find(max)] = NUMBER_OF_ENEMIES.get(type).get(max).get("max")
				maxSpawnPoints += NUMBER_OF_ENEMIES.get(type).get(max).get("max")
	
	maxNumberOfEnemies = maxSingleEnemy + maxSpawnPoints
	totalNumberOfEnemiesLabel.text = str(maxNumberOfEnemies)
	totalNumberOfEnemiesLabel_SINGLE.text = str(maxSingleEnemy)
	totalNumberOfEnemiesLabel_MULTIPLE.text = str(maxSpawnPoints)
	totalNumberOfEasyEnemiesLabel_SINGLE.text = str(singleArray[0])
	totalNumberOfMediumEnemiesLabel_SINGLE.text = str(singleArray[1])
	totalNumberOfHardEnemiesLabel_SINGLE.text = str(singleArray[2])
	totalNumberOfEasyEnemiesLabel_MULTIPLE.text = str(multipleArray[0])
	totalNumberOfMediumEnemiesLabel_MULTIPLE.text = str(multipleArray[1])
	totalNumberOfHardEnemiesLabel_MULTIPLE.text = str(multipleArray[2])
	
	var maxNumberOfEasyMinigames = 0
	var maxNumberOfMediumMinigames = 0
	var maxNumberOFHardMinigames = 0
	var minigameArray = [maxNumberOfEasyMinigames, maxNumberOfMediumMinigames, maxNumberOFHardMinigames]
	
	for diff in NUMBER_OF_MINIGAMES.keys():
		minigameArray[NUMBER_OF_MINIGAMES.keys().find(diff)] = NUMBER_OF_MINIGAMES.get(diff).get("max")
		
	totalNumberOfEasyMinigames.text = str(minigameArray[0])
	totalNumberOfMediumMinigames.text = str(minigameArray[1])
	totalNumberOfHardMinigames.text = str(minigameArray[2])
	
	_set_up_values()
	

func _set_up_dict(dictionary):
	ENTITIES_TO_PLACE = dictionary

func _set_up_values():
	if ENTITIES_TO_PLACE:
		_set_room_number(ENTITIES_TO_PLACE.get("rooms").keys().size())
		var enemies = ENTITIES_TO_PLACE.get("enemy")
		for enemy in enemies.keys():
			var diff
			var type
			if enemies.get(enemy).has("enemyData"):
				diff = enemies.get(enemy).get("enemyData").get("enemyDifficulty")
				type = "spawnpoint"
			else:
				diff = enemies.get(enemy).get("enemy_data").get("enemyDifficulty")
				type = "enemy"
			_add_amount(type, diff)
		
		var minigames = ENTITIES_TO_PLACE.get("minigames")
		
		for minigame in minigames.keys():
			var type = "minigame"
			var diff = minigames.get(minigame).get("difficulty")
			_add_amount("minigame", diff)
	_set_initial_violations()

func _set_initial_violations():
	var type
	var diff
	var min
	var max
	var placed
	
	for i in range(0, placedSingleEnemyLabel.size()):
		if int(placedSingleEnemyLabel[i].text) == 0:
			type = "enemy"
			diff = DIFFICULTY[i]
			min = REQUIREMENTS.number_of_enemies_to_place.get(difficulty).get("single").get(diff).get("min")
			print("single enemy min: ", min)
			MAP_PUBLISHABLE.emit(false, type, diff, min)
	for i in range(0, placedMultipleEnemyLabel.size()):
		if int(placedMultipleEnemyLabel[i].text) == 0:
			type = "spawnpoint"
			diff = DIFFICULTY[i]
			min = REQUIREMENTS.number_of_enemies_to_place.get(difficulty).get("multiple").get(diff).get("min")
			MAP_PUBLISHABLE.emit(false, type, diff, min)
	for i in range(0, placedMinigameLabel.size()):
		if int(placedMinigameLabel[i].text) == 0:
			type = "minigame"
			diff = DIFFICULTY[i]
			min = REQUIREMENTS.number_of_minigames_to_place.get(difficulty).get(diff).get("min")
			MAP_PUBLISHABLE.emit(false, type, diff, min)
		
		
		

func _set_room_number(roomNumber):
	numberOfRoomsLabel.text = str(roomNumber)
	_check_amount("room", "", -1, -1)
	

func _amount_changed(type: String, diff: String, added: bool, edited: bool):
	if added and !edited:
		_add_amount(type, diff)
	elif !added and !edited:
		_deduct_amount(type, diff)
	
func _add_amount(type: String, diff: String):
	var oldAmount: int
	var newAmount: int
	var max: int
	var min: int
	if type == "enemy":
		placedNumberOfEnemiesLabel.text = str(int(placedNumberOfEnemiesLabel.text) + 1)
		placedNumberOfEnemiesLabel_SINGLE.text = str(int(placedNumberOfEnemiesLabel_SINGLE.text) + 1)
		max = NUMBER_OF_ENEMIES.get("single").get(diff).get("max")
		min = NUMBER_OF_ENEMIES.get("single").get(diff).get("min")
		match diff:
			"easy":
				oldAmount = int(placedSingleEnemyLabel[0].text) 
				placedSingleEnemyLabel[0].text = str(int(placedSingleEnemyLabel[0].text) + 1)
				newAmount = int(placedSingleEnemyLabel[0].text) 
			"medium":
				oldAmount = int(placedSingleEnemyLabel[1].text)
				placedSingleEnemyLabel[1].text = str(int(placedSingleEnemyLabel[1].text) + 1)
				newAmount = int(placedSingleEnemyLabel[1].text) 
			"hard":
				oldAmount = int(placedSingleEnemyLabel[1].text)
				placedSingleEnemyLabel[2].text = str(int(placedSingleEnemyLabel[2].text) + 1)
				newAmount = int(placedSingleEnemyLabel[1].text) 
	elif type == "spawnpoint":
		max = NUMBER_OF_ENEMIES.get("multiple").get(diff).get("max")
		min = NUMBER_OF_ENEMIES.get("multiple").get(diff).get("min")
		placedNumberOfEnemiesLabel.text = str(int(placedNumberOfEnemiesLabel.text) + 1)
		placedNumberOfEnemiesLabel_MULTIPLE.text = str(int(placedNumberOfEnemiesLabel_MULTIPLE.text) + 1)
		match diff:
			"easy":
				oldAmount = int(placedMultipleEnemyLabel[0].text)
				placedMultipleEnemyLabel[0].text = str(int(placedMultipleEnemyLabel[0].text) + 1)
				newAmount = int(placedMultipleEnemyLabel[0].text) 
			"medium":
				oldAmount = int(placedMultipleEnemyLabel[1].text)
				placedMultipleEnemyLabel[1].text = str(int(placedMultipleEnemyLabel[1].text) + 1)
				newAmount = int(placedMultipleEnemyLabel[1].text)
			"hard":
				oldAmount = int(placedMultipleEnemyLabel[2].text)
				placedMultipleEnemyLabel[2].text = str(int(placedMultipleEnemyLabel[2].text) + 1)
				newAmount = int(placedMultipleEnemyLabel[2].text) 
	else:
		max = NUMBER_OF_MINIGAMES.get(diff).get("max")
		min = NUMBER_OF_MINIGAMES.get(diff).get("min")
		match diff:
			"easy":
				oldAmount = int(placedNumberOfEasyMinigames.text)
				placedNumberOfEasyMinigames.text = str(int(placedNumberOfEasyMinigames.text) + 1)
				newAmount = int(placedNumberOfEasyMinigames.text) 
			"medium":
				oldAmount = int(placedNumberOfMediumMinigames.text)
				placedNumberOfMediumMinigames.text = str(int(placedNumberOfMediumMinigames.text) + 1)
				newAmount = int(placedNumberOfMediumMinigames.text)
			"hard":
				oldAmount = int(placedNumberOfHardMinigames.text)
				placedNumberOfHardMinigames.text = str(int(placedNumberOfHardMinigames.text) + 1)
				newAmount = int(placedNumberOfHardMinigames.text) 
	
	_check_violation(newAmount,oldAmount, min, max, type, diff)
	_check_amount(type, diff, -1, -1)
	
func _deduct_amount(type: String, diff: String):
	var oldAmount
	var newAmount
	var min
	var max
	if type == "enemy":
		max = NUMBER_OF_ENEMIES.get("single").get(diff).get("max")
		min = NUMBER_OF_ENEMIES.get("single").get(diff).get("min")
		placedNumberOfEnemiesLabel_SINGLE.text = str(int(placedNumberOfEnemiesLabel_SINGLE.text) - 1)
		match diff:
			"easy":
				oldAmount = int(placedSingleEnemyLabel[0].text)
				placedSingleEnemyLabel[0].text = str(int(placedSingleEnemyLabel[0].text) - 1)
				newAmount = int(placedSingleEnemyLabel[0].text) 
			"medium":
				oldAmount = int(placedSingleEnemyLabel[1].text)
				placedSingleEnemyLabel[1].text = str(int(placedSingleEnemyLabel[1].text) - 1)
				newAmount = int(placedSingleEnemyLabel[1].text) 
			"hard":
				oldAmount = int(placedSingleEnemyLabel[2].text)
				placedSingleEnemyLabel[2].text = str(int(placedSingleEnemyLabel[2].text) - 1)
				newAmount = int(placedSingleEnemyLabel[2].text) 
	elif type == "spawnpoint":
		max = NUMBER_OF_ENEMIES.get("multiple").get(diff).get("max")
		min = NUMBER_OF_ENEMIES.get("multiple").get(diff).get("min")
		placedNumberOfEnemiesLabel_MULTIPLE.text = str(int(placedNumberOfEnemiesLabel_MULTIPLE.text) - 1)
		match diff:
			"easy":
				oldAmount = int(placedMultipleEnemyLabel[0].text) 
				placedMultipleEnemyLabel[0].text = str(int(placedMultipleEnemyLabel[0].text) - 1)
				newAmount = int(placedMultipleEnemyLabel[0].text) 
			"medium":
				oldAmount = int(placedMultipleEnemyLabel[0].text) 
				placedMultipleEnemyLabel[1].text = str(int(placedMultipleEnemyLabel[1].text) - 1)
				newAmount = int(placedMultipleEnemyLabel[0].text)
			"hard":
				oldAmount = int(placedMultipleEnemyLabel[2].text)
				placedMultipleEnemyLabel[2].text = str(int(placedMultipleEnemyLabel[2].text) - 1)
				newAmount = int(placedMultipleEnemyLabel[2].text) 
				
	else:
		max = NUMBER_OF_MINIGAMES.get(diff).get("max")
		min = NUMBER_OF_MINIGAMES.get(diff).get("min")
		match diff:
			"easy":
				oldAmount = int(placedNumberOfEasyMinigames.text) 
				placedNumberOfEasyMinigames.text = str(int(placedNumberOfEasyMinigames.text) - 1)
				newAmount = int(placedNumberOfEasyMinigames.text )
			"medium":
				oldAmount = int(placedNumberOfMediumMinigames.text) 
				placedNumberOfMediumMinigames.text = str(int(placedNumberOfMediumMinigames.text) - 1)
				newAmount = int(placedNumberOfMediumMinigames.text) 
			"hard":
				oldAmount = int(placedNumberOfHardMinigames.text) 
				placedNumberOfHardMinigames.text = str(int(placedNumberOfHardMinigames.text) - 1)
				newAmount = int(placedNumberOfHardMinigames.text)
	_check_violation(newAmount,oldAmount, min, max, type, diff)
	_check_amount(type, diff, oldAmount, newAmount)
	

func _check_violation(newAmount,oldAmount, min, max,type, diff):
	if newAmount < min or newAmount > max:
		MAP_PUBLISHABLE.emit(false, type, diff)
	elif newAmount >= min or newAmount <= max:
		MAP_PUBLISHABLE.emit(true, type, diff)

func _check_amount(type: String, diff: String, oldAmount: int, newAmount: int):
	if type == "room":
		(numberOfRoomsLabel as Label).add_theme_color_override("font_color", greenColor)
		if int(numberOfRoomsLabel.text.right(1)) < int(minRoomNumberLabel.text.right(1)):
			(numberOfRoomsLabel as Label).add_theme_color_override("font_color", redColor)
		elif int(numberOfRoomsLabel.text.right(1)) == int(maxRoomNumberLabel.text.right(1)):
			MAX_AMOUNT_REACHED.emit("room", "")
	elif type == "enemy":
		match diff:
			"easy":
				placedNumberOfEasyEnemiesLabel_SINGLE.add_theme_color_override("font_color", greenColor)
				totalNumberOfEasyEnemiesLabel_SINGLE.add_theme_color_override("font_color", greenColor)
				$RequirementValues/GridContainer/NumberOfMinigamesEasy/SEPARATOR.add_theme_color_override("font_color", greenColor)
				$RequirementValues/GridContainer/NumberOfMinigamesEasy/Easy.add_theme_color_override("font_color", greenColor)
				if int(placedNumberOfEasyEnemiesLabel_SINGLE.text) < NUMBER_OF_ENEMIES.get("single").get(diff).get("min") or int(placedNumberOfEasyEnemiesLabel_SINGLE.text) > NUMBER_OF_ENEMIES.get("single").get(diff).get("max") :
					placedNumberOfEasyEnemiesLabel_SINGLE.add_theme_color_override("font_color", redColor)
					totalNumberOfEasyEnemiesLabel_SINGLE.add_theme_color_override("font_color", redColor)
					$RequirementValues/GridContainer/NumberOfMinigamesEasy/SEPARATOR.add_theme_color_override("font_color", redColor)
					$RequirementValues/GridContainer/NumberOfMinigamesEasy/Easy.add_theme_color_override("font_color", redColor)
			"medium":
				placedNumberOfMediumEnemiesLabel_SINGLE.add_theme_color_override("font_color", greenColor)
				totalNumberOfMediumEnemiesLabel_SINGLE.add_theme_color_override("font_color", greenColor)
				$RequirementValues/GridContainer/NumberOfMinigamesMedium/SEPARATOR.add_theme_color_override("font_color", greenColor)
				$RequirementValues/GridContainer/NumberOfMinigamesMedium/Medium.add_theme_color_override("font_color", greenColor)
				if int(placedNumberOfMediumEnemiesLabel_SINGLE.text) < NUMBER_OF_ENEMIES.get("single").get(diff).get("min") or int(placedNumberOfMediumEnemiesLabel_SINGLE.text) > NUMBER_OF_ENEMIES.get("single").get(diff).get("max"):
					placedNumberOfMediumEnemiesLabel_SINGLE.add_theme_color_override("font_color", redColor)
					totalNumberOfMediumEnemiesLabel_SINGLE.add_theme_color_override("font_color", redColor)
					$RequirementValues/GridContainer/NumberOfMinigamesMedium/SEPARATOR.add_theme_color_override("font_color", redColor)
					$RequirementValues/GridContainer/NumberOfMinigamesMedium/Medium.add_theme_color_override("font_color", redColor)
			"hard":
				placedNumberOfHardEnemiesLabel_SINGLE.add_theme_color_override("font_color", greenColor)
				totalNumberOfHardEnemiesLabel_SINGLE.add_theme_color_override("font_color", greenColor)
				$RequirementValues/GridContainer/NumberOfMinigamesHard/Hard.add_theme_color_override("font_color", greenColor)
				$RequirementValues/GridContainer/NumberOfMinigamesHard/SEPARATOR.add_theme_color_override("font_color", greenColor)
				if int(placedNumberOfHardEnemiesLabel_SINGLE.text) < NUMBER_OF_ENEMIES.get("single").get(diff).get("min") or int(placedNumberOfHardEnemiesLabel_SINGLE.text) > NUMBER_OF_ENEMIES.get("single").get(diff).get("max"):
					placedNumberOfHardEnemiesLabel_SINGLE.add_theme_color_override("font_color", redColor)
					totalNumberOfHardEnemiesLabel_SINGLE.add_theme_color_override("font_color", redColor)
					$RequirementValues/GridContainer/NumberOfMinigamesHard/SEPARATOR.add_theme_color_override("font_color", redColor)
					$RequirementValues/GridContainer/NumberOfMinigamesHard/Hard.add_theme_color_override("font_color", redColor)
	elif type == "spawnpoint":
		match diff:
			"easy":
				placedNumberOfEasyEnemiesLabel_MULTIPLE.add_theme_color_override("font_color", greenColor)
				totalNumberOfEasyEnemiesLabel_MULTIPLE.add_theme_color_override("font_color", greenColor)
				$RequirementLabel/GridContainer/NumberOfMinigamesEasy/SEPARATOR.add_theme_color_override("font_color", greenColor)
				$RequirementLabel/GridContainer/NumberOfMinigamesEasy/Easy.add_theme_color_override("font_color", greenColor)
				if int(placedNumberOfEasyEnemiesLabel_MULTIPLE.text) < NUMBER_OF_ENEMIES.get("multiple").get("easy").get("min") or int(placedNumberOfEasyEnemiesLabel_MULTIPLE.text) > NUMBER_OF_ENEMIES.get("multiple").get("easy").get("max"):
					placedNumberOfEasyEnemiesLabel_MULTIPLE.add_theme_color_override("font_color", redColor)
					totalNumberOfEasyEnemiesLabel_MULTIPLE.add_theme_color_override("font_color", redColor)
					$RequirementLabel/GridContainer/NumberOfMinigamesEasy/SEPARATOR.add_theme_color_override("font_color", redColor)
					$RequirementLabel/GridContainer/NumberOfMinigamesEasy/Easy.add_theme_color_override("font_color", redColor)
			"medium":
				placedNumberOfMediumEnemiesLabel_MULTIPLE.add_theme_color_override("font_color", greenColor)
				totalNumberOfMediumEnemiesLabel_MULTIPLE.add_theme_color_override("font_color", greenColor)
				$RequirementLabel/GridContainer/NumberOfMinigamesMedium/SEPARATOR.add_theme_color_override("font_color", greenColor)
				$RequirementLabel/GridContainer/NumberOfMinigamesMedium/Medium.add_theme_color_override("font_color", greenColor)
				if int(placedNumberOfMediumEnemiesLabel_MULTIPLE.text) < NUMBER_OF_ENEMIES.get("multiple").get(diff).get("min") or int(placedNumberOfMediumEnemiesLabel_MULTIPLE.text) > NUMBER_OF_ENEMIES.get("multiple").get(diff).get("max"):
					placedNumberOfMediumEnemiesLabel_MULTIPLE.add_theme_color_override("font_color", redColor)
					totalNumberOfMediumEnemiesLabel_MULTIPLE.add_theme_color_override("font_color", redColor)
					$RequirementLabel/GridContainer/NumberOfMinigamesMedium/SEPARATOR.add_theme_color_override("font_color", redColor)
					$RequirementLabel/GridContainer/NumberOfMinigamesMedium/Medium.add_theme_color_override("font_color", redColor)
			"hard":
				placedNumberOfHardEnemiesLabel_MULTIPLE.add_theme_color_override("font_color", greenColor)
				totalNumberOfHardEnemiesLabel_MULTIPLE.add_theme_color_override("font_color", greenColor)
				$RequirementLabel/GridContainer/NumberOfMinigamesHard/SEPARATOR.add_theme_color_override("font_color", greenColor)
				$RequirementLabel/GridContainer/NumberOfMinigamesHard/Hard.add_theme_color_override("font_color", greenColor)
				if int(placedNumberOfHardEnemiesLabel_MULTIPLE.text) < NUMBER_OF_ENEMIES.get("multiple").get("easy").get("min") or int(placedNumberOfHardEnemiesLabel_MULTIPLE.text) > NUMBER_OF_ENEMIES.get("multiple").get("easy").get("max"):
					placedNumberOfHardEnemiesLabel_MULTIPLE.add_theme_color_override("font_color", redColor)
					totalNumberOfHardEnemiesLabel_MULTIPLE.add_theme_color_override("font_color", redColor)
					$RequirementLabel/GridContainer/NumberOfMinigamesHard/SEPARATOR.add_theme_color_override("font_color", redColor)
					$RequirementLabel/GridContainer/NumberOfMinigamesHard/Hard.add_theme_color_override("font_color", redColor)
	else:
		match diff:
			"easy":
				placedNumberOfEasyMinigames.add_theme_color_override("font_color", greenColor)
				totalNumberOfEasyMinigames.add_theme_color_override("font_color", greenColor)
				$RequirementValues/NumberOfMinigamesEasy/SEPARATOR.add_theme_color_override("font_color", greenColor)
				$RequirementValues/NumberOfMinigamesEasy/Easy.add_theme_color_override("font_color", greenColor)
				if int(placedNumberOfEasyMinigames.text) < NUMBER_OF_MINIGAMES.get(diff).get("min") or int(placedNumberOfEasyMinigames.text) > NUMBER_OF_MINIGAMES.get(diff).get("max"):
					placedNumberOfEasyMinigames.add_theme_color_override("font_color", redColor)
					totalNumberOfEasyMinigames.add_theme_color_override("font_color", redColor)
					$RequirementValues/NumberOfMinigamesEasy/SEPARATOR.add_theme_color_override("font_color", redColor)
					$RequirementValues/NumberOfMinigamesEasy/Easy.add_theme_color_override("font_color", redColor)
			"medium":
				placedNumberOfMediumMinigames.add_theme_color_override("font_color", greenColor)
				totalNumberOfMediumMinigames.add_theme_color_override("font_color", greenColor)
				$RequirementValues/NumberOfMinigamesMedium/SEPARATOR.add_theme_color_override("font_color", greenColor)
				$RequirementValues/NumberOfMinigamesMedium/Medium.add_theme_color_override("font_color", greenColor)
				if int(placedNumberOfMediumMinigames.text) < NUMBER_OF_MINIGAMES.get(diff).get("min") or int(placedNumberOfMediumMinigames.text) > NUMBER_OF_MINIGAMES.get(diff).get("max"):
					placedNumberOfMediumMinigames.add_theme_color_override("font_color", redColor)
					totalNumberOfMediumMinigames.add_theme_color_override("font_color", redColor)
					$RequirementValues/NumberOfMinigamesMedium/SEPARATOR.add_theme_color_override("font_color", redColor)
					$RequirementValues/NumberOfMinigamesMedium/Medium.add_theme_color_override("font_color", redColor)
			"hard":
				placedNumberOfHardMinigames.add_theme_color_override("font_color", greenColor)
				totalNumberOfHardMinigames.add_theme_color_override("font_color", greenColor)
				$RequirementValues/NumberOfMinigamesHard/SEPARATOR.add_theme_color_override("font_color", greenColor)
				$RequirementValues/NumberOfMinigamesHard/Hard.add_theme_color_override("font_color", greenColor)
				if int(placedNumberOfHardMinigames.text) < NUMBER_OF_MINIGAMES.get(diff).get("min") or int(placedNumberOfHardMinigames.text) > NUMBER_OF_MINIGAMES.get(diff).get("max"):
					placedNumberOfHardMinigames.add_theme_color_override("font_color", redColor)
					totalNumberOfHardMinigames.add_theme_color_override("font_color", redColor)
					$RequirementValues/NumberOfMinigamesHard/SEPARATOR.add_theme_color_override("font_color", redColor)
					$RequirementValues/NumberOfMinigamesHard/Hard.add_theme_color_override("font_color", redColor)	

func _check_minigames_in_room(dict):
	var minigames = dict.get("minigames")
	var minigameRooms = []
	var rooms = dict.get("rooms").keys()
	
	for minigame in minigames:
		if minigames.get(minigame).get("reward") == "Key":
			minigameRooms.append(minigames.get(minigame).get("room"))
		
	for room in rooms:
		if not minigameRooms.has(room):
			return false
			
	return true
	
	


