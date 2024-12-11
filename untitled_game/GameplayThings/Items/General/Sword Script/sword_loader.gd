extends Node

@export var player: CharacterBody2D
@export var room: Node2D

@onready var swordRescourcesLvlLow = []
@onready var swordRescourcesLvlMedium = []
@onready var swordRescourcesLvlHigh = []

func _ready():
	swordRescourcesLvlLow=[
		preload("res://Gameplay_Things/Items/Swords/Rescources/sword_lower_level_1.tres"),
		preload("res://Gameplay_Things/Items/Swords/Rescources/sword_lower_level_2.tres"),
		preload("res://Gameplay_Things/Items/Swords/Rescources/sword_lower_level_3.tres")
	]
	swordRescourcesLvlMedium=[
		preload("res://Gameplay_Things/Items/Swords/Rescources/sword_medium_level_1.tres"),
		preload("res://Gameplay_Things/Items/Swords/Rescources/sword_medium_level_2.tres"),
		preload("res://Gameplay_Things/Items/Swords/Rescources/sword_medium_level_3.tres")
	]
	swordRescourcesLvlHigh =[
		preload("res://Gameplay_Things/Items/Swords/Rescources/sword_higher_level_1.tres"),
		preload("res://Gameplay_Things/Items/Swords/Rescources/sword_higher_level_2.tres"),
		preload("res://Gameplay_Things/Items/Swords/Rescources/sword_higher_level_3.tres"),
		preload("res://Gameplay_Things/Items/Swords/Rescources/sword_higher_level_4.tres"),
	]


func place_lower_level_swords():
	pass
