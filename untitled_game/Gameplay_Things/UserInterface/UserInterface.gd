extends Control

var WindowSize = 0
var is_open = false
@onready var window : Window = get_window()
@onready var ExitButton = get_node("ExitButton")
@onready var UI = get_node(".")
@onready var ExitPanel= get_node("ExitPanel")
@onready var inventory=get_node("InventoryUi")
@onready var BackButton=get_node("ExitPanel/BackButton")

@onready var SettingsPanel = get_node("SettingsPanel")

@onready var MusicSetter = get_node("SettingsPanel/VBoxContainer/MusicSetter")
@onready var volume = get_node("SettingsPanel/VBoxContainer/MusicSetter/volume")

@onready var SoundEffectSetter = get_node("SettingsPanel/VBoxContainer/SoundEffectSetter")
@onready var volume2 = get_node("SettingsPanel/VBoxContainer/SoundEffectSetter/volume2")



func _ready():
	UI.visible = false
	ExitPanel.visible=false
	SettingsPanel.visible=false
	volume.text= "0"
	volume2.text = "0"
	
	
@warning_ignore("unused_parameter")
func _process(_delta):
	WindowSize = get_viewport_rect().size/2
	#print("WindowSize: ",WindowSize)
	UI.size=WindowSize
	#print("UI: ",WindowSize)
	#print("exit button pos: ", ExitButton.position)

@warning_ignore("unused_parameter")
func _input(event):
	if Input.is_action_pressed("inventory"):
		if is_open:
			close()
		else:
			open()
		
	
func close():
	UI.visible=false
	is_open= false
	if ExitPanel.visible == true:
		ExitPanel.visible=false
	
func open():
	UI.visible= true
	is_open= true


func _on_exit_button_pressed():
	ExitPanel.visible=true
	inventory.visible=false
	SettingsPanel.visible=false

func _on_quit_button_pressed():
	get_tree().quit()

func _on_back_button_pressed():
	ExitPanel.visible=false
	inventory.visible=true
	SettingsPanel.visible = false

func _on_settings_button_pressed():
	SettingsPanel.visible=true
	ExitPanel.visible=false
	inventory.visible=false

func _on_settings_back_pressed():
	SettingsPanel.visible=false
	inventory.visible= true

func get_volume(SoundSet,txt):
	var value = 0
	SoundSet.rounded=true
	if SoundSet.value_changed:
		value = SoundSet.value
	set_volumetxt(value, txt)
		
func set_volumetxt(val, txt):
	txt.text=str(val)
	
func _on_h_scroll_bar_scrolling():
	get_volume(MusicSetter, volume)

func _on_sound_effect_setter_scrolling():
	get_volume(SoundEffectSetter, volume2)

