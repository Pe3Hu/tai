class_name BattlefieldResource extends Resource


var world: WorldResource:
	set = set_world
var reserve_count: int:
	set = set_reserve_count
var sudoku: SudokuResource

var camps: Array[CampResource]
var demon_camp: CampResource

const temple_count = 3


func set_world(world_: WorldResource) -> BattlefieldResource:
	world = world_
	world.battlefields.append(self)
	init_camps()
	return self
	
func set_reserve_count(reserve_count_: int) -> BattlefieldResource:
	reserve_count = reserve_count_
	return self

func init_camps() -> void:
	var options = []
	options.append_array(world.heaven.gods)
	options.shuffle()
	
	for _i in temple_count:
		var god = options.pop_front()
		god.add_camp(self)
	
	demon_camp = CampResource.new()
	demon_camp.set_battlefield(self).set_god(world.heaven.demon_god)
	camps.erase(demon_camp)
