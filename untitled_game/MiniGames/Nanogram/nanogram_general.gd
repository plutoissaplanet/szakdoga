extends Node2D

@onready var cells = []
@onready var rect
@onready var problem = []
@onready var container1 = get_node("Container")
@onready var container2 = get_node("Container/Container")
	
@onready var riddle1 = [
		[0, 0, 1, 1, 0, 0, 1, 1, 1, 0],
		[0, 1, 0, 1, 0, 1, 0, 0, 0, 1],
		[1, 0, 0, 1, 0, 0, 0, 0, 1, 0],
		[0, 0, 0, 1, 0, 0, 0, 1, 0, 0],
		[0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
		[0, 0, 0, 1, 0, 0, 1, 0, 0, 0],
		[0, 0, 0, 1, 0, 0, 0, 1, 0, 0],
		[0, 0, 0, 1, 0, 0, 0, 0, 1, 0],
		[0, 0, 0, 1, 0, 1, 0, 0, 0, 1],
		[0, 0, 1, 1, 1, 0, 1, 1, 1, 0]
	]
	
@onready var riddle2 = [
	[1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
]
@onready var riddle3 = [
	[1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
]

@onready var riddle4 = [
	[1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
]
	
@onready var solutions = [riddle1, riddle2, riddle3, riddle4]
@onready var riddle_index = randi_range(0, solutions.size()-1)

@onready var riddle_rows = solutions[riddle_index].size()
@onready var riddle_cols = solutions[riddle_index][0].size()

# Called when the node enters the scene tree for the first time.
func _ready():
	var spacing = 2
	initialize_problem()
	print(solutions[riddle_index])

	for i in range(riddle_rows):
		var row = []
		for j in range(riddle_cols):
			rect =  ColorRect.new()
			rect.size=Vector2(20,20)
			rect.position=Vector2(j*(rect.size.x+spacing), i*(rect.size.y+spacing))
			container2.add_child(rect)
			row.append(rect)
		cells.append(row)
		
	connect_cells()
	size_and_position()
	
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

func onClick(event,i,j):
	if Input.is_action_pressed("room_changer_click"):
		cells[i][j].color=Color(0,0,0)
		problem[i][j]=1
	if Input.is_action_pressed("right_mouse_button"):
		cells[i][j].color=Color(1,0,0)
		problem[i][j]=0

func gameplay():
	if  problem == solutions[riddle_index]:
		print("success")


func size_and_position():
	var cont1_size_x= container1.size.x
	var cont1_size_y=container1.size.y
	var cont1_pos=Vector2(get_viewport_rect().size.x/2-cont1_size_x/2,get_viewport_rect().size.y/2-cont1_size_y/2)

	var cont2_size_x = container2.size.x
	var cont2_size_y = container2.size.y
	var cont2_pos=Vector2(cont1_size_x-cont2_size_x, cont1_size_y-cont2_size_y)
	
	container1.position=cont1_pos
	container2.position=cont2_pos
	
