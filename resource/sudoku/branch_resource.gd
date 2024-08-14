class_name BranchResource extends Resource


var tree: TreeResource:
	set = set_tree
var cell: CellResource:
	set = set_cell
var number: int:
	set = set_number
var parent: BranchResource:
	set = set_parent
var childs: Array[BranchResource]
var deadends: Array[BranchResource]
var is_root: bool = true


func set_tree(tree_: TreeResource) -> BranchResource:
	tree = tree_
	return self
	
func set_cell(cell_: CellResource) -> BranchResource:
	cell = cell_
	return self
	
func set_number(number_: int) -> BranchResource:
	number = number_
	return self
	
func set_parent(parent_: BranchResource) -> BranchResource:
	parent = parent_
	tree = parent.tree
	is_root = false
	return self
	
func apply() -> void:
	cell.number = number
	cell.strike_out_number_from_kits()
	init_childs()
	#print(["apply", tree.sudoku.variation, cell.number])
	tree.branchs.append(self)
	
func undo() -> void:
	cell.inject_number_to_cells()
	cell.number = -1
	#tree.sudoku.variations[cell.numbers.size()].append(self)
	
func init_childs() -> void:
	tree.sudoku.update_variation()
	
	if !tree.sudoku.is_filled:
		var options = tree.sudoku.variations[tree.sudoku.variation]
		
		for option in options:
			for _number in option.numbers:
				var child = BranchResource.new()
				child.set_cell(option).set_number(_number).set_parent(self)
				childs.append(child)
	
func choose_child() -> CellResource:
	var child = childs.pick_random()
	child.apply()
	return child.cell
	
func set_as_deadend() -> void:
	parent.childs.erase(self)
	parent.deadends.append(self)
	undo()
	tree.branchs.erase(self)
	
	#if childs.is_empty():
	#	parent.set_child_as_deadend(self)
