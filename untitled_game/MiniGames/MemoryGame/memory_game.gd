extends Node2D

class_name MEMORY_GAME

var sprites: Dictionary = {}
var textureRectsAndTheirTexture: Dictionary = {}
var playerInputSequence: Array = []

var spacing = 80
var difficultySetting: Dictionary = {
	'easy': Vector2(2,2),
	'medium': Vector2(4,4),
	'hard': Vector2(6,6)
}
var selectedTextures = []
var selectedTextureKeys = []
var selectedTexturesDuplicate = []
var selectedTextureKeysDuplicate = []
var previousPicture: TextureRect
var timerIsOut: bool = false
@onready var upsideDownTexture = load("res://Game Assets/GUI/backdrop.png")
@export var difficulty: String
signal minigameCompleted

func _ready():
	difficulty = 'hard'
	_load_picture_textures()
	_choose_number_of_pictures()
	_add_rects_to_scene()
	_position_children()
	selectedTextureKeysDuplicate = selectedTextureKeys.duplicate(true)
	$Timer.start()



func _load_picture_textures():
	var path = "res://Game Assets/Minigames/MemoryGame/"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var texture = dir.get_next()
		while texture != "":
			if not dir.current_is_dir() and texture.ends_with('.png'):
				var texturePath = path + texture
				sprites[texture] = texturePath #ITS NOT LOADED HERE!!! 
			texture = dir.get_next()
		dir.list_dir_end()
		
func _choose_number_of_pictures():
	var diff = difficultySetting.get(difficulty)
	var numberOfSelectedPictures = (diff.x * diff.y)/2
	var spritesDuplicate = sprites.duplicate(true)
	var spriteKeys = spritesDuplicate.keys()
	while numberOfSelectedPictures != 0:
		var randomIndex = randi_range(0,spriteKeys.size()-1)
		selectedTextures.append({spriteKeys[randomIndex]: 0})
		selectedTextureKeys.append(spriteKeys[randomIndex])
		spritesDuplicate.erase(spriteKeys[randomIndex])
		spriteKeys.remove_at(randomIndex)
		numberOfSelectedPictures -= 1
	selectedTexturesDuplicate = selectedTextures.duplicate(true)




func _add_rects_to_scene():
	var tableDimensions = difficultySetting.get(difficulty)

	var maxAttempts = selectedTextures.size() * 2
	for i in range(tableDimensions.x):
		for j in range(tableDimensions.y):

			var rect = TextureRect.new()
			rect.position = Vector2(i*spacing, j*spacing)
			var randomIndex = randi_range(0, selectedTextures.size()-1)
			var attempts = 0
			var textureName = selectedTextures[randomIndex].keys()[0]
			var howManyTimesIsItUsed = selectedTextures[randomIndex][textureName]
			rect.texture = load(sprites[textureName])
			howManyTimesIsItUsed += 1
			selectedTextures[randomIndex][textureName] = howManyTimesIsItUsed
			var values = selectedTextures[randomIndex].values()
			if values.has(2):
				selectedTextures.remove_at(randomIndex)
			rect.scale= Vector2(2.0,2.0)
			rect.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
			rect.gui_input.connect(_clicked_on_picture.bind(rect))
			textureRectsAndTheirTexture[rect] = rect.texture
			$Container.add_child(rect)
	
func _clicked_on_picture(_event ,picture: TextureRect) -> void:
	if timerIsOut and Input.is_action_just_pressed("room_changer_click") and playerInputSequence.size()<2:
		picture.scale = Vector2(2,2)
		playerInputSequence.append(picture)
		picture.texture = textureRectsAndTheirTexture.get(picture)
		
		if playerInputSequence.size() == 2:
			if playerInputSequence[0] == playerInputSequence[1]:
				playerInputSequence[0].texture = upsideDownTexture
				playerInputSequence[0].scale= Vector2(0.04,0.04)
				playerInputSequence.clear()
			else:
				_verify_player_selected_rect_sequence()

func _verify_player_selected_rect_sequence():
	if playerInputSequence[0].texture == playerInputSequence[1].texture:
		for rect in playerInputSequence:
			$Container.remove_child(rect)
		playerInputSequence.clear()
	else:
		print("in else")
		$Timer2.start()

func _position_children():
	var pictureSize: Vector2 = $Container.get_children()[1].size
	var pictureContainerSize: Vector2
	var margin = 50
	$Container.size = difficultySetting.get(difficulty).x * pictureSize + Vector2( (difficultySetting.get(difficulty).x-2)*spacing,  (difficultySetting.get(difficulty).x-2)*spacing)
	pictureContainerSize = $Container.size
	$Container.position = Vector2(margin,margin)
	$RestartContainer.position = Vector2((margin+(pictureContainerSize.x-$RestartContainer.size.x)/2), (margin + pictureContainerSize.y+30))

func _on_timer_timeout():
	var rects = $Container.get_children()
	timerIsOut = true
	for rect in rects:
		rect.texture = upsideDownTexture
		rect.scale = Vector2(0.04, 0.04)

func _on_timer_2_timeout():
	for rect in playerInputSequence:
		rect.texture = upsideDownTexture
		rect.scale = Vector2(0.04,0.04)
	playerInputSequence.clear()

func _on_restart_button_pressed():
	playerInputSequence.clear()
	for child in $Container.get_children():
		$Container.remove_child(child)
	selectedTextureKeys = selectedTextureKeysDuplicate.duplicate(true)
	selectedTextures = selectedTexturesDuplicate.duplicate(true)
	_add_rects_to_scene()
	$Timer.start()
	
	
	
