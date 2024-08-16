class_name Cell extends NumberedButton


@export var options: GridContainer

var sudoku: Sudoku:
	set = set_sudoku
var resource: CellResource:
	set = set_resource
var disabled_style: StyleBoxFlat


func set_sudoku(sudoku_: Sudoku) -> Cell:
	sudoku = sudoku_
	sudoku_.cells.add_child(self)
	proprietor = sudoku
	return self
	
func set_resource(resource_: CellResource) -> Cell:
	resource = resource_
	init_style()
	
	return self
	
func init_style() -> void:
	disabled_style = StyleBoxFlat.new()
	set("theme_override_styles/disabled", disabled_style)
	
func update_options() -> void:
	value = resource.number
	
	if resource.number == -1:
		options.visible = true
		disabled = false
		
		for _i in options.get_child_count():
			var option = options.get_child(_i)
			var number = _i + 1
			option.label.visible = resource.numbers.has(number)
	else:
		options.visible = false
		disabled = true
