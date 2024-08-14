class_name SudokuResource extends Resource


var tree: TreeResource
var cols: Array[KitResource]
var rows: Array[KitResource]
var blocks: Array[KitResource]
var cells: Array[CellResource]
var variations: Dictionary
var variation: int
var is_duplication: bool = false
var is_filled: bool = false
var is_hole: bool = false

const n = 9
const types = ["col", "row", "block"]


func _init() -> void:
	init_kits()
	init_cells()
	init_variations()
	
	tree = TreeResource.new()
	tree.set_sudoku(self)
	
func init_kits() -> void:
	for type in types:
		for _i in n:
			var kit_resource = KitResource.new()
			kit_resource.set_type(type).set_sudoku(self)
	
func init_cells() -> void:
	var index = 0
	
	for _i in n:
		for _j in n:
			var cell = CellResource.new()
			cell.set_index(index).set_sudoku(self)
			index += 1
	
func init_variations() -> void:
	for _i in n + 1:
		variations[_i] = []
	
	variations[n].append_array(cells)
	#fill_random_cell()
	
func fill_random_cell() -> Variant:
	if !is_duplication:
		update_variation()
		
		if variation != -1:
			var options = variations[variation]
			var cell = options.pick_random()
			cell.roll_number()
			return cell
	
	return null
	
func update_variation() -> void:
	variation = -1
	
	for _i in n + 1:
		if !variations[_i].is_empty():
			variation = _i
			return
	
	is_filled = true
	
func update_duplication() -> Array:
	is_duplication = false
	var duplications = []
	
	for type in types:
		var kits = get(type + "s")
		
		for kit in kits:
			var _duplications = kit.duplication_check().filter(func (a): return !duplications.has(a))
			#_duplications.filter(func (a): return !duplications.has(a))
			duplications.append_array(_duplications)
			#is_duplication = true
			#return
	
	is_duplication = !duplications.is_empty()
	return duplications
	
func update_hole() -> void:
	is_hole = false
	
	for cell in cells:
		if cell.numbers.is_empty() and cell.number == -1:
			is_hole = true
			print(["hole error", cell.grid])
			return
	
func fill_all_cells() -> void:
	while !is_filled and !is_duplication and !is_hole:
		fill_random_cell()
		update_hole()
