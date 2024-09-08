extends Node

class_name USER

@onready var charConfig = CHARACTER_CONFIG.new()

@export var userID: String
@export var username: String
@export var character: String
@export var characterType: String

func get_char_type(character: String):
	if character:
		characterType = charConfig.sprites.get(character)
		
		

