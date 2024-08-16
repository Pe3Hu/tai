class_name Battlefield extends PanelContainer


@export var world: World
@export var sudoku: Sudoku
@export var keypad: Keypad
@export var camps: VBoxContainer
@export var blocks: GridContainer
@export var soil: Soil

@onready var camp_scene = preload("res://scene/2/camp.tscn")
@onready var block_scene = preload("res://scene/2/block.tscn")

var resource: BattlefieldResource
var active_camp: Camp
var reflected_blocks: Dictionary


func fill_as_last() -> void:
	resource = world.resource.battlefields.back()
	
	init_camps()
	init_blocks()
	
	resource.sudoku = sudoku.resource
	soil.resource = resource.sudoku.soil
	
func init_camps() -> void:
	for camp_resource in resource.camps:
		var camp = camp_scene.instantiate()
		camp.set_resource(camp_resource).set_battlefield(self)
	
	pass_banner()
	
func pass_banner() -> void:
	if active_camp == null:
		active_camp = camps.get_child(0)
	else:
		active_camp.is_active = false
		var index = (active_camp.get_index() + 1) % camps.get_child_count()
		active_camp = camps.get_child(index)
		
		if index == 0:
			demon_turn()
	
	active_camp.is_active = true
	
func init_blocks() -> void:
	for block_resource in sudoku.resource.blocks:
		var block = block_scene.instantiate()
		block.set_resource(block_resource).set_battlefield(self)
	
	var middle = blocks.get_child_count() / 2 + 1
	
	for _i in middle:
		var a = blocks.get_child(_i)
		var b = blocks.get_child(blocks.get_child_count() - _i - 1)
		reflected_blocks[a] = b
		reflected_blocks[b] = a
	
func demon_turn() -> void:
	var block = find_vulnerable_block()
	var cells = find_vulnerable_cells(block)
	var cell = cells.pick_random()
	create_demon_minion(cell)
	sudoku.update_cell(cell)
	#create_strongest_minion_based_on_block(block)
	#block.change_power(resource.void_camp, 9)
	
func find_vulnerable_block() -> Block:
	var options = blocks.get_children()
	options.sort_custom(func(a, b): return a.presence > b.presence)
	var strongests = options.filter(func (a): return a.presence == options[0].presence)
	var strongest_block = strongests.pick_random()
	var vulnerable_block = reflected_blocks[strongest_block]
	return vulnerable_block
	
func find_vulnerable_cells(block_: Block) -> Array[CellResource]:
	var options = block_.resource.cells
	options.sort_custom(func(a, b): return a.get_biggest_number() < b.get_biggest_number())
	var cells = options.filter(func (a): return a.get_biggest_number() == options[0].get_biggest_number())
	return cells
	
func create_demon_minion(cell_: CellResource) -> void:
	var power = cell_.get_biggest_number()
	var minion = MinionResource.new()
	minion.set_power(power).set_god(world.resource.heaven.demon_god)
	minion.camp = resource.demon_camp
	cell_.minion = minion
