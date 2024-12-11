extends Node2D

class_name KEY

var texturePaths = ["res://GameplayThings/Key/key_small1.png", "res://GameplayThings/Key/key_small2.png", "res://GameplayThings/Key/key_small3.png"]
var player
var playerSpecialInventory
var keyID

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureButton.texture_normal = _load_random_key_texture()


func set_door_to_open(ID: String):
	keyID = ID
	

func _load_random_key_texture():
	var randomIndex = randf_range(0, texturePaths.size()-1)
	return load(texturePaths[randomIndex])


func _on_texture_button_pressed():
	if player:
		for child in player.get_children():
			if child.name == "SpecialInventory":
				playerSpecialInventory = child.get_children()[0]
		_add_to_player_special_inventory()
		

func _add_to_player_special_inventory():
	if player:
		var sprite = TextureRect.new()
		sprite.texture = $TextureButton.texture_normal
		sprite.custom_minimum_size = Vector2(30,30)
		sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		playerSpecialInventory.add_child(sprite)
		sprite.set_meta("ID", keyID)
		remove_child($TextureButton)


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player = body


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player = null



