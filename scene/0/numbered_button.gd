@tool
class_name NumberedButton extends Button#PanelContainer


@export var proprietor: PanelContainer
@export var value: int:
	set(value_):
		value = value_
		
		#if is_node_ready():
		if value != -1:
			text = str(value)
		else:
			text = ""
	get:
		return value


func _on_button_down():
	if proprietor is Keypad:
		if proprietor.active_button != null:
			proprietor.active_button.button_pressed = false
			
			proprietor.active_button = self
	
	if proprietor is Sudoku:
		if proprietor.active_cell != null:
			proprietor.active_cell.button_pressed = false
			
		proprietor.active_cell = self
	
	if proprietor is Minion:
		if proprietor.camp.active_minion != null:
			proprietor.camp.active_minion.power.button_pressed = false
		
		proprietor.camp.active_minion = proprietor
