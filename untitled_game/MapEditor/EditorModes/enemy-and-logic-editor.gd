extends Node2D



#-------------------------------------- CONSTANTS ---------------------------------------------------
const textureScale = Vector2(0.1, 0.1)
var spawnPointLoaded = load("res://GameplayThings/EnemySpawnPoints/enemy_spawnpoint.tscn")


#-------------------------------------- SIGNALS ---------------------------------------------------

signal enemy_to_place_selected(enemy, texture)
signal place_spawn_point(spawnpoint)
signal show_error(error: String)
signal single_enemy()
signal multiple_enemy()
signal move_enemy_editor_mode(enemyToPalce, enemyToPlaceTexture)
signal edit_enemy_editor_mode(button)
signal delete_enemy(updatedDictionary: Dictionary)




#-------------------------------------- VARIABLES ---------------------------------------------------
var enemyToPlaceObject
var selectedEnemyNode
var selectedEnemySpawnPoint
var selectedEnemyVariantName: String
var selectedEnemyTypeName: String
var selectedEnemyAmount: String

var difficultySelection: OptionButton
var meleeSelection: CheckBox
var rangedSelection: CheckBox
var healthPointsSelection: SpinBox
var attackPointsSelection: SpinBox
var enemySpeedSetter: HSlider
var enemyAttackSpeedSetter: HSlider
var enemyCooldownSetter: HSlider
var errorLabel: Label
var errorLabelTimer: Timer
var enemyEditor: Control
var enemyAmountSelector: Control
var infiniteNumberOfEnemiesToSpawnSpin: CheckBox
var customNumberOfEnemiesToSpawnSpin: CheckBox
var customNumberOfEnemiesSpinner: SpinBox

var selectedEnemyDifficulty: String = "select"
var selectedEnemyType: String = ""
var enemySpeed: float = 0
var enemyAttackSpeed: int = 0
var enemyCooldown: int = 0
var enemyAttackPoints: int = 0
var enemyHealthPoints: int = 0
var enemiesToSpawnNumber: int = 1

var isEnemyEdited = false
var oldEnemy
var oldEnemyButton
var isEnemy: bool

var numberOfEnemiesToSpawn: String
var spawnCooldown: int

var pressedEnemy


var loadedTextures = {}
var selectedTexture

var difficultyToRemove_SINGLE: String = ""
var difficultyToRemove_MULTI: String = ""
var difficultyToAdd_SINGLE: String = ""
var difficultyToAdd_MULTI: String = ""

var parent
var buttonsDictionary

signal MAX_AMOUNT_REACHED
signal MAX_AMOUNT_NOT_REACHED


# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	_add_buttons_to_grids()
	_set_nodes_variables()
	_connect_signals()
	_add_difficulty_to_option_selection()


#-------------------------------------- SET UP FUNCTIONS ---------------------------------------------------
func set_up_initial_dictionay_value(value):
	buttonsDictionary = value

func _add_buttons_to_grids():
	loadedTextures = FileLoader.load_assets_1_level_deep("res://Game Assets/MapEditor/Enemy/", ".png")
	for key in loadedTextures.keys():
		var button = TextureButton.new()
		button.custom_minimum_size = Vector2(90,90)
		button.texture_normal = loadedTextures.get(key)
		print(key)
		button.stretch_mode = TextureButton.STRETCH_SCALE
		button.ignore_texture_size = true
		button.pressed.connect(_on_enemy_selected.bind(key, button.texture_normal))
		$CanvasLayer/EnemySelection/ScrollContainer/GridContainer.add_child(button)

func _connect_signals():
	show_error.connect(_show_error)
	single_enemy.connect(_single_enemy_selected)
	multiple_enemy.connect(_multiple_enemies_selected)
	if parent is Node2D:
		parent.placed_enemy_clicked.connect(_on_placed_enemy_clicked)
		
	
func _set_nodes_variables():
	difficultySelection = $CanvasLayer/EnemyEditor/SelectDifficulty/OptionButton
	meleeSelection = $CanvasLayer/EnemyEditor/EnemyTypeSelection/MeleeSelection
	rangedSelection = $CanvasLayer/EnemyEditor/EnemyTypeSelection/RangedSelection
	healthPointsSelection = $CanvasLayer/EnemyEditor/EnemySetStatistics/HealthPoints
	attackPointsSelection = $CanvasLayer/EnemyEditor/EnemySetStatistics/AttackPoints
	enemySpeedSetter = $CanvasLayer/EnemyEditor/EnemySpeedSettings/EnemySpeed
	enemyAttackSpeedSetter = $CanvasLayer/EnemyEditor/EnemySpeedSettings/EnemyAttackSpeed
	errorLabel = $CanvasLayer/EnemyEditor/Error
	errorLabelTimer = $CanvasLayer/EnemyEditor/Error/Timer
	enemyEditor =  $CanvasLayer/EnemyEditor
	enemyAmountSelector = $CanvasLayer/SpawnPointOrSingle
	
	infiniteNumberOfEnemiesToSpawnSpin = $CanvasLayer/SpawnPointEditor/NumberOfEnemies/Infinite
	customNumberOfEnemiesToSpawnSpin = $CanvasLayer/SpawnPointEditor/NumberOfEnemies/Custom
	customNumberOfEnemiesSpinner = $CanvasLayer/SpawnPointEditor/NumberOfEnemies/NumberOfEnemiesSpinner
	
	errorLabel.text = ""
	
	meleeSelection.gui_input.connect(_on_check_if_disabled)
	rangedSelection.gui_input.connect(_on_check_if_disabled)
	healthPointsSelection.gui_input.connect(_on_check_if_disabled)
	attackPointsSelection.gui_input.connect(_on_check_if_disabled)
	enemySpeedSetter.gui_input.connect(_on_check_if_disabled)
	enemyAttackSpeedSetter.gui_input.connect(_on_check_if_disabled)
	
func _show_error(error: String):
	errorLabelTimer.start()
	errorLabel.text = error
	errorLabel.visible = true
	

#-------------------------------------- LOGIC FUNCTIONS ---------------------------------------------------

func _open_enemy_editor_dialog(selectedEnemyName: String, isFirstSelection: bool):
	_get_enemy_type_and_variant_from_file_name(selectedEnemyName)
	get_tree().paused = false
	
	if isFirstSelection:
		enemyAmountSelector.visible = true
	else:
		enemyEditor.visible = true
		if isEnemy:
			$CanvasLayer/EnemyEditor/ProceedButton.visible = true
			$CanvasLayer/EnemyEditor/ProceedToSpawnConfigurator.visible = false
		else:
			$CanvasLayer/EnemyEditor/ProceedButton.visible = false
			$CanvasLayer/EnemyEditor/ProceedToSpawnConfigurator.visible = true


func _add_difficulty_to_option_selection():
	difficultySelection.add_item("select", 0)
	for key in REQUIREMENTS.enemy_difficulty.keys():
		difficultySelection.add_item(key, REQUIREMENTS.enemy_difficulty.keys().find(key)+1)

		
func _toggle_button_disability():
	meleeSelection.disabled = !meleeSelection.disabled
	rangedSelection.disabled =  !rangedSelection.disabled
	healthPointsSelection.editable = !healthPointsSelection.editable
	attackPointsSelection.editable = !attackPointsSelection.editable
	enemySpeedSetter.editable = !enemySpeedSetter.editable
	enemyAttackSpeedSetter.editable = !enemyAttackSpeedSetter.editable

	
func _reset_values(closed: bool):
	difficultySelection.selected = 0
	meleeSelection.button_pressed = false
	rangedSelection.button_pressed = false
	healthPointsSelection.value = 1
	attackPointsSelection.value = 1
	enemyAttackSpeedSetter.value = 1
	enemySpeedSetter.value = 1
	
func _set_values_based_on_difficulty(diff : String):
	var enemyProps = REQUIREMENTS.enemy_properties
	var enemyRequirements = REQUIREMENTS.enemy_difficulty.get(diff)
	
	attackPointsSelection.min_value = enemyRequirements.get(enemyProps.enemyAttackPoints).x
	attackPointsSelection.max_value = enemyRequirements.get(enemyProps.enemyAttackPoints).y
	
	healthPointsSelection.min_value = enemyRequirements.get(enemyProps.enemyHealthPoints).x
	attackPointsSelection.max_value = enemyRequirements.get(enemyProps.enemyHealthPoints).y
	
	enemySpeedSetter.min_value = enemyRequirements.get(enemyProps.enemySpeed).x
	enemySpeedSetter.max_value = enemyRequirements.get(enemyProps.enemySpeed).y
	
	enemyAttackSpeedSetter.min_value = enemyRequirements.get(enemyProps.enemyAttackSpeed).x
	enemyAttackSpeedSetter.max_value = enemyRequirements.get(enemyProps.enemyAttackSpeed).y
	
	
func _get_enemy_type_and_variant_from_file_name(selectedEnemyName: String) -> void:
	selectedEnemyTypeName = selectedEnemyName.split("_")[0]
	selectedEnemyVariantName = selectedEnemyName.split("_")[1]

func create_placed_enemy_editor(button):
	var background = TextureRect.new()
	background.custom_minimum_size = Vector2i(80,25)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.texture = load("res://Game Assets/GUI/backdrop2.png")
	background.self_modulate = Color(1,1,1,0.69)
	background.position.x = -15
	background.position.y = -20
	button.add_child(background)
	
	var grid = GridContainer.new()
	grid.columns = 3
	grid.custom_minimum_size = Vector2i(80,20)
	grid.position = Vector2i(5,2)
	
	background.add_child(grid)
	
	
	var editEnemyButton = create_placed_enemy_editor_buttons("res://Game Assets/MapEditor/Icons/pencil.png")
	editEnemyButton.pressed.connect(_on_edit_placed_enemy_clicked.bind(button))
	grid.add_child(editEnemyButton)
	
	var moveEnemyButton = create_placed_enemy_editor_buttons("res://Game Assets/MapEditor/Icons/move.png")
	moveEnemyButton.pressed.connect(_on_move_placed_enemy_clicked.bind(button))
	grid.add_child(moveEnemyButton)
	
	var deleteEnemyButton = create_placed_enemy_editor_buttons("res://Game Assets/MapEditor/Icons/Icons_03.png")
	deleteEnemyButton.pressed.connect(_on_delete_placed_enemy_clicked.bind(button))
	grid.add_child(deleteEnemyButton)

func create_placed_enemy_editor_buttons(texturePath: String) -> TextureButton:
	var button = TextureButton.new()
	button.texture_normal = load(texturePath)
	button.ignore_texture_size = true
	button.stretch_mode = TextureButton.STRETCH_SCALE
	button.custom_minimum_size = Vector2i(20,20)
	
	return button

	
	

#-------------------------------------- SIGNALS AND BUTTONS SECTION ---------------------------------------------------

func _on_placed_enemy_clicked(button, buttonsDict):
	buttonsDictionary = buttonsDict
	oldEnemyButton = button
	if button.get_child_count() == 0:
		create_placed_enemy_editor(button)
	else:
		button.remove_child(button.get_children()[0])
		
		
func _on_edit_placed_enemy_clicked(button):
	var enemyData
	pressedEnemy = button
	var data = parent.parent.ENTITIES_TO_PLACE.get("enemy").get(str(button.name).replace("_", ":"))
	var dataType = parent.parent.ENTITIES_TO_PLACE.get("enemy").get(str(button.name).replace("_", ":")).get("type")
	
	if dataType == "spawnpoint":
		enemyData = data.get("enemyData")
		selectedEnemyAmount = "multiple"
		isEnemy = false
	else:
		enemyData = data.get("enemy_data")
		isEnemy = true
		selectedEnemyAmount = "single"
	
	oldEnemy = str(button.name).replace("_", ":")
	isEnemyEdited = true

	_open_enemy_editor_dialog(enemyData.enemyType + "_" + enemyData.enemyVariant, false)

	difficultySelection.selected = REQUIREMENTS.enemy_difficulty.keys().find(enemyData.get("enemyDifficulty")) + 1
	_set_values_based_on_difficulty(enemyData.get("enemyDifficulty"))
	selectedEnemyDifficulty = enemyData.get("enemyDifficulty")
	selectedEnemyType = enemyData.get("enemyAttackType")
	enemyHealthPoints = int(enemyData.get("healthPoints"))
	enemyAttackPoints = int(enemyData.get("attackPoints"))
	enemyAttackSpeed = int(enemyData.get("enemyShootTime"))
	enemySpeed = enemyData.get("speed")
	numberOfEnemiesToSpawn = str(data.get("numberOfEnemiesToSpawn"))

	if enemyData.get("enemyAttackType") == "Melee":
		meleeSelection.button_pressed = true
		rangedSelection.button_pressed = false
	else:
		meleeSelection.button_pressed = false
		rangedSelection.button_pressed = true
	healthPointsSelection.value = enemyData.get("healthPoints")
	attackPointsSelection.value = enemyData.get("attackPoints")
	enemyAttackSpeedSetter.value = enemyData.get("enemyShootTime")
	enemySpeedSetter.value = enemyData.get("speed")


func _on_move_placed_enemy_clicked(button):
	if parent.parent.ENTITIES_TO_PLACE:
		var enemies = parent.parent.ENTITIES_TO_PLACE.get("enemy")
		for key in enemies.keys():
			if enemies.get(key).get("type") == "enemy" and str(key) == str(button.name):
				var enemy = enemies.get(key).get("enemy_data")
				var texture = load("res://Game Assets/MapEditor/Enemy/" + enemy.enemyType + "_" + enemy.enemyVariant + ".png")
				parent.parent.remove_child(button)
				button.queue_free()
				move_enemy_editor_mode.emit(str(key), texture, enemy)
			elif enemies.get(key).get("type") == "spawnpoint" and str(key) == str(button.name):
				var enemy = enemies.get(key)
				var texture = load("res://Game Assets/MapEditor/spawnpoints.png")
				parent.parent.remove_child(button)
				button.queue_free()
				move_enemy_editor_mode.emit(str(key), texture, enemy)


func _on_delete_placed_enemy_clicked(button):
	parent.parent.remove_child(button)
	delete_enemy.emit(oldEnemy, str(button.name).replace("_",":"))


func _on_enemy_selected(selectedEnemyName: String, texture) -> void:
	_open_enemy_editor_dialog(selectedEnemyName, true)
	selectedTexture = texture


func _on_enemy_difficulty_selected(index):
	selectedEnemyDifficulty = difficultySelection.get_item_text(index)
	if  selectedEnemyDifficulty == "select":
		_reset_values(false)
		_toggle_button_disability()
	elif index != 0 and meleeSelection.disabled == true:
		_toggle_button_disability()
	_set_values_based_on_difficulty(selectedEnemyDifficulty)


func _on_error_timer_timeout():
	errorLabel.visible = false
	errorLabel.text = ""


func _on_melee_selection_pressed():
	if selectedEnemyType == rangedSelection.text:
		rangedSelection.button_pressed = false
	selectedEnemyType = meleeSelection.text
	


func _on_ranged_selection_pressed():
	if selectedEnemyType == meleeSelection.text:
		meleeSelection.button_pressed = false
	selectedEnemyType = rangedSelection.text
	


func _on_infinite_enemy_spawn_pressed():
	if numberOfEnemiesToSpawn == customNumberOfEnemiesToSpawnSpin.text:
		customNumberOfEnemiesToSpawnSpin.button_pressed = false
	numberOfEnemiesToSpawn = infiniteNumberOfEnemiesToSpawnSpin.text
	customNumberOfEnemiesSpinner.editable = false
	
	

func _on_custom_enemy_spawn_pressed():
	if numberOfEnemiesToSpawn == infiniteNumberOfEnemiesToSpawnSpin.text:
		infiniteNumberOfEnemiesToSpawnSpin.button_pressed = false
	numberOfEnemiesToSpawn = customNumberOfEnemiesToSpawnSpin.text
	customNumberOfEnemiesSpinner.editable = true
	if not customNumberOfEnemiesToSpawnSpin.button_pressed:
		customNumberOfEnemiesSpinner.editable = false


func _on_spawn_cooldown_spinner_value_changed(value):
	spawnCooldown = value


func _on_health_points_value_changed(value):
	enemyHealthPoints = value


func _on_attack_points_value_changed(value):
	enemyAttackPoints = value


func _on_enemy_speed_value_changed(value):
	$CanvasLayer/EnemyEditor/EnemySpeedSettings/EnemySppeedLabel.text = str(value)
	enemySpeed = value
	

func _on_enemy_attack_speed_value_changed(value):
	$CanvasLayer/EnemyEditor/EnemySpeedSettings/EnemyAttackSpeedLabel.text = str(value)
	enemyAttackSpeed = value


func _on_enemy_cooldown_value_changed(value):
	$CanvasLayer/EnemyEditor/EnemySpeedSettings/EnemyCooldownSpeedLabel.text = str(value)
	enemyCooldown = value
	
func _on_number_of_enemies_spinner_value_changed(value):
	enemiesToSpawnNumber = value

func _on_check_if_disabled(event: InputEvent):
	if event.is_action_pressed("room_changer_click") and selectedEnemyDifficulty == "select" and errorLabel.text == "":
		show_error.emit("Select enemy difficulty!")


func _on_cancel_configuration():
	enemyEditor.visible = false
	isEnemyEdited = false
	get_tree().paused = false
	_reset_values(true)


func _single_enemy_selected():
	selectedEnemyAmount = "single"
	isEnemy = true
	enemyEditor.visible = true
	enemyAmountSelector.visible = false
	$CanvasLayer/EnemyEditor/ProceedToSpawnConfigurator.visible = false
	$CanvasLayer/EnemyEditor/ProceedButton.visible = true



func _multiple_enemies_selected():
	selectedEnemyAmount = "multiple"
	enemyEditor.visible = true
	isEnemy = false
	enemyAmountSelector.visible = false
	$CanvasLayer/EnemyEditor/EnemyEditorLabel.text = "Next"
	$CanvasLayer/EnemyEditor/ProceedToSpawnConfigurator.visible = true
	$CanvasLayer/EnemyEditor/ProceedButton.visible = false
	
func _on_proceed_to_spawn_configurator_pressed():
	print("gets clicked")
	get_tree().paused = false
	enemyEditor.visible = false
	$CanvasLayer/SpawnPointEditor.visible = true

func _on_select_multiple_enemy_button():
	multiple_enemy.emit()


func _on_select_single_enemy():
	single_enemy.emit()


func _on_proceed_button_pressed():
	if selectedEnemyType and selectedEnemyTypeName and selectedEnemyVariantName and enemySpeed and enemyAttackPoints and enemyHealthPoints  and enemyAttackSpeed and selectedEnemyDifficulty:
		if selectedEnemyAmount == "single":
			if not isEnemyEdited:
				get_tree().paused = false
				enemyToPlaceObject = ENEMY_DATA.new(float(enemySpeed)/1000, selectedEnemyTypeName, selectedEnemyVariantName, selectedEnemyType, enemyAttackSpeed, selectedEnemyDifficulty, enemyHealthPoints, enemyAttackPoints)
				enemyEditor.visible = false
				enemy_to_place_selected.emit(enemyToPlaceObject, selectedTexture)
				_reset_values(true)
			else:
				get_tree().paused = false
				enemyEditor.visible = false
				var newEnemyData = ENEMY_DATA.new(float(enemySpeed)/1000, selectedEnemyTypeName, selectedEnemyVariantName, selectedEnemyType, enemyAttackSpeed, selectedEnemyDifficulty, enemyHealthPoints, enemyAttackPoints)
				pressedEnemy.name = str(newEnemyData)
				edit_enemy_editor_mode.emit(newEnemyData, oldEnemy)
				_reset_values(true)
				isEnemyEdited = false
		else:
			if spawnCooldown:
				if not isEnemyEdited:
					get_tree().paused = false
					var newEnemyData = ENEMY_DATA.new(float(enemySpeed)/1000, selectedEnemyTypeName, selectedEnemyVariantName, selectedEnemyType, enemyAttackSpeed, selectedEnemyDifficulty, enemyHealthPoints, enemyAttackPoints)
					var newSpawnPoint = spawnPointLoaded.instantiate()
					newSpawnPoint.initialitze(enemiesToSpawnNumber, spawnCooldown, newEnemyData)
					$CanvasLayer/SpawnPointEditor.visible = false
					place_spawn_point.emit(newSpawnPoint)
					_reset_values(true)
				else:
					isEnemyEdited = false
					get_tree().paused = false
					$CanvasLayer/SpawnPointEditor.visible = false
					var newEnemyData = ENEMY_DATA.new(float(enemySpeed)/1000, selectedEnemyTypeName, selectedEnemyVariantName, selectedEnemyType, enemyAttackSpeed, selectedEnemyDifficulty, enemyHealthPoints, enemyAttackPoints)
					var newSpawnPoint = spawnPointLoaded.instantiate()
					newSpawnPoint.initialitze(enemiesToSpawnNumber, spawnCooldown, newEnemyData)
					pressedEnemy.name = str(newSpawnPoint)
					edit_enemy_editor_mode.emit(newSpawnPoint, oldEnemy)
					_reset_values(true)
