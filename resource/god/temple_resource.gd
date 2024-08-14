class_name TempleResource extends Resource


var god: GodResource:
	set = set_god

var available_minions: Array[MinionResource]
var unavailable_minions: Array[MinionResource]


func set_god(god_: GodResource) -> TempleResource:
	god = god_
	init_minions()
	return self
	
func init_minions() -> void:
	var powers = [1,2,3,4,5,6,7,8,9]
	
	for power in powers:
		add_minion(power)
	
func add_minion(power_: int) -> void:
	var minion = MinionResource.new()
	minion.set_power(power_).set_god(god)
