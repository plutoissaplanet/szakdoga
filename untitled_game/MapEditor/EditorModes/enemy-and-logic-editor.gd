extends Node2D

#-------------------------------------- CONSTANTS ---------------------------------------------------
const textureScale = Vector2(0.1, 0.1)


#-------------------------------------- SIGNALS ---------------------------------------------------

signal enemy_placed()
signal show_error(error: String)




#-------------------------------------- VARIABLES ---------------------------------------------------

var selectedEnemyNode

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

var selectedEnemyDifficulty: String = "select"
var selectedEnemyType: String = ""
var enemySpeed: float = 0
var enemyAttackSpeed: int = 0
var enemyCooldown: int = 0
var enemyAttackPoints: int = 0
var enemyHealthPoints: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	_add_buttons_to_grids()
	_set_nodes_variables()
	_connect_signals()
	_add_difficulty_to_option_selection()



#-------------------------------------- SET UP FUNCTIONS ---------------------------------------------------
func _add_buttons_to_grids():
	var loadedTextures = FileLoader.load_assets_1_level_deep("res://Game Assets/MapEditor/Enemy/", ".png")
	for key in loadedTextures.keys():
		var button = TextureButton.new()
		button.custom_minimum_size = Vector2(90,90)
		button.texture_normal = loadedTextures.get(key)
		button.stretch_mode = TextureButton.STRETCH_SCALE
		button.ignore_texture_size = true
		button.pressed.connect(_on_enemy_selected.bind(key))
		$EnemySelection/ScrollContainer/GridContainer.add_child(button)

func _connect_signals():
	show_error.connect(_show_error)
		
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
	enemyCooldownSetter = $EnemyEditor/EnemySpeedSettings/EnemyCooldown
	errorLabel = $EnemyEditor/Error
	errorLabelTimer = $EnemyEditor/Error/Timer
	
	errorLabel.text = ""
	
	meleeSelection.gui_input.connect(_on_check_if_disabled)
	rangedSelection.gui_input.connect(_on_check_if_disabled)
	healthPointsSelection.gui_input.connect(_on_check_if_disabled)
	attackPointsSelection.gui_input.connect(_on_check_if_disabled)
	enemySpeedSetter.gui_input.connect(_on_check_if_disabled)
	enemyAttackSpeedSetter.gui_input.connect(_on_check_if_disabled)
	enemyCooldownSetter.gui_input.connect(_on_check_if_disabled)
	
func _show_error(error: String):
	errorLabelTimer.start()
	errorLabel.text = error
	errorLabel.visible = true
	

#-------------------------------------- LOGIC FUNCTIONS ---------------------------------------------------

func _open_enemy_editor_dialog(selectedEnemyName: String):
	$EnemyEditor.visible = true
	get_tree().paused = true
	
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
	enemyCooldownSetter.editable = !enemyCooldownSetter.editable
	
func _reset_values():
	pass
	
func _set_values_based_on_difficulty():
	pass
	
	
#-------------------------------------- SIGNALS AND BUTTONS SECTION ---------------------------------------------------

func _on_enemy_selected(selectedEnemyName: String) -> void:
	_open_enemy_editor_dialog(selectedEnemyName)


func _on_enemy_difficulty_selected(index):
	if difficultySelection.get_item_text(0) == "select":
		difficultySelection.remove_item(0)
		_toggle_button_disability()
	selectedEnemyDifficulty = difficultySelection.get_item_text(index)
	if not selectedEnemyDifficulty == "selected":
		_reset_values()
	_set_values_based_on_difficulty()


func _on_error_timer_timeout():
	errorLabel.visible = false
	errorLabel.text = ""


func _on_melee_selection_pressed():
	if selectedEnemyType == "":
		selectedEnemyType = meleeSelection.text
	elif selectedEnemyType == rangedSelection.text:
		selectedEnemyType = meleeSelection.text
		rangedSelection.button_pressed = false


func _on_ranged_selection_pressed():
	if selectedEnemyType == "":
		selectedEnemyType = rangedSelection.text
	elif selectedEnemyType == meleeSelection.text:
		selectedEnemyType = rangedSelection.text
		meleeSelection.button_pressed = false


func _on_health_points_value_changed(value):
	pass # Replace with function body.


func _on_attack_points_value_changed(value):
	pass # Replace with function body.


func _on_enemy_speed_value_changed(value):
	$EnemyEditor/EnemySpeedSettings/EnemySppeedLabel.text = str(value)
	

func _on_enemy_attack_speed_value_changed(value):
	$EnemyEditor/EnemySpeedSettings/EnemyAttackSpeedLabel.text = str(value)


func _on_enemy_cooldown_value_changed(value):
	$EnemyEditor/EnemySpeedSettings/EnemyCooldownSpeedLabel.text = str(value)
	

func _on_check_if_disabled(event: InputEvent):
	if event.is_action_pressed("room_changer_click") and selectedEnemyDifficulty == "select" and errorLabel.text == "":
		print("should start showing error")
		show_error.emit("Select enemy difficulty!")

