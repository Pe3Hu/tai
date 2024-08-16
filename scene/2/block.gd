class_name Block extends PanelContainer


@export var powers: GridContainer

@onready var power_scene = preload("res://scene/0/paneled_number.tscn")

var resource: KitResource:
	set = set_resource
var battlefield: Battlefield:
	set = set_battlefield
var camps: Dictionary
var presence: int = 0


func set_resource(resource_: KitResource) -> Block:
	resource = resource_
	return self
	
func set_battlefield(battlefield_: Battlefield) -> Block:
	battlefield = battlefield_
	battlefield.blocks.add_child(self)
	init_powers()
	return self
	
func init_powers() -> void:
	for _i in battlefield.camps.get_child_count() + 1:
		var power = power_scene.instantiate()
		powers.add_child(power)
		power.style.bg_color = Global.color.camp[_i]
		power.zoom = 2
		var camp = battlefield.resource.demon_camp
		
		if battlefield.camps.get_child_count() > _i:
			camp = battlefield.camps.get_child(_i).resource
		
		camps[camp] = power
	
func change_power(camp_: CampResource, value_: int) -> void:
	var power = camps[camp_]
	power.value += value_
	sort_powers()
	
	if camp_.god != null:
		presence += value_
	
func sort_powers() -> void:
	var temp = []
	
	while powers.get_child_count() > 0:
		var power = powers.get_child(0)
		powers.remove_child(power)
		temp.append(power)
	
	temp.sort_custom(func(a, b): return a.value > b.value)
	
	for power in temp:
		powers.add_child(power)
