extends Node2D

var charConfig = CHARACTER_CONFIG.new()

var sprites = charConfig.sprites
var index = 0
@onready var characterContainer = $CanvasLayer/CharacterContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	var parallax = PARALLAX.new()
	add_child(parallax)
	_show_character(0)
	
func _show_character(i: int):
	print(characterContainer.get_child_count())
	if characterContainer.get_child_count() > 0:
		for n in characterContainer.get_children():
			characterContainer.remove_child(n)
			n.queue_free()

	if characterContainer.get_child_count() == 0:
		var animMaker = ANIMATION_MAKER.new()
		var selectedCharacterKey = sprites.keys()[i]
		var selectedCharacterVariant = sprites.get(selectedCharacterKey)
		var selectedCharacterNode = AnimatedSprite2D.new()
		var animPlayer = AnimationPlayer.new()
		characterContainer.add_child(animPlayer)
		characterContainer.add_child(selectedCharacterNode)
		animMaker.make_animation('Player/Assets',  selectedCharacterVariant, selectedCharacterKey +"/", 0.08,'',animPlayer, 'playerLibrary',selectedCharacterNode)
		selectedCharacterNode.scale = Vector2(0.09, 0.09)
		selectedCharacterNode.position = Vector2(characterContainer.size.x/2,characterContainer.size.y/2)
		$CanvasLayer/CharacterName.text = selectedCharacterKey
		animPlayer.play('playerLibrary/idle')
		
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
	var collection = await Firebase.Firestore.collection("users")
	var document = await collection.get_doc(UserData.userID)
	document.add_or_update_field("characterSet", true)
	document.add_or_update_field("character", sprites.keys()[index])
	await collection.update(document)
	UserData.character = sprites.keys()[index]
	get_tree().change_scene_to_file("res://main.tscn")
