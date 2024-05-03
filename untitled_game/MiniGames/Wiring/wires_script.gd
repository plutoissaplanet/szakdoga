extends Node2D

@onready var cont = get_node("Container")
@onready var cont_circles = Container.new()

@onready var colors = []
@onready var wireColors = []
@onready var random_color_index 
@onready var cols1 = []
@onready var cols2 = []
@onready var circles_area1 = []
@onready var circles_area2 = []
@onready var circles_area
@onready var circles
@onready var wire




func _ready():
	load_colors()
	draw_circles()


func _process(delta):
	pass


func load_colors():
	var blue_circle = load("res://Game Assets/Minigames/Wiring/circle_blue_png.png")
	var green_circle= load("res://Game Assets/Minigames/Wiring/circle_green_png.png")
	var orange_circle= load("res://Game Assets/Minigames/Wiring/circle_orange_png.png")
	var purple_circle= load("res://Game Assets/Minigames/Wiring/circle_purple_png.png")
	var red_circle= load("res://Game Assets/Minigames/Wiring/circle_red_png.png")
	var yellow_circle= load("res://Game Assets/Minigames/Wiring/circle_yellow_png.png")
	
	var blue_wire = load("res://Game Assets/Minigames/Wiring/wire_blue.jpg")
	var green_wire = load("res://Game Assets/Minigames/Wiring/wire_green.jpg")
	var orange_wire = load("res://Game Assets/Minigames/Wiring/wire_orange.jpg")
	var purple_wire = load("res://Game Assets/Minigames/Wiring/wire_purple.jpg")
	var red_wire = load("res://Game Assets/Minigames/Wiring/wire_red.jpg")
	var yellow_wire = load("res://Game Assets/Minigames/Wiring/wire_yellow.jpg")
	
	colors = [blue_circle, green_circle, orange_circle, purple_circle, red_circle,yellow_circle]
	wireColors = [blue_wire, green_wire, orange_wire, purple_wire, red_wire, yellow_wire]
	
	
func draw_circles():

	const nr_of_circles = 6
	const nr_of_cols = 2
	const spacing_y = 100
	const spacing_x= 300
	
	
	for i in range(nr_of_cols):
		for j in range(nr_of_circles):
			circles = TextureRect.new()
			circles.position = Vector2(i*(circles.size.x + spacing_x), j*(circles.size.y+spacing_y))
			
			if i == 0:
				cols1.append(circles)
				color_circles(cols1)
			elif i == 1:
				cols2.append(circles)
				color_circles(cols2)
			cont_circles.add_child(circles)
			

	connect_circles()
	pos_nodes(cont_circles)
	cont.add_child(cont_circles)
	print(cols1)

func color_circles(array):
	var temp = []
	for i in range(array.size()):
		random_color_index = randi_range(0,colors.size()-1)
		while temp.has(random_color_index):
			random_color_index = randi_range(0,colors.size()-1)
		array[i].texture = colors[random_color_index]
		temp.append(random_color_index)
		
	
func pos_nodes(temp):
	temp.size = Vector2(600, 300)
	var window_sizing=get_viewport_rect().size
	const circle_radius = 59
	
	print("cont_circle_size: ", temp)
	
	temp.position= Vector2(window_sizing.x/2-temp.size.x/4,25)
	print("temp pos: ", temp.position)
	
	
func onClick(event, c1, c1_array):
	
	if Input.is_action_pressed("room_changer_click"):
		createWire(c1,c1_array)
		var diff = get_viewport().get_mouse_position() - wire.global_position
		var angle = diff.angle()
		wire.rotation = angle
		wire.size.x=sqrt(event.position.y**2+event.position.x **2)
		
	if Input.is_action_just_released("room_changer_click"):
		c1.remove_child(wire)

func onClick2(event, c2, c2_array):
	if Input.is_action_pressed("room_changer_click"):
		createWire(c2, c2_array)
		var diff = get_viewport().get_mouse_position() - wire.global_position
		var angle = diff.angle()
		wire.rotation = angle
		wire.size.x=sqrt(event.position.y**2+event.position.x **2)
	if Input.is_action_just_released("room_changer_click"):
		c2.remove_child(wire)

func createWire(c, c_array):
	var index=c_array.find(c, 0)
	if c.get_child_count() == 0:
		wire = TextureRect.new()
		wire.texture=load("res://Game Assets/Minigames/Wiring/wire_base.jpg")
		wire.z_index = 2
		wire.position.x=c.size.x/2
		wire.position.y=c.size.y/2
		wire.pivot_offset = Vector2(wire.size.x/2, wire.size.y/2)
		
		if c.texture == colors[0]:
			wire.texture = wireColors[0]
		elif c.texture == colors[1]:
			wire.texture = wireColors[1]
		elif c.texture == colors[2]:
			wire.texture = wireColors[2]
		elif c.texture == colors[3]:
			wire.texture = wireColors[3]
		elif c.texture == colors[4]:
			wire.texture = wireColors[4]
		elif c.texture == colors[5]:
			wire.texture = wireColors[5]
			
		wire.set_meta("id", index)
		c.add_child(wire)
		c.set_meta("isClicked", true )
		print(index)
		print("wire id: ", wire.get_meta("id"))

func connect_circles():
	for i in range(cols1.size()):
		cols1[i].set_meta("id", i)
		cols1[i].set_meta("isClicked", false)
		cols1[i].gui_input.connect(onClick.bind(cols1[i], cols1))
		
		cols2[i].set_meta("id", i)
		cols2[i].set_meta("isClicked", false)
		cols2[i].gui_input.connect(onClick2.bind(cols2[i], cols2))
	
func connect_circle_areas():
	for i in range(circles_area1.size()):
		circles_area1[i].area_entered.connect(_on_area_2d_area_entered)

func _on_area_2d_area_entered(area):
	print("entered")
	
func addArea2D(array):
	for i in array:
		circles_area =  Area2D.new()
		
		var area_shape = CollisionShape2D.new()
		area_shape.shape=CircleShape2D.new()
		
		area_shape.scale.x=1.5 
		area_shape.scale.y=1.5
		circles_area.add_child(area_shape)
		circles_area.position=Vector2(i.position.x/2,i.position.y/2)
		#circles_area.pivot_offset=Vector2(circles_area.size.x/2,circles_area.size.y/2)
		connect_circle_areas()
		i.add_child(circles_area)
		
