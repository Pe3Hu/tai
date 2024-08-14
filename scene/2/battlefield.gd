class_name Battlefield extends PanelContainer


@export var world: World
@export var sudoku: Sudoku
@export var keypad: Keypad
@export var camps: VBoxContainer

@onready var camp_scene = preload("res://scene/2/camp.tscn")

var resource: BattlefieldResource
var active_camp: Camp


func fill_as_last() -> void:
	resource = world.resource.battlefields.back()
	
	init_camps()
	
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
	
	active_camp.is_active = true
