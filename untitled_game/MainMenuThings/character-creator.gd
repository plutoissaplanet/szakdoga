extends Node2D

var sprites = {}
var index = 0
@onready var characterContainer = $CanvasLayer/CharacterContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	var parallax = PARALLAX.new()
	add_child(parallax)
	_load_all_characters("res://Creatures/Player/Assets/öszgyömösz/")
	_show_character(0)

func _load_all_characters(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var files = dir.get_next()
		while files != "":
			if not dir.current_is_dir():
				if not files.ends_with(".import"):
					var name = files.get_basename()
					sprites[name] = files
				files=dir.get_next()
		dir.list_dir_end()

func _show_character(i: int):
	if characterContainer.get_child_count() > 0:
		characterContainer.remove_child(characterContainer.get_child(0))
	
	if characterContainer.get_child_count() == 0:
		var selectedCharacterKey = sprites.keys()[i]
		var selectedCharacterTexture = sprites.get(selectedCharacterKey)
		var selectedCharacterNode = Sprite2D.new()
		selectedCharacterNode.texture = load("res://Creatures/Player/Assets/öszgyömösz/"+selectedCharacterTexture)
		selectedCharacterNode.scale = Vector2(0.09, 0.09)
		selectedCharacterNode.position = Vector2(characterContainer.size.x/2,characterContainer.size.y/2)
		characterContainer.add_child(selectedCharacterNode)
		print(selectedCharacterKey)
		
func _on_back_pressed():
	if index == 0:
		index = sprites.keys().size()-1
	else:
		index -= 1
	_show_character(index)


func _on_next_pressed():
	if index == sprites.keys().size()-1:
		index = 0
	else:
		index += 1
	_show_character(index)


func _on_save_pressed():
	pass # Replace with function body.
