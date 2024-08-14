class_name Keypad extends PanelContainer


@export var battlefield: Battlefield

var active_button: NumberedButton:
	set = set_active_button


func set_active_button(active_button_: NumberedButton) -> void:
	active_button = active_button_
	battlefield.sudoku.set_cell_based_on_keypad()
	active_button = null
