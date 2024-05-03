extends Node2D

@onready var  wire
@onready var panel1=get_node("Panel")
@onready var panel2=get_node("Panel2")
@onready var isSelected= false

@onready var solution=[[panel1, panel2], [panel2, panel1]]
@onready var answer = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	panel1.gui_input.connect(panel_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func wiring(event):
	isSelected = true
	print(isSelected)
		
func panel_selected(event):
	if isSelected== true:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			isSelected = false
			
			
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		wire = TextureRect.new()
		wire.texture = load("res://Game Assets/Minigames/Wiring/circle_blue_png.png")
		wire.gui_input.connect(wiring)
		wire.size=Vector2(20,20)
		wire.set_pivot_offset(Vector2(0, wire.size.y/2))
		wire.position=Vector2(panel1.position.x + panel1.size.x/2 - wire.size.x/2, panel1.position.y + panel1.size.y/2-wire.size.y/2)
		add_child(wire)
		wire.gui_input.connect(x)
		isSelected=true
		
func x(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		wire.size.x=event.position.x
		


		
		

