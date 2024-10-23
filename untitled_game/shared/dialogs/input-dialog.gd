extends Node2D



var title: String
var selection_dialog: bool
var input: String
signal input_entered(input: String)
signal input_cancelled()

func create_input_dialog(titleText: String) -> void:
	$TitleLabel.text = titleText
	
func _open_selection_input_dialog(options: Array) -> void:
	$LineEdit.visible = false
	$OptionButton.visible = true
	$OptionButton.item_selected.connect(_on_option_button_item_selected.bind(options))
	selection_dialog = true
	input = options[0]
	for option in options:
		$OptionButton.add_item(option, options.find(option))
	
func _on_submit_button_pressed():
	if input.length() == 0:
		$ErrorLabel.text = "Input too short."
	else:
		input_entered.emit(input)
		
func error_message(error: String):
	$ErrorLabel.text = error

func _on_back_button_pressed():
	input_cancelled.emit()

func _on_option_button_item_selected(index, options: Array):
	input = options[index]

func _on_line_edit_text_changed(new_text):
	input = new_text
