extends Node2D

@export var numberOfLights: int #possible numbers: 3,4,6
var difficulty: String
@export var difficultySettings = {
	'easy': 4,
	'medium': 6,
	'hard': 8
}
var numberOfLightsDict = {
	'easy': 3,
	'medium': 4,
	'hard': 6
}

@onready var lightOffTexture = preload("res://Game Assets/Minigames/Wiring/lights_off.png")
var lightsOnTextures = {}
var solutionTextures = {}
var solution = []
var rects = []
var patternPhase: bool = true
var timerOut: bool = true
var currentSequence = []
var playerSequence = []
var currentSequenceIndex = 0
var currentSequenceLightIndex = 0

signal minigame_completed

func _ready():
	_load_all_lights_on_textures()
	numberOfLights = numberOfLightsDict.get(difficulty)
	_add_texture_rects_to_scene()
	_generate_sequence(difficulty)
	currentSequence = solution[currentSequenceIndex]
	_assign_colors_to_lights(difficulty)
	$Timer.start()

	
func _load_all_lights_on_textures():
	var path = "res://Game Assets/Minigames/Wiring/"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var texture = dir.get_next()
		while texture != "":
			if not dir.current_is_dir() and texture.begins_with('circle') and texture.ends_with('.png'):
				var texturePath = path + texture
				lightsOnTextures[texture.split('_')[1]] = load(texturePath)
			texture = dir.get_next()
		dir.list_dir_end()
	
func _add_texture_rects_to_scene():
	var gridSizing = _get_grid_sizes()
	for i in range(numberOfLights):
		var row = i / int(gridSizing.x)
		var col = int(i % int(gridSizing.x))
		var textureRect = TextureRect.new()
		textureRect.texture = lightOffTexture
		textureRect.gui_input.connect(clicked_on_a_light.bind(i))
		textureRect.position = Vector2(col * 100, row * 100)
		rects.append(textureRect)
		$Lights.add_child(textureRect)
		$Background/TextureRect.size = Vector2(col*200, row*300)
		$Lights.position = Vector2i(60,40)
		$Background/Label.position = Vector2($Background/TextureRect.size.x/2-60, $Background/TextureRect.size.y - 50)

func _generate_sequence(difficulty: String):
	for i in range(difficultySettings.get(difficulty)):
		var sequenceSegment=[]
		var lightSequenceNumber = randi_range(0, numberOfLights-1)
		sequenceSegment.append(lightSequenceNumber)
		if i == 0:
			solution.append(sequenceSegment)
		else:
			var temporarySegment = solution[i-1].duplicate()
			temporarySegment.append(lightSequenceNumber)
			solution.append(temporarySegment)
		
	
func _assign_colors_to_lights(difficulty: String):
	var colors = ['blue', 'green', 'orange', 'purple', 'red', 'yellow']
	for i in range(numberOfLights):
		var randomColor = colors.pick_random()
		solutionTextures[i] = randomColor
		colors.erase(randomColor)
		

func _light_up_pattern_sequence(sequence: Array, index: int):
	var currentColor = solutionTextures.get(sequence[index])
	print(currentColor)
	var texture = lightsOnTextures.get(currentColor)
	rects[sequence[index]].texture = texture

	
func clicked_on_a_light(event, light):
	if Input.is_action_just_pressed("room_changer_click") and !patternPhase:
		playerSequence.append(light)
		if playerSequence.size() == currentSequence.size():
			_validate_player_input()

func _validate_player_input():
	if playerSequence == currentSequence:
		currentSequenceIndex +=1
		if currentSequenceIndex < solution.size():
			currentSequence = solution[currentSequenceIndex]
			playerSequence.clear()
			$Timer.start()
			patternPhase = false
		else:
			$Timer.stop()
			minigame_completed.emit()
	else:
		$Background/ErrorTimer.start()
		$Background/Label.visible = true
		solution.clear()
		currentSequence.clear()
		playerSequence.clear()
		currentSequenceLightIndex = 0
		currentSequenceIndex = 0
		patternPhase = true
		_generate_sequence(difficulty)
		currentSequence = solution[currentSequenceIndex]
		$Timer.start()
	
func _get_grid_sizes():
	match numberOfLights:
		3:
			return Vector2(3,1)
		4:
			return Vector2(2,2)
		6:
			return Vector2(3,2)


func _on_timer_timeout():
	$Timer2.start()
	print("first timer out")
	if currentSequenceLightIndex < currentSequence.size():
		_light_up_pattern_sequence(currentSequence, currentSequenceLightIndex)
		currentSequenceLightIndex += 1
	else:
		$Timer.stop()
		$Timer2.stop()
		patternPhase=false
		currentSequenceLightIndex = 0


func _on_timer_2_timeout():
	print("second timer out")
	for rect in rects:
		rect.texture = lightOffTexture


func _on_error_timer_timeout():
	$Background/Label.visible = false
