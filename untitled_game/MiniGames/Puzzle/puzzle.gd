extends Node2D


var selectedPicturePath: String = ''
var pictureLoaded: CompressedTexture2D
var numberOfPieces: Vector2
var puzzlePieces = {}
var playerSequence = {}
var outOfOrderPieces = {}
var untouchedPuzzlePieces = {}
var outOfOrderPuzzlePieces2 = {}
var pictureFrame = TextureRect.new()
var scaling = Vector2(0.6, 0.6)
var pieceSizes: Vector2
var outOfOrderPiecesNumber = 4
var pieceInHand = false
var pieceParent = null
var placeParent = null
var pieceRotation: float
var lastMousePosition
var pieceInHandRect: TextureRect


var difficultySetting: Dictionary = {
	'easy': Vector2(4,4),
	'medium': Vector2(5,5),
	'hard': Vector2(6,6)
}

@export var difficulty: String

func _ready():
	difficulty = 'easy'
	_load_pictures()
	pictureLoaded = load(selectedPicturePath)
	pictureFrame.texture = pictureLoaded
	pictureFrame.visible = false
	add_child(pictureFrame)
	_sizing_and_positioning()
	print(scaling)
	_define_puzzle_pieces()
	_deep_copy_puzzle_piece_dictionary()
	_select_random_puzzle_pieces()
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pieceInHand = true
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if pieceInHandRect != null:
				if pieceParent and placeParent and placeParent.texture == null:
					placeParent.texture=pieceParent.texture
					playerSequence[placeParent] = placeParent.texture
					remove_child(pieceInHandRect)
					pieceInHandRect = null
					pieceParent = null
					placeParent = null
					pieceInHand = false
				else:
					pieceInHand = false
					pieceInHandRect.position = lastMousePosition
					pieceInHandRect.scale = scaling
					pieceInHandRect.rotation = pieceRotation
					pieceInHandRect = null


func _process(delta):
	if pieceInHand and pieceInHandRect != null:
		pieceInHandRect.position = get_viewport().get_mouse_position() - Vector2(pieceSizes.x/4, pieceSizes.y/4)
		lastMousePosition = get_viewport().get_mouse_position() - Vector2(pieceSizes.x/4, pieceSizes.y/4)


func _load_pictures() -> void:
	var path = "res://Game Assets/Minigames/Puzzle/"
	var dir = DirAccess.open(path)
	var randomPictureIndex = randi_range(0,20)
	if dir:
		dir.list_dir_begin()
		if randomPictureIndex == 0:
			var picture = dir.get_next()
			if not dir.current_is_dir():
				selectedPicturePath = path + picture
		else:
			var picture
			while randomPictureIndex != 0:
				picture = dir.get_next()
				randomPictureIndex -= 1
			if not dir.current_is_dir():
				if not picture.ends_with('.jpg'):
					picture = dir.get_next()
				selectedPicturePath = path + picture
		dir.list_dir_end()


func _define_puzzle_pieces() -> void:
	var area = pictureFrame.size.x * pictureFrame.size.y
	numberOfPieces = difficultySetting.get(difficulty)
	var pieceEdgeY = (pictureFrame.size.y) /numberOfPieces.y
	var pieceEdgeX = (pictureFrame.size.x) / numberOfPieces.x 
	pieceSizes = Vector2(pieceEdgeX, pieceEdgeY)
	var scaledPieceSizes = pieceSizes * scaling

	for i in range(numberOfPieces.x):
		for j in range(numberOfPieces.y):
			var x = i * pieceEdgeX
			var y = j * pieceEdgeY
			var atlasTexture = AtlasTexture.new()
			atlasTexture.atlas = pictureFrame.texture
			atlasTexture.region = Rect2(Vector2(x, y), pieceSizes)
			var newTextureRect = TextureRect.new()
			newTextureRect.texture = atlasTexture
			newTextureRect.position = Vector2(i * (pieceEdgeX*scaling.x+5), j * (pieceEdgeY*scaling.y+5))
			newTextureRect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			newTextureRect.size = scaledPieceSizes
			newTextureRect.scale=scaling
			$MainPuzzlePieces.add_child(newTextureRect)
			puzzlePieces[str(i)+str(j)] = newTextureRect


func _puzzle_piece_on_area_entered(piece, place):
	pieceParent = piece.get_parent()
	placeParent = place.get_parent()

func _puzzle_piece_on_area_exited(piece):
	placeParent = null
	pieceParent = null
	

func _out_of_order_piece_on_click(event, piece):
	if Input.is_action_just_pressed("room_changer_click"):
		piece.get_parent().remove_child(piece)
		pieceInHandRect = piece
		add_child(piece)
		pieceInHandRect.scale = scaling
		pieceRotation = pieceInHandRect.rotation
		pieceInHandRect.rotation = 0.0


func _puzzle_piece_place_on_click(event, place):
	if Input.is_action_just_pressed("room_changer_click") and place.texture != null:
		var newPiece = _make_piece_after_pickup(get_viewport().get_mouse_position() - Vector2(pieceSizes.x/2, pieceSizes.y/2), place.texture)
		place.texture = null
		newPiece.scale = scaling
		pieceInHandRect = newPiece
		
	
func _select_random_puzzle_pieces():
	var alreadyGenerated = [Vector2(-1,-1)]
	while alreadyGenerated.size() <= outOfOrderPiecesNumber:
		var randomIndexX = randi_range(0,numberOfPieces.x-1)
		var randomIndexY = randi_range(0,numberOfPieces.y-1)
		var vector = Vector2(randomIndexX, randomIndexY)
		if not alreadyGenerated.has(vector):
			vector = Vector2(randomIndexX, randomIndexY)
			alreadyGenerated.append(vector)
			var key = str(randomIndexX)+str(randomIndexY)
			outOfOrderPieces[key] = puzzlePieces.get(key)
			outOfOrderPuzzlePieces2[puzzlePieces.get(key)] =  puzzlePieces.get(key).texture
			puzzlePieces.get(key).texture = null
			puzzlePieces.get(key).gui_input.connect(_puzzle_piece_place_on_click.bind(puzzlePieces.get(key)))
	_make_out_of_order_puzzle_pieces()

func _make_out_of_order_puzzle_pieces():
	for i in range(outOfOrderPieces.size()):
		var key = outOfOrderPieces.keys()[i]
		var outOfOrderPuzzlePiecesTextureRect = TextureRect.new()
		var texture = untouchedPuzzlePieces.get(key).texture
		outOfOrderPuzzlePiecesTextureRect.texture = texture
		outOfOrderPuzzlePiecesTextureRect.position = Vector2(pictureFrame.size.x + 80, (pieceSizes.y +20)*i)
		outOfOrderPuzzlePiecesTextureRect.pivot_offset=Vector2(pieceSizes.x/2, pieceSizes.y/2)
		outOfOrderPuzzlePiecesTextureRect.rotation = i*60
		outOfOrderPuzzlePiecesTextureRect.scale = scaling
		outOfOrderPuzzlePiecesTextureRect.gui_input.connect(_out_of_order_piece_on_click.bind(outOfOrderPuzzlePiecesTextureRect))
		var area1 = _make_areas()
		var area2 = _make_areas()
		area1.area_entered.connect(_puzzle_piece_on_area_entered.bind(area1))
		area1.area_exited.connect(_puzzle_piece_on_area_exited)
		puzzlePieces.get(key).add_child(area1)
		outOfOrderPuzzlePiecesTextureRect.add_child(area2)
		$OutOfOrderPuzzlePieces.add_child(outOfOrderPuzzlePiecesTextureRect)

func _make_piece_after_pickup(positionOfThePiece, texture):
	var newPiece = TextureRect.new()
	newPiece.texture = texture
	newPiece.position = positionOfThePiece
	newPiece.scale = scaling
	newPiece.gui_input.connect(_out_of_order_piece_on_click.bind(newPiece))
	var area = _make_areas()
	newPiece.add_child(area )
	print(newPiece.scale)
	add_child(newPiece)
	return newPiece
	
	
func _make_areas():
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.size = pieceSizes*scaling
	area.add_child(collision)
	return area
	
func _deep_copy_puzzle_piece_dictionary():
	for i in range(puzzlePieces.keys().size()):
		var key = puzzlePieces.keys()[i]
		var oldPiece = puzzlePieces.get(key)
		var newPiece = TextureRect.new()
		newPiece.texture = oldPiece.texture
		untouchedPuzzlePieces[key] = newPiece
		
		

func _verify_player_sequence():
	print( "outOfOrderPuzzlePieces2", outOfOrderPuzzlePieces2)
	print("playerSequence", playerSequence)
	if(playerSequence == outOfOrderPuzzlePieces2):
		print("success")
	else:
		print("failed")
	
	
func _sizing_and_positioning():
	if pictureFrame.size.y > 400:
		pictureFrame.scale = scaling
	$MainPuzzlePieces.custom_minimum_size = pictureFrame.size * scaling
	$MainPuzzlePieces.size = pictureFrame.size * scaling
	$MainPuzzlePieces.scale= scaling
	$OutOfOrderPuzzlePieces.scale = scaling

