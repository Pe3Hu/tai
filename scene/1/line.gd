class_name Line extends Line2D


#@export_enum("slim", "thick") var type: String
var sudoku: Sudoku:
	set = set_sudoku
var orientation: String:
	set = set_orientation
var type: String:
	set = set_type
var offset: int:
	set = set_offset


func set_sudoku(sudoku_: Sudoku) -> Line:
	sudoku = sudoku_
	sudoku_.lines.add_child(self)
	init_vertexs()
	return self
	
func set_type(type_: String) -> Line:
	type = type_
	
	match type:
		"slim":
			width = sudoku.width
		"thick":
			width = sudoku.width * 1.5
	return self
	
func set_orientation(orientation_: String) -> Line:
	orientation = orientation_
	return self
	
func set_offset(offset_: int) -> Line:
	offset = offset_
	
	match orientation:
		"col":
			position.x = offset
		"row":
			position.y = offset
	return self
	
func init_vertexs() -> void:
	var vertex = Vector2()
	
	if offset == 0:
		match orientation:
			"col":
				vertex.y = -width
			"row":
				vertex.x = -width
	
	add_point(vertex)
	vertex = Vector2()
	var l = (sudoku.l + sudoku.gap) * 9
	
	match orientation:
		"col":
			vertex.y = l
			position.x = offset - width / 2
		"row":
			vertex.x = l
			position.y = offset - width / 2
	
	add_point(vertex)
