class_name TreeResource extends Resource


var sudoku: SudokuResource:
	set = set_sudoku
var branchs: Array[BranchResource]
var counter = 0


func set_sudoku(sudoku_: SudokuResource) -> TreeResource:
	sudoku = sudoku_
	#init_root_branch()
	return self
	
func init_root_branch() -> void:
	var branch = BranchResource.new()
	sudoku.update_variation()
	var options = sudoku.variations[sudoku.variation]
	var cell = options.pick_random()
	var number = cell.numbers[0]
	branch.set_cell(cell).set_number(number).set_tree(self)
	branch.apply()
	
func next_branch() -> CellResource:
	counter += 1
	var branch = branchs.back()
	var cell_resource = null
	var is_deadend = true
	
	if sudoku.is_hole:
		sudoku.is_hole = false
	else:
		if !branch.childs.is_empty():
			var duplications = sudoku.update_duplication()
			
			if duplications.is_empty():
				cell_resource = branch.choose_child()
				is_deadend = false
	
	if is_deadend:
		branch.set_as_deadend()
		cell_resource = branch.cell
	
	#print([counter, sudoku.is_hole])
	return cell_resource
	
func previous_branch() -> CellResource:
	var branch = branchs.back()
	branch.set_as_deadend()
	var cell_resource = branch.cell
	return cell_resource
