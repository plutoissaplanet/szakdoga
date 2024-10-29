extends Node2D



#-------------------------------------- CONSTANTS ---------------------------------------------------
const textureScale = Vector2(0.1, 0.1)


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

var numberOfEnemiesToSpawn: String
var spawnCooldown: int


var loadedTextures = {}
var selectedTexture

var parent
var buttonsDictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	_add_buttons_to_grids()
	_set_nodes_variables()
	_connect_signals()
	_add_difficulty_to_option_selection()



#-------------------------------------- SET UP FUNCTIONS ---------------------------------------------------
func _add_buttons_to_grids():
	loadedTextures = FileLoader.load_assets_1_level_deep("res://Game Assets/MapEditor/Enemy/", ".png")
	for key in loadedTextures.keys():
		var button = TextureButton.new()
		button.custom_minimum_size = Vector2(90,90)
		button.texture_normal = loadedTextures.get(key)
		button.stretch_mode = TextureButton.STRETCH_SCALE
		button.ignore_texture_size = true
		button.pressed.connect(_on_enemy_selected.bind(key, button.texture_normal))
		$EnemySelection/ScrollContainer/GridContainer.add_child(button)

func _connect_signals():
	show_error.connect(_show_error)
	single_enemy.connect(_single_enemy_selected)
	multiple_enemy.connect(_multiple_enemies_selected)
	if parent is Node2D:
		parent.placed_enemy_clicked.connect(_on_placed_enemy_clicked)
		
func _add_animation_to_editor():
	pass
	
func _set_nodes_variables():
	difficultySelection = $EnemyEditor/SelectDifficulty/OptionButton
	meleeSelection = $EnemyEditor/EnemyTypeSelection/MeleeSelection
	rangedSelection = $EnemyEditor/EnemyTypeSelection/RangedSelection
	healthPointsSelection = $EnemyEditor/EnemySetStatistics/HealthPoints
	attackPointsSelection = $EnemyEditor/EnemySetStatistics/AttackPoints
	enemySpeedSetter = $EnemyEditor/EnemySpeedSettings/EnemySpeed
	enemyAttackSpeedSetter = $EnemyEditor/EnemySpeedSettings/EnemyAttackSpeed
	errorLabel = $EnemyEditor/Error
	errorLabelTimer = $EnemyEditor/Error/Timer
	enemyEditor =  $EnemyEditor
	enemyAmountSelector = $SpawnPointOrSingle
	
	infiniteNumberOfEnemiesToSpawnSpin = $SpawnPointEditor/NumberOfEnemies/Infinite
	customNumberOfEnemiesToSpawnSpin = $SpawnPointEditor/NumberOfEnemies/Custom
	customNumberOfEnemiesSpinner = $SpawnPointEditor/NumberOfEnemies/NumberOfEnemiesSpinner
	
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
	get_tree().paused = true
	if isFirstSelection:
		enemyAmountSelector.visible = true
	else:
		enemyEditor.visible = true

	
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
	
func _set_values_based_on_difficulty():
	pass
	
func _get_enemy_type_and_variant_from_file_name(selectedEnemyName: String) -> void:
	selectedEnemyTypeName = selectedEnemyName.split("_")[0]
	selectedEnemyVariantName = selectedEnemyName.split("_")[1]

func _create_placed_enemy_editor(button):
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
	
	
	var editEnemyButton = _create_placed_enemy_editor_buttons("res://Game Assets/MapEditor/Icons/pencil.png")
	editEnemyButton.pressed.connect(_on_edit_placed_enemy_clicked.bind(button))
	grid.add_child(editEnemyButton)
	
	var moveEnemyButton = _create_placed_enemy_editor_buttons("res://Game Assets/MapEditor/Icons/move.png")
	moveEnemyButton.pressed.connect(_on_move_placed_enemy_clicked.bind(button))
	grid.add_child(moveEnemyButton)
	
	var deleteEnemyButton = _create_placed_enemy_editor_buttons("res://Game Assets/MapEditor/Icons/Icons_03.png")
	deleteEnemyButton.pressed.connect(_on_delete_placed_enemy_clicked.bind(button))
	grid.add_child(deleteEnemyButton)

func _create_placed_enemy_editor_buttons(texturePath: String) -> TextureButton:
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
		_create_placed_enemy_editor(button)
	else:
		button.remove_child(button.get_children()[0])
		
		
func _on_edit_placed_enemy_clicked(button):
	var data = buttonsDictionary.get(button).get("enemyData")
	var enemyData
	
	if data is Marker2D:
		enemyData = data.enemyData
		selectedEnemyAmount = "multiple"
		print("data is marker")
	else:
		print("data is not marker")
		enemyData = data
		selectedEnemyAmount = "single"
	
	oldEnemy = data
	isEnemyEdited = true
	print("_on_edit_placed_enemy_clicked isEnemyEdited: ", isEnemyEdited)
	_open_enemy_editor_dialog(enemyData.enemyType + "_" + enemyData.enemyVariant, false)
	
	difficultySelection.selected = REQUIREMENTS.enemy_difficulty.keys().find(enemyData.enemyDifficulty) + 1

	if enemyData.enemyAttackType == "Melee":
		meleeSelection.button_pressed = true
		rangedSelection.button_pressed = false
	else:
		meleeSelection.button_pressed = false
		rangedSelection.button_pressed = true
	healthPointsSelection.value = enemyData.healthPoints
	attackPointsSelection.value = enemyData.attackPoints
	enemyAttackSpeedSetter.value = enemyData.enemyShootTime
	enemySpeedSetter.value = enemyData.speed


func _on_move_placed_enemy_clicked(button):
	move_enemy_editor_mode.emit(buttonsDictionary.get(button).get("enemyData"), buttonsDictionary.get(button).get("enemyToPlaceSprite").texture)
	parent.parent.remove_child(button)
	
	
func _on_delete_placed_enemy_clicked(button):
	parent.parent.remove_child(button)
	buttonsDictionary.erase(button)
	delete_enemy.emit(oldEnemy, button)
	

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

	_set_values_based_on_difficulty()


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
	$EnemyEditor/EnemySpeedSettings/EnemySppeedLabel.text = str(value)
	enemySpeed = value
	

func _on_enemy_attack_speed_value_changed(value):
	$EnemyEditor/EnemySpeedSettings/EnemyAttackSpeedLabel.text = str(value)
	enemyAttackSpeed = value


func _on_enemy_cooldown_value_changed(value):
	$EnemyEditor/EnemySpeedSettings/EnemyCooldownSpeedLabel.text = str(value)
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
	enemyEditor.visible = true
	enemyAmountSelector.visible = false
	$EnemyEditor/ProceedToSpawnConfigurator.visible = false
	$EnemyEditor/ProceedButton.visible = true



func _multiple_enemies_selected():
	selectedEnemyAmount = "multiple"
	enemyEditor.visible = true
	enemyAmountSelector.visible = false
	$EnemyEditor/EnemyEditorLabel.text = "Next"
	$EnemyEditor/ProceedToSpawnConfigurator.visible = true
	$EnemyEditor/ProceedButton.visible = false
	
func _on_proceed_to_spawn_configurator_pressed():
	enemyEditor.visible = false
	$SpawnPointEditor.visible = true

func _on_select_multiple_enemy_button():
	multiple_enemy.emit()


func _on_select_single_enemy():
	single_enemy.emit()


func _on_proceed_button_pressed():
	if selectedEnemyType and selectedEnemyTypeName and selectedEnemyVariantName and enemySpeed and enemyAttackPoints and enemyHealthPoints  and enemyAttackSpeed and selectedEnemyDifficulty:
		if selectedEnemyAmount == "single":
			if not isEnemyEdited:
				get_tree().paused = false
				enemyToPlaceObject = ENEMY_DATA.new(float(enemySpeed), selectedEnemyTypeName, selectedEnemyVariantName, selectedEnemyType, enemyAttackSpeed, selectedEnemyDifficulty, enemyHealthPoints, enemyAttackPoints)
				enemyEditor.visible = false
				enemy_to_place_selected.emit(enemyToPlaceObject, selectedTexture)
				_reset_values(true)
			else:
				get_tree().paused = false
				enemyEditor.visible = false
				var newEnemyData = ENEMY_DATA.new(float(enemySpeed), selectedEnemyTypeName, selectedEnemyVariantName, selectedEnemyType, enemyAttackSpeed, selectedEnemyDifficulty, enemyHealthPoints, enemyAttackPoints)
				buttonsDictionary.get(oldEnemyButton)["enemyData"] = newEnemyData
				edit_enemy_editor_mode.emit(newEnemyData, oldEnemy)
				_reset_values(true)
				isEnemyEdited = false
		else:
			if spawnCooldown and ((numberOfEnemiesToSpawn == "Infinite") || (numberOfEnemiesToSpawn == "Custom" && enemiesToSpawnNumber != 0)):
				if not isEnemyEdited:
					get_tree().paused = false
					var newEnemyData = ENEMY_DATA.new(float(enemySpeed), selectedEnemyTypeName, selectedEnemyVariantName, selectedEnemyType, enemyAttackSpeed, selectedEnemyDifficulty, enemyHealthPoints, enemyAttackPoints)
					var newSpawnPoint = ENEMY_SPAWN_POINT.new(enemiesToSpawnNumber, spawnCooldown, newEnemyData, parent)
					$SpawnPointEditor.visible = false
					place_spawn_point.emit(newSpawnPoint)
					_reset_values(true)
				else:
					isEnemyEdited = false
					get_tree().paused = false
					$SpawnPointEditor.visible = false
					var newEnemyData = ENEMY_DATA.new(float(enemySpeed), selectedEnemyTypeName, selectedEnemyVariantName, selectedEnemyType, enemyAttackSpeed, selectedEnemyDifficulty, enemyHealthPoints, enemyAttackPoints)
					var newSpawnPoint = ENEMY_SPAWN_POINT.new(enemiesToSpawnNumber, spawnCooldown, newEnemyData, parent)
					buttonsDictionary.get(oldEnemyButton)["enemyData"] = newSpawnPoint
					edit_enemy_editor_mode.emit(newSpawnPoint, oldEnemy)
					_reset_values(true)
