extends Node2D

var colors = []
var wireColors = []
var random_color_index

@onready var vbox1 = get_node("VBoxContainer")
@onready var vbox2 = get_node("VBoxContainer2")

var vbox1_rects = []
var vbox2_rects=[]

var big_wire
var wire

var isclicked1=false
var isclicked2=false
var paired=false

var pair_count=0
var difficulty

signal minigame_completed



# Called when the node enters the scene tree for the first time.
func _ready():
	var window_sizing=get_viewport_rect().size
	vbox2.position.x=window_sizing.x/2
	vbox1.position.x=window_sizing.x/4
	load_colors()
	load_text_rects()

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

func load_text_rects():
	vbox1_rects=vbox1.get_children()
	vbox2_rects=vbox2.get_children()
	
	for rect in vbox1_rects:
		rect.gui_input.connect(onclick.bind(vbox1_rects,rect))
		rect.mouse_entered.connect(_on_texture_rect_mouse_entered.bind(rect))

		rect.set_meta('has_wire', false)
		
	for rect in vbox2_rects:
		rect.gui_input.connect(onclick.bind(vbox1_rects, rect))
		rect.mouse_entered.connect(_on_texture_rect_mouse_entered.bind(rect))

		rect.set_meta('has_wire', false)
		
	color_circles(vbox1_rects)
	color_circles(vbox2_rects)
	add_color_meta(vbox1_rects)
	add_color_meta(vbox2_rects)
	
func add_color_meta(rects):
	for rect in rects:
		if rect.texture == colors[0]:
			rect.set_meta("color", "blue")
		elif rect.texture == colors[1]:
			rect.set_meta("color", "green")
		elif rect.texture==colors[2]:
			rect.set_meta("color", "orange")
		elif rect.texture == colors[3]:
			rect.set_meta("color", "purple")
		elif rect.texture == colors[4]:
			rect.set_meta("color", "red")
		elif rect.texture == colors[5]:
			rect.set_meta("color", "yellow")
	
func color_circles(array):
	var temp = []
	for i in range(array.size()):
		random_color_index = randi_range(0,colors.size()-1)
		while temp.has(random_color_index):
			random_color_index = randi_range(0,colors.size()-1)
		array[i].texture = colors[random_color_index]
		temp.append(random_color_index)

func onclick(event,rect_array, rect):
	if Input.is_action_pressed("room_changer_click"):
		if rect.get_meta('has_wire') == false:
			createWire(rect, rect_array)
			rect.set_meta('has_wire', true)

		if rect.get_meta('group') == 1:
			isclicked1=true
		elif rect.get_meta('group') == 2:
			isclicked2=true
			
		var diff = get_viewport().get_mouse_position() - wire.global_position
		var angle = diff.angle()
		wire.rotation = angle
		wire.size.x=sqrt((event.position.y**2+event.position.x **2)/1.3)
		
	if Input.is_action_just_released("room_changer_click"):
		if isclicked1:
			isclicked1=false
		elif isclicked2:
			isclicked2=false
		if !paired:
			rect.remove_child(wire)
			rect.set_meta("has_wire", false)
		if paired:
			rect.gui_input.disconnect(onclick)
			rect.mouse_entered.disconnect(_on_texture_rect_mouse_entered)
			paired=false

func createWire(c, c_array):
	var index=c_array.find(c, 0)

	if c.get_child_count() == 0:
		wire = TextureRect.new()
		wire.z_index = 2
		wire.position.x=c.size.x/2
		wire.position.y=c.size.y/2
		wire.pivot_offset = Vector2(wire.size.x/2, wire.size.y/2)
		
		if c.texture == colors[0]:
			wire.texture = wireColors[0]
			wire.set_meta("color", "blue")
		elif c.texture == colors[1]:
			wire.texture = wireColors[1]
			wire.set_meta("color", "green")
		elif c.texture == colors[2]:
			wire.texture = wireColors[2]
			wire.set_meta("color", "orange")
		elif c.texture == colors[3]:
			wire.texture = wireColors[3]
			wire.set_meta("color", "purple")
		elif c.texture == colors[4]:
			wire.texture = wireColors[4]
			wire.set_meta("color", "red")
		elif c.texture == colors[5]:
			wire.texture = wireColors[5]
			wire.set_meta("color", "yellow")
		c.add_child(wire)

func _on_texture_rect_mouse_entered(rect):
	if rect.get_meta('group') ==2 && isclicked1:
		gameplay(rect)
	elif rect.get_meta('group') ==1 && isclicked2:
		gameplay(rect)

func gameplay(rect):
	if rect.get_meta("color") == wire.get_meta("color"):
		paired=true
		rect.set_meta('has_wire', true)
		pair_count+=1
		wire.size.x==rect.position.x
		rect.gui_input.disconnect(onclick)
		rect.mouse_entered.disconnect(_on_texture_rect_mouse_entered)
		if pair_count == 6:
			minigame_completed.emit()
	else:
		print("not the same color")
		


