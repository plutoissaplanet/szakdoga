extends Node2D

var font = preload("res://Game Assets/Font/CraftPixNet Survival Kit.otf")

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/ScrollContainer/OtherPositions.add_theme_constant_override("h_separation", 50)
	$CanvasLayer/Podium.add_theme_constant_override("h_separation", 50)
	var result = await POINTS_MANAGER.load_points_from_database()

	
	#for place in result:
		#invertedResult[int(place.document.get("points").get("integerValue"))] = place.doc_name
		#
	#print(invertedResult)
	
	var pointsArray = {}
	var combinedArray = []
	
	for place in result:
		combinedArray.append([place.doc_name,int(place.document.get("points").get("integerValue"))])
	
	for element in combinedArray:
		for element2 in combinedArray:
			var point = element[1]
			var tempName = element[0]
			var point2 = element2[1]
			if element[0] != element2[0] and point > point2:
				element[0] = element2[0]
				element[1] = element2[1]
				element2[0] = tempName
				element2[1] = point
				
	print(combinedArray)
	
	for element in range(0, combinedArray.size()):
		match element+1:
			1:
				_create_placeholders(combinedArray[element][0], combinedArray[element][1], $CanvasLayer/Podium, Color.GOLD, element+1)
			2:
				_create_placeholders(combinedArray[element][0], combinedArray[element][1], $CanvasLayer/Podium, Color.SILVER, element+1)
			3:
				_create_placeholders(combinedArray[element][0], combinedArray[element][1], $CanvasLayer/Podium, Color.SADDLE_BROWN, element+1)
			_:
				_create_placeholders(combinedArray[element][0], combinedArray[element][1],$CanvasLayer/ScrollContainer/OtherPositions , Color("#3d253b"), element+1)


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _create_placeholders(user: String, points: int, grid: GridContainer,color: Color, placement: int = 0):

	var userlabel = Label.new()
	userlabel.add_theme_color_override("font_color", color)
	userlabel.add_theme_font_override("font", font)
	userlabel.add_theme_font_size_override("font_size", 28)
	userlabel.text = user
	
	var placementLabel = Label.new()
	placementLabel.add_theme_color_override("font_color", color)
	placementLabel.add_theme_font_override("font", font)
	placementLabel.add_theme_font_size_override("font_size", 28)
	placementLabel.text = str(placement)
	
	var pointsLabel = Label.new()
	pointsLabel.add_theme_color_override("font_color", color)
	pointsLabel.add_theme_font_override("font", font)
	pointsLabel.add_theme_font_size_override("font_size", 28)
	pointsLabel.text = str(points)

	grid.add_child(placementLabel)
	grid.add_child(userlabel)
	grid.add_child(pointsLabel)

