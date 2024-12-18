extends Node2D

@onready var node = get_node(".")
@onready var rect_array = []
@onready var lightson_texture=load("res://Game Assets/Minigames/LightsOff/lightsoff_on.png")
@onready var lightsoff_texture=load("res://Game Assets/Minigames/LightsOff/lightsoff_off-removebg-preview.png")

signal minigame_completed

var difficulty: String


func _ready():
	for child in $GridContainer.get_children():
		pass
	random_on_lights(rect_array)
	connect_rect(rect_array)



func random_on_lights(array):
	var temp=randi_range(1,array.size()-3)
	
	while temp%2!=0:
		temp=randi_range(1,array.size()-3)
		
	var random_lightson_number=temp

	var random_index=[]
	while random_index.size()<random_lightson_number:
		var number=randi_range(0,array.size()-1)
		if number not in random_index:
			random_index.append(number)
	
	for i in random_index:
		array[i].texture = lightson_texture

func connect_rect(array):
	for rect in array:
		rect.gui_input.connect(on_click.bind(rect))

func on_click(event, rect):
	if Input.is_action_pressed("room_changer_click"):
		gameplay(rect_array,rect)

func gameplay(rect_array, rect):
	var clicked_index=rect_array.find(rect)
	#if clicked_index==0:
		#clicked_rect(rect_array,clicked_index)
		#clicked_rect(rect_array,1)
		#clicked_rect(rect_array,3)
	#elif clicked_index==1:
		#clicked_rect(rect_array,clicked_index)
		#clicked_rect(rect_array,0)
		#clicked_rect(rect_array,2)
		#clicked_rect(rect_array,4)
	#elif clicked_index==2:
		#clicked_rect(rect_array,clicked_index)
		#clicked_rect(rect_array, 1)
		#clicked_rect(rect_array, 5)
	#elif clicked_index==3:
		#clicked_rect(rect_array, clicked_index)
		#clicked_rect(rect_array,0)
		#clicked_rect(rect_array,4)
		#clicked_rect(rect_array,6)
	#elif clicked_index==4:
		#clicked_rect(rect_array, clicked_index)
		#clicked_rect(rect_array, 1)
		#clicked_rect(rect_array,3)
		#clicked_rect(rect_array, 5)
		#clicked_rect(rect_array, 7)
	#elif clicked_index==5:
		#clicked_rect(rect_array, clicked_index)
		#clicked_rect(rect_array,2)
		#clicked_rect(rect_array,4)
		#clicked_rect(rect_array,8)
	#elif clicked_index==6:
		#clicked_rect(rect_array, clicked_index)
		#clicked_rect(rect_array,3)
		#clicked_rect(rect_array, 7)
	#elif clicked_index==7:
		#clicked_rect(rect_array, clicked_index)
		#clicked_rect(rect_array,4)
		#clicked_rect(rect_array, 8)
		#clicked_rect(rect_array,6)
	#elif clicked_index==8:
		#clicked_rect(rect_array, clicked_index)
		#clicked_rect(rect_array, 7)
		#clicked_rect(rect_array, 5)
		
func clicked_rect(rect_array,i):
	if rect_array[i].texture==lightsoff_texture:
		rect_array[i].texture=lightson_texture
	else:
		rect_array[i].texture=lightsoff_texture
	
	var completed = false
	for rect in rect_array:
		if rect.texture == lightson_texture:
			completed = true
		else:
			completed = false
			
	if completed:
		minigame_completed.emit()
	
