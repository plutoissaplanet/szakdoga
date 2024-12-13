extends Node2D

var numberOfRooms
var currentRoom = 1
var doorConnections = {}
var DOORS_TO_PLACE = {}
var MINIGAMES_TO_PALCE = {}


var selectedTexture

var selectedMinigame: String = "Wiring"
var selectedDifficulty: String = "easy"
var selectedReward: String
var selectedTexturePath: String

var textures

var textureGrid
var minigameSelector: OptionButton
var minigameConfigurator
var difficultySelector: OptionButton
var keyCheckBox: CheckBox
var itemCheckBox: CheckBox



var minigame
var selectedMinigameButton
var miniGameSprite
var edited: bool
var moved: bool

var parent

signal doors_to_place_changed(dictionary)
signal minigames_to_palce_changed(dictionary)
signal MAX_AMOUNT_REACHED
signal MAX_AMOUNT_NOT_REACHED


# Called when the node enters the scene tree for the first time.
func _ready():
	_get_nodes()
	_load_textures()
	_create_buttons()
	_add_items_to_selector()
	_add_items_to_difficulty_selector()
	if get_parent() is Node2D:
		parent = get_parent()
		parent.mouse_in_floor_area.connect(_mouse_in_floor_area)
		parent.selected_room_changed.connect(_current_room_changed)
		
	MAX_AMOUNT_REACHED.connect(_block_feature)
	MAX_AMOUNT_NOT_REACHED.connect(_unblock_feature)


func _get_nodes():
	textureGrid = $ScrollContainer/GridContainer
	minigameSelector = $OptionButton
	minigameConfigurator = $MiniGameConfiguratorLayer
	difficultySelector = $MiniGameConfiguratorLayer/DifficultySelection/OptionButton
	keyCheckBox = $MiniGameConfiguratorLayer/Reward/CheckBox
	itemCheckBox = $MiniGameConfiguratorLayer/Reward/CheckBox2


func _connect_signals():
	get_parent().room_number_changed.connect(_number_of_rooms_changed)


func _load_textures():
	textures = FileLoader.load_assets_1_level_deep("res://Game Assets/MapEditor/MinigamePlaces/", ".png")


func _block_feature(type: String, diff: String):
	pass
	
func _unblock_feature(type: String, diff: String):
	pass

func _create_buttons():
	for key in textures.keys():
		var button = TextureButton.new()
		button.texture_normal = textures.get(key)
		button.ignore_texture_size = true
		button.stretch_mode = TextureButton.STRETCH_SCALE
		button.custom_minimum_size = Vector2(50,50)
		button.pressed.connect(_on_texture_clicked.bind(key, textures.get(key)))
		textureGrid.add_child(button)


func _add_items_to_selector():
	minigameSelector.add_item("Wiring", 0)
	minigameSelector.add_item("Puzzle", 1)
	minigameSelector.add_item("Memory Game", 2)
	minigameSelector.add_item("Maze", 3)
	minigameSelector.add_item("Diamond Maze", 3)
	minigameSelector.add_item("Nanogram", 4)
	minigameSelector.add_item("Simon Says", 5)


func _add_items_to_difficulty_selector():
	difficultySelector.add_item("easy", 0)
	difficultySelector.add_item("medium", 1)
	difficultySelector.add_item("hard", 2)


func _number_of_rooms_changed(number):
	numberOfRooms = number


func _on_texture_clicked(textureName, texture):
	selectedTexture = texture
	selectedTexturePath = textureName
	$MiniGameConfiguratorLayer.visible = true


func _on_select_minigame(index):
	selectedMinigame = minigameSelector.get_item_text(index)


func _process(delta):
	if miniGameSprite:
		miniGameSprite.position = get_global_mouse_position()


func _reset_logic_configurator():
	difficultySelector.selected = 0
	keyCheckBox.button_pressed = false
	itemCheckBox.button_pressed = false
	
	

func _on_cancel_button_pressed():
	minigameConfigurator.visible = false
	minigameSelector.selected = 0
	selectedTexturePath = ""


func _on_proceed_button_pressed():
	if selectedDifficulty and selectedReward and selectedTexture:
		if not edited:
			minigameConfigurator.visible = false
			_reset_logic_configurator()
			_create_minigame_sprite()
			
		else:
			minigameConfigurator.visible = false
			MINIGAMES_TO_PALCE.get(str(selectedMinigameButton))["difficulty"] = selectedDifficulty
			MINIGAMES_TO_PALCE.get(str(selectedMinigameButton))["reward"] = selectedReward
			_reset_logic_configurator()
			edited = false
			minigames_to_palce_changed.emit(MINIGAMES_TO_PALCE)
			parent.requirementEditor.minigame_changed.emit("minigame", selectedDifficulty, false, true)


func _create_minigame_sprite():
	miniGameSprite = TextureRect.new()
	miniGameSprite.mouse_filter = Control.MOUSE_FILTER_IGNORE
	miniGameSprite.texture = selectedTexture
	miniGameSprite.position = get_global_mouse_position()
	miniGameSprite.z_index = 5

	parent.get_parent().add_child(miniGameSprite)
	

func _on_difficulty_selected(index):
	selectedDifficulty = difficultySelector.get_item_text(index)
	print("_____________")
	print("selectedDifficulty: ",selectedDifficulty)
	print("_____________")


func _on_key_check_box_checked():
	if selectedReward == itemCheckBox.text:
		itemCheckBox.button_pressed = false
	selectedReward = keyCheckBox.text


func _on_item_check_box_checked():
	if selectedReward == keyCheckBox.text:
		keyCheckBox.button_pressed = false
	selectedReward = itemCheckBox.text


func _mouse_in_floor_area(event: InputEvent):
	if event.is_action_pressed("room_changer_click") and miniGameSprite:
		parent.get_parent().remove_child(miniGameSprite)
		create_texture_button()
		miniGameSprite = null
		if not moved:
			MINIGAMES_TO_PALCE[str(minigame)] = {}
			MINIGAMES_TO_PALCE[str(minigame)]["position"] = minigame.position
			MINIGAMES_TO_PALCE[str(minigame)]["texturePath"] = "res://Game Assets/MapEditor/MinigamePlaces/" + selectedTexturePath + ".png"
			MINIGAMES_TO_PALCE[str(minigame)]["reward"] = selectedReward
			MINIGAMES_TO_PALCE[str(minigame)]["difficulty"] = selectedDifficulty
			MINIGAMES_TO_PALCE.get(str(minigame))["minigame_name"] = selectedMinigame
			MINIGAMES_TO_PALCE.get(str(minigame))["room"] = currentRoom
			parent.requirementEditor.minigame_changed.emit("minigame", selectedDifficulty, true, false)
		if moved:
			var oldData = MINIGAMES_TO_PALCE.get(str(selectedMinigameButton))
			MINIGAMES_TO_PALCE.erase(str(selectedMinigameButton))
			MINIGAMES_TO_PALCE[str(minigame)] = oldData
			MINIGAMES_TO_PALCE[str(minigame)]["position"] = get_global_mouse_position()
			selectedMinigameButton = null
			moved = false

			
		minigames_to_palce_changed.emit(MINIGAMES_TO_PALCE)
		

func create_texture_button(tPath: String = "OPTIONAL", pos: Vector2 = Vector2(-1,-1), buttonName: String = "OPTIONAL", reward: String = "OPTIONAL", difficulty: String = "OPTIONAL", minigameName: String = "OPTIONAL", room: String = "OPTIONAL"):
	minigame = TextureButton.new()
	if selectedTexture:
		minigame.texture_normal = selectedTexture
	else:
		minigame.texture_normal = load(tPath)
	minigame.pressed.connect(_placed_minigame_clicked.bind(minigame))
	minigame.z_index = 5

	if tPath == "OPTIONAL":
		minigame.position = get_global_mouse_position()
	else:
		minigame.position = pos
		minigame.name = str(buttonName)
		MINIGAMES_TO_PALCE[str(minigame)] = {}
		MINIGAMES_TO_PALCE[str(minigame)]["position"] = pos
		MINIGAMES_TO_PALCE[str(minigame)]["texturePath"] = tPath
		MINIGAMES_TO_PALCE[str(minigame)]["reward"] = reward
		MINIGAMES_TO_PALCE[str(minigame)]["difficulty"] = difficulty
		MINIGAMES_TO_PALCE[str(minigame)]["minigame_name"] = minigameName
		MINIGAMES_TO_PALCE[str(minigame)]["room"] = room
		minigames_to_palce_changed.emit(MINIGAMES_TO_PALCE)
		
	parent.get_parent().add_child(minigame)
	


func _placed_minigame_clicked(button):
	if parent and button.get_child_count() == 0:
		create_placed_minigame_editor(button)
	else:
		button.remove_child(button.get_child(0))


func create_placed_minigame_editor(button):
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
	
	var editEnemyButton = _create_placed_minigame_editor_buttons("res://Game Assets/MapEditor/Icons/pencil.png")
	editEnemyButton.pressed.connect(_on_edit_placed_minigame.bind(button))
	grid.add_child(editEnemyButton)
	
	var moveEnemyButton = _create_placed_minigame_editor_buttons("res://Game Assets/MapEditor/Icons/move.png")
	moveEnemyButton.pressed.connect(_on_move_placed_minigame.bind(button))
	grid.add_child(moveEnemyButton)
	
	var deleteEnemyButton = _create_placed_minigame_editor_buttons("res://Game Assets/MapEditor/Icons/Icons_03.png")
	deleteEnemyButton.pressed.connect(_on_delete_placed_minigame.bind(button))
	grid.add_child(deleteEnemyButton)


func _create_placed_minigame_editor_buttons(texturePath: String) -> TextureButton:
	var button = TextureButton.new()
	button.texture_normal = load(texturePath)
	button.ignore_texture_size = true
	button.stretch_mode = TextureButton.STRETCH_SCALE
	button.custom_minimum_size = Vector2i(20,20)
	
	return button


func _on_edit_placed_minigame(button):
	edited = true
	minigameConfigurator.visible = true
	selectedDifficulty = MINIGAMES_TO_PALCE.get(str(button)).get("difficulty")
	selectedTexture = button.texture_normal
	selectedMinigameButton = button
	if MINIGAMES_TO_PALCE.get(str(button)).get("reward") == "Key":
		keyCheckBox.button_pressed = true
		itemCheckBox.button_pressed = false
	else:
		itemCheckBox.button_pressed = true
		keyCheckBox.button_pressed = false


func _on_move_placed_minigame(button):
	parent.get_parent().remove_child(button)
	selectedTexture = button.texture_normal
	selectedMinigameButton = button
	moved = true
	_create_minigame_sprite()


func _on_delete_placed_minigame(button):
	parent.requirementEditor.minigame_changed.emit("minigame", MINIGAMES_TO_PALCE.get(str(button)).get("difficulty"), false, false)
	MINIGAMES_TO_PALCE.erase(str(button))
	parent.get_parent().remove_child(button)
	minigames_to_palce_changed.emit(MINIGAMES_TO_PALCE)

	

func _current_room_changed(room):
	currentRoom = room
	
