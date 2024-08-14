class_name CampResource extends Resource


var god: GodResource:
	set = set_god
var battlefield: BattlefieldResource:
	set = set_battlefield

var on_reserve_minions: Array[MinionResource]
var on_field_minions: Array[MinionResource]
var order: int
var color: Color


func set_god(god_: GodResource) -> CampResource:
	god = god_
	god.camps.append(self)
	fill_reserve_minions()
	return self
	
func set_battlefield(battlefield_: BattlefieldResource) -> CampResource:
	battlefield = battlefield_
	init_order()
	battlefield.camps.append(self)
	return self
	
func init_order() -> void:
	order = battlefield.camps.size()
	color = Global.color.camp[order]
	
func fill_reserve_minions() -> void:
	god.temple.available_minions.shuffle()
	var n = min(battlefield.reserve_count, god.temple.available_minions.size())
	
	for _i in n:
		var minion = god.temple.available_minions.back()
		move_minion_into_reserve(minion)
	
func move_minion_into_reserve(minion_: MinionResource) -> void:
	if god.temple.available_minions.has(minion_):
		god.temple.available_minions.erase(minion_)
		on_reserve_minions.append(minion_)
		god.temple.unavailable_minions.append(minion_)
		minion_.camp = self
	
func move_minion_on_field(minion_: MinionResource) -> void:
	if on_reserve_minions.has(minion_):
		on_reserve_minions.erase(minion_)
		on_field_minions.append(minion_)
