class_name CellResource extends Resource


var sudoku: SudokuResource:
	set = set_sudoku
var index: int:
	set = set_index
var col: KitResource
var row: KitResource
var block: KitResource
var minion: MinionResource:
	set = set_minion
var numbers: Array[int] = [1,2,3,4,5,6,7,8,9]
var exceptions: Array[int]
var number: int = -1
var grid: Vector2i


func set_sudoku(sudoku_: SudokuResource) -> CellResource:
	sudoku = sudoku_
	sudoku_.cells.append(self)
	find_col().find_row().find_block()
	return self
	
func set_index(index_: int) -> CellResource:
	index = index_
	return self
	
func set_minion(minion_: MinionResource) -> CellResource:
	minion = minion_
	number = minion_.power
	return self
	
func find_col() -> CellResource:
	grid.x = index % sudoku.n
	col = sudoku.cols[grid.x]
	col.cells.append(self)
	return self
	
func find_row() -> CellResource:
	grid.y = floor(index / sudoku.n)
	row = sudoku.rows[grid.y]
	row.cells.append(self)
	return self
	
func find_block() -> CellResource:
	var _grid = Vector2i(grid.x / 3, grid.y / 3)
	var _index = _grid.y * 3 + _grid.x
	block = sudoku.blocks[_index]
	block.cells.append(self)
	return self
	
func roll_number() -> void:
	#numbers.shuffle()
	number = numbers[0]
	#print([sudoku.variation, grid, number])
	strike_out_number_from_kits()
	#sudoku.variations[numbers.size()].erase(self)
	
func strike_out_number_from_kits() -> void:
	sudoku.is_hole = false
	
	for type in sudoku.types:
		var kit = get(type)
		var flag = kit.strike_out_number_from_cells(self)
		sudoku.is_hole = sudoku.is_hole or flag or sudoku.is_filled
	
	sudoku.variations[numbers.size()].erase(self)
	numbers.erase(number)
	
	#if sudoku.variations.has(numbers.size() + 1):
		#sudoku.variations[numbers.size() + 1].erase(self)
	pass
	
func inject_number_to_cells() -> void:
	for type in sudoku.types:
		var kit = get(type)
		kit.inject_number_to_cells(self)
	
	numbers.append(number)
	sudoku.variations[numbers.size()].append(self)
	
func get_biggest_number() -> int:
	numbers.sort()
	return numbers.back()
