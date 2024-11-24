extends Node

class_name USER

@onready var charConfig = CHARACTER_CONFIG.new()

@export var userID: String
@export var username: String
@export var character: String
@export var characterType: String
@export var userMapPath: String
@export var totalPoints: int
@export var userFolderPath: String


const fallbackCharacterType = 'Knight'
const fallbackCharacter = 'Knight1'

func get_char_type(character: String):
	if character:
		characterType = charConfig.sprites.get(character)
		
		
func load_points(user: String):
	pass #TODO load the points on login !!!

