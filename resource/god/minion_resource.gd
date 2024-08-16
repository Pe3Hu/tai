class_name MinionResource extends Resource


var god: GodResource:
	set = set_god
var power: int:
	set = set_power
var camp: CampResource


func set_god(god_: GodResource) -> MinionResource:
	god = god_
	god.temple.available_minions.append(self)
	return 
	
func set_power(power_: int) -> MinionResource:
	power = power_
	return self
