extends Node2D

@onready var cells = []
@onready var rect
@onready var problem = []
@onready var container1 = get_node("Container")
@onready var container2 = get_node("Container/Container")
@onready var hbox= get_node("Container/HBoxContainer")
@onready var vbox= get_node("Container/VBoxContainer")



@onready var riddle1 = [
		[[1], [1], [1, 1], [10],[1], [1, 1], [1, 2, 1], [1,1,1,1],[1,1,1,1], [1,1], [1, 3],[1,1,1,1], [1,1,1], [1,1],[1,1],[1,1],[1,1],[1,1],[1,1],[3,3]],
		[ 0, 0, 1, 1, 0, 0, 1, 1, 1, 0],
		[ 0, 1, 0, 1, 0, 1, 0, 0, 0, 1],
		[ 1, 0, 0, 1, 0, 0, 0, 0, 1, 0],
		[ 0, 0, 0, 1, 0, 0, 0, 1, 0, 0],
		[ 0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
		[ 0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
		[ 0, 0, 0, 1, 0, 0, 0, 1, 0, 0],
		[ 0, 0, 0, 1, 0, 0, 0, 0, 1, 0],
		[ 0, 0, 0, 1, 0, 1, 0, 0, 0, 1],
		[ 0, 0, 1, 1, 1, 0, 1, 1, 1, 0]
	]
	
@onready var riddle2 = [
	[[1, 1], [2, 2], [1,1,1,1], [1,1,1], [1,1], [1,1], [1,1], [1,1,1],[1,1,1,1],[2,2], [1], [1,1], [1,1], [3,3], [1,1], [1,1], [1,1,1],[1,1,1,1],[1,1,1,1], [3,2]],
	[0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
	[0, 0, 0, 0, 1, 0, 1, 0, 0, 0],
	[0, 0, 0, 1, 0, 0, 0, 1, 0, 0],
	[1, 1, 1, 0, 0, 0, 0, 0, 1, 1],
	[0, 1, 0, 0, 0, 0, 0, 0, 0, 1],
	[0, 0, 1, 0, 0, 0, 0, 0, 1, 0],
	[0, 0, 0, 1, 0, 1, 0, 1, 0, 0],
	[0, 0, 1, 0, 1, 0, 1, 0, 1, 0],
	[0, 1, 0, 1, 0, 0, 0, 1, 0, 1],
	[1, 1, 1, 0, 0, 0, 0, 0, 1, 1]
	
]
@onready var riddle3 = [
	[[0], [0], [1], [3], [2,1], [2,4], [2,1], [3], [1], [0], [0], [1], [3], [2,2], [2,2],[2,2], [1], [1], [1], [1]],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
	[0, 0, 0, 0, 1, 1, 1, 0, 0, 0],
	[0, 0, 0, 1, 1, 0, 1, 1, 0, 0],
	[0, 0, 1, 1, 0, 0, 0, 1, 1, 0],
	[0, 0, 0, 1, 1, 0, 1, 1, 0, 0],
	[0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 1, 0, 0, 0, 0]
]

@onready var riddle4 = [
	[[5], [1], [1], [5], [0], [4,1], [1,1,1], [1,1,1], [1,1,1], [1,2], [1,5], [1,1], [1,1], [1,1], [4,2], [1,1], [1,1], [1,1],[1,4], [0]],
	[1, 0, 0, 0, 0, 1, 1, 1, 1, 1],
	[1, 0, 0, 0, 0, 1, 0, 0, 0, 0],
	[1, 0, 0, 0, 0, 1, 0, 0, 0, 0],
	[1, 0, 0, 0, 0, 1, 0, 0, 0, 0],
	[1, 1, 1, 1, 0, 0, 1, 1, 0, 0],
	[0, 0, 0, 1, 0, 0, 0, 0, 1, 0],
	[0, 0, 0, 1, 0, 0, 0, 0, 0, 1],
	[0, 0, 0, 1, 0, 0, 0, 0, 0, 1],
	[0, 0, 0, 1, 0, 1, 1, 1, 1, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	
]
	
@onready var solutions = [riddle1.slice(1,riddle1.size()+1), riddle2.slice(1, riddle2.size()+1), riddle3.slice(1, riddle3.size()+1), riddle4.slice(1, riddle4.size()+1)]
@onready var solutions_unsliced = [riddle1, riddle2, riddle3, riddle4]
@onready var riddle_index = randi_range(0, solutions.size()-1)

@onready var riddle_rows = solutions[riddle_index].size()
@onready var riddle_cols = solutions[riddle_index][0].size()

@onready var solved = false

signal minigame_completed
var difficulty

# Called when the node enters the scene tree for the first time.
func _ready():
	var spacing = 2
	text()
	initialize_problem()
	
	for i in range(riddle_rows):
		var row = []
		for j in range(riddle_cols):
			rect =  ColorRect.new()
			rect.size=Vector2(21,21)
			rect.position=Vector2(j*(rect.size.x+spacing), i*(rect.size.y+spacing))
			container2.add_child(rect)
			row.append(rect)
		cells.append(row)
		
	connect_cells()
	size_and_position()
	print(solutions[riddle_index])
	
func _process(_delta):
	gameplay()

	
func connect_cells():
	for i in range(riddle_rows):
		for j in range(riddle_cols):
			cells[i][j].gui_input.connect(onClick.bind(i,j))

func initialize_problem():
	for i in range(riddle_rows):
		var row = []
		for j in range(riddle_cols):
			row.append(0)
		problem.append(row)

func onClick(_event,i,j):
	if Input.is_action_pressed("room_changer_click"):
		cells[i][j].color=Color(0,0,0)
		problem[i][j]=1
	if Input.is_action_pressed("right_mouse_button"):
		cells[i][j].color=Color(1,0,0)
		problem[i][j]=0


func gameplay():
	if  problem == solutions[riddle_index]:
		solved=true
		minigame_completed.emit()


func size_and_position():
	var cont1_size_x= container1.size.x
	var cont1_size_y=container1.size.y
	var cont1_pos=Vector2(get_viewport_rect().size.x/2-cont1_size_x/2,get_viewport_rect().size.y/2-cont1_size_y/2)

	var cont2_size_x = container2.size.x
	var cont2_size_y = container2.size.y
	var cont2_pos=Vector2(cont1_size_x-cont2_size_x, cont1_size_y-cont2_size_y)
	
	container1.position=cont1_pos
	container2.position=cont2_pos
	
	vbox.position=Vector2(cont2_pos.x-70, cont2_pos.y-5)
	hbox.position=Vector2(cont2_pos.x, cont2_pos.y-100)
	$Background/TextureRect.position = $Container.position + Vector2(15,10)
	$Background/TextureRect.size = $Container.size+ Vector2(90,90)
	
	
	
func text():
	var temp = solutions_unsliced[riddle_index]
	var temp_pop
	var max_arr_size = 0
	
	for i in range(temp[0].size()/2):
		var arr_size = temp[0][i].size()
		if arr_size > max_arr_size:
			max_arr_size = arr_size
	
	print(temp[0].size())
	
	for i in range(temp[0].size()):
		
		if i > riddle_cols-1:
			temp_pop= temp[0][i]
			var row_text=""
			for j in range(temp_pop.size()):
				row_text += str(temp_pop[j])+" "
			#print(row_text)
			var txt = Label.new()
			txt.text=row_text.left(row_text.length()-1)
			vbox.add_child(txt)
		else:
			temp_pop=temp[0][i]
			var horiz_text=""
			var temppop_size = temp_pop.size()
			
			for j in range(max_arr_size-temppop_size):
				temp_pop.push_front(" ")
			for j in range(temp_pop.size()):
				horiz_text += str(temp_pop[j])+"\n"
			#print(row_text)
			var txt = Label.new()
			txt.text=horiz_text.left(horiz_text.length()-1)
			hbox.add_child(txt)
