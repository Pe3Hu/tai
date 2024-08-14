class_name Sudoku extends PanelContainer


@export var battlefield: Battlefield
@export var cells: GridContainer
@export var lines: Node2D

@onready var cell_scene = preload("res://scene/1/cell.tscn")
@onready var line_scene = preload("res://scene/1/line.tscn")

var resource: SudokuResource
var active_cell: Cell

const l = 48
const width = 4
const gap = 0


func _ready() -> void:
	resource = SudokuResource.new()
	init_cells()
	init_lines()
	#fill_cells()
	
	lines.position = width * Vector2.ONE * 2.25
	#cells.set("theme_override_constants/h_separation", gap)
	#cells.set("theme_override_constants/v_separation", gap)
	
	#print("result is " , resource.is_duplication)
	pass

func init_cells() -> void:
	for cell_resource in resource.cells:
		var cell = cell_scene.instantiate()
		cell.set_resource(cell_resource).set_sudoku(self)

func init_lines() -> void:
	var orientations = ["col", "row"]
	var types = [
		"thick",
		"slim",
		"slim",
		"thick",
		"slim",
		"slim",
		"thick",
		"slim",
		"slim",
		"thick"
	]
	
	for orientation in orientations:
		for _i in types.size():
			var type = types[_i]
			var offset = _i * (l + gap)
			var line = line_scene.instantiate()
			line.set_orientation(orientation).set_type(type).set_offset(offset).set_sudoku(self)
	
func fill_cells() -> void:
	#resource.fill_all_cells()
	#
	#for cell in cells.get_children():
		#cell.update_options()
	#while resource.is_filled or resource.is_duplication:
	#	fill_next_cell()
	
	update_cell(resource.tree.branchs.back().cell)
	
	#while resource.tree.counter < 1000 and !resource.is_filled:
		#next_step()
	#
	#var duplications = resource.update_duplication()
	#
	#for cell_resource in duplications:
		##for cell in kit.cells:
		#var index = cell_resource.index
		#var cell = cells.get_child(index)
		#cell_scene.result.type = "guess"
		#print(cell_resource.grid)
	
func fill_next_cell() -> void:
	var cell_resource = resource.fill_random_cell()
	
	if cell_resource != null:
		update_cell(cell_resource)
	else:
		#var flag = resource.duplication_check()
		pass
	
func next_step() -> void:
	if !resource.is_filled:
		var cell_resource = resource.tree.next_branch()
		update_cell(cell_resource)
	
func previous_step() -> void:
	var cell_resource = resource.tree.previous_branch()
	update_cell(cell_resource)
	
	#var branch = resource.tree.branchs.back()
	#if resource.is_hole:
		#branch.set_as_deadend()
		#var cell_resource = branch.cell
		#update_cell(cell_resource)
		#resource.is_hole = false
		#print("!")
	#else:
		#if !branch.childs.is_empty():
			#var cell_resource = branch.choose_child()
			#update_cell(cell_resource)
		#else:
			#branch.set_as_deadend()
			#var cell_resource = branch.cell
			#update_cell(cell_resource)
	
func fill_next_cell_based_on_tree() -> void:
	var cell_resource = resource.tree.branchs.back().choose_child()
	update_cell(cell_resource)
	
func update_cell(cell_resource_: CellResource) -> void:
	for type in resource.types:
		var kit_resource = cell_resource_.get(type)
		
		for cell_resource in kit_resource.cells:
			var cell = cells.get_child(cell_resource.index)
			cell.update_options()
	
	var index = cell_resource_
	var cell = cells.get_child(cell_resource_.index)
	cell.disabled_style.bg_color = cell_resource_.minion.camp.color
	
func set_cell_based_on_keypad() -> void:
	if active_cell != null and battlefield.keypad.active_cell != null:
		if active_cell.resource.number != -1:
			active_cell.resource.inject_number_to_cells()
		
		#active_cell.value = battlefield.keypad.active_cell.value
		active_cell.resource.number = battlefield.keypad.active_cell.value
		active_cell.resource.strike_out_number_from_kits()
		update_cell(active_cell.resource)
	
func set_cell_based_on_camp() -> void:
	if active_cell != null and battlefield.active_camp.active_minion != null:
		if active_cell.resource.number != -1:
			active_cell.resource.inject_number_to_cells()
		
		#var minion_resourece = battlefield.active_camp.active_minion
		#active_cell.resource.number = minion_resourece.power
		active_cell.resource.minion = battlefield.active_camp.active_minion.resource
		#active_cell.value = battlefield.keypad.active_cell.value
		active_cell.resource.strike_out_number_from_kits()
		update_cell(active_cell.resource)
		active_cell.button_pressed = false
		active_cell = null
	
func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					next_step()
			KEY_A:
				if event.is_pressed() && !event.is_echo():
					previous_step()
					pass
