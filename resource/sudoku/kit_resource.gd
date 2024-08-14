class_name KitResource extends Resource


var sudoku: SudokuResource:
	set = set_sudoku
var type: String:
	set = set_type
var cells: Array[CellResource]


func set_sudoku(sudoku_: SudokuResource) -> KitResource:
	sudoku = sudoku_
	sudoku_.get(type + "s").append(self)
	return self
	
func set_type(type_: String) -> KitResource:
	type = type_
	return self
	
func strike_out_number_from_cells(cell_: CellResource) -> bool:
	var is_hole = false
	
	for cell in cells:
		if cell != cell_:
			if cell.numbers.has(cell_.number):
				if cell.number == -1:
					sudoku.variations[cell.numbers.size()].erase(cell)
				
				cell.numbers.erase(cell_.number)
				
				if cell.number == -1:
					if !cell.numbers.is_empty():
						if cell_ != cell:
							sudoku.variations[cell.numbers.size()].append(cell)
					else:
						is_hole = true
	
	return is_hole
	
func inject_number_to_cells(cell_: CellResource) -> void:
	for cell in cells:
		if cell != cell_:
			if !cell.numbers.has(cell_.number):
				if cell.number == -1:
					sudoku.variations[cell.numbers.size()].erase(cell)
				
				if !cell.exceptions.has(cell_.number):
					cell.numbers.append(cell_.number)
				
				if cell.number == -1 and !cell.numbers.is_empty():
					sudoku.variations[cell.numbers.size()].append(cell)
	
func duplication_check() -> Array:
	var uniques = {}
	var duplications = []
	
	for cell in cells:
		if !uniques.has(cell.number):
			uniques[cell.number] = []
		
		uniques[cell.number].append(cell)
		#if numbers.has(cell.number):
			#duplications.append()
		#else:
			#numbers.append(cell.number)
	
	uniques.erase(-1)
	
	for number in uniques:
		if uniques[number].size() > 1:
			duplications.append_array(uniques[number])
	
	return duplications
