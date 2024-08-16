class_name SoilResource extends Resource


var sudoku: SudokuResource:
	set = set_sudoku
var blocks: Dictionary
var grids: Dictionary
var values: Array
var noise

const pixel_size = Vector2(1, 1)#5
const spot_size = Vector2(1, 1)#2
const cell_size = Vector2(3, 3)#3
const block_size = Vector2(3, 3)
var n


func set_sudoku(sudoku_: SudokuResource) -> SoilResource:
	sudoku = sudoku_
	init_noise()
	init_fields()
	return self
	
func init_noise() -> void:
	noise = FastNoiseLite.new()
	noise.seed = 0#randi()
	noise.fractal_octaves = 4
	noise.fractal_gain = 2.0
	noise.frequency = 0.01
	n = block_size.x * cell_size.x * spot_size.x * pixel_size.x
	
func init_fields() -> void:
	var block_index = 0
	
	for block_y in block_size.y:
		for block_x in block_size.x:
			var block_grid = Vector2(block_x, block_y)
			#var block = sudoku.grids[block_index]
			grids[block_grid] = {}
			var cell_index = 0
			#print(block_index)
			
			for cell_y in cell_size.y:
				for cell_x in cell_size.x:
					var cell_grid = block_grid * cell_size + Vector2(cell_x, cell_y)
					#var cell = block.cells[cell_index]
					grids[block_grid][cell_grid] = {}
					
					for spot_y in spot_size.y:
						for spot_x in spot_size.x:
							var spot_grid = cell_grid * spot_size + Vector2(spot_x, spot_y)
							#var spot_values = []
							grids[block_grid][cell_grid][spot_grid] = []
							
							for pixel_y in pixel_size.y:
								for pixel_x in pixel_size.x:
									var pixel_grid = spot_grid * pixel_size + Vector2(pixel_x, pixel_y)
									#var noise_value = noise.get_noise_2d(pixel_x, pixel_y)
									var noise_value = noise.get_noise_2dv(pixel_grid)
									grids[block_grid][cell_grid][spot_grid].append(pixel_grid)
									values.append(noise_value)
									#print([pixel_grid, noise_value])
					
					cell_index += 1
			
			block_index += 1
	
	block_index = 0
	var _values = values.duplicate()
	_values.sort()
	var min_value = _values.front()
	var max_value = _values.back()
	var l = max_value - min_value
	_values = values.duplicate()
	#print([min_value, max_value])
	#print([values.front(), values.back()])
	#print(values)
	values.clear()
	
	for value in _values:
		var lerped_value = snapped((value - min_value) / l, 0.01)
		values.append(lerped_value)
	
	#print([values.front(), values.back()])
	#print(values)
	for block_grid in grids:
		var block_value = 0
		print(block_grid)
		for cell_grid in grids[block_grid]:
			var cell_value = 0
			
			for spot_grid in grids[block_grid][cell_grid]:
				var spot_value = 0
				
				for pixel_grid in grids[block_grid][cell_grid][spot_grid]:
					var pixel_index = pixel_grid.x * n + pixel_grid.y
					var pixel_value = values[pixel_index]
					spot_value += pixel_value
					#print(pixel_value)
				
				cell_value += spot_value
			
			print([cell_grid, cell_value / grids[block_grid][cell_grid].size()])
			block_value += cell_value
		
		#print([block_grid, block_value])
		block_index += 1
