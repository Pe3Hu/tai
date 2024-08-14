class_name Minion extends PanelContainer


@export var power: NumberedButton

var resource: MinionResource:
	set = set_resource
var camp: Camp:
	set = set_camp


func set_resource(resource_: MinionResource) -> Minion:
	resource = resource_
	power.value = resource.power
	return self
	
func set_camp(camp_: Camp) -> Minion:
	camp = camp_
	camp.on_reserve_minions.add_child(self)
	return self
