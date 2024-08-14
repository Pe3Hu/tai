class_name Camp extends PanelContainer


@export var on_reserve_minions: GridContainer
#@export var on_field_minions: GridContainer

@onready var minion_scene = preload("res://scene/2/minion.tscn")

var resource: CampResource:
	set = set_resource
var battlefield: Battlefield:
	set = set_battlefield
var active_minion: Minion:
	set = set_active_minion
var is_active: bool:
	set = set_is_active
var style: StyleBoxFlat

const border_width = 4


func set_resource(resource_: CampResource) -> Camp:
	resource = resource_
	init_style()
	style.bg_color = resource.color
	return self
	
func set_battlefield(battlefield_: Battlefield) -> Camp:
	battlefield = battlefield_
	battlefield.camps.add_child(self)
	init_minions()
	return self
	
func set_is_active(is_active_: bool) -> Camp:
	is_active = is_active_
	
	var width = border_width
	
	if !is_active:
		width = 0
	
	#var style = get("theme_override_styles/panel")
	var sides = ["left", "top", "right", "bottom"]
	
	for side in sides:
		style.set("border_width_" + side, width)
	
	return self
	
func init_minions() -> void:
	for minion_resource in resource.on_reserve_minions:
		var minion = minion_scene.instantiate()
		minion.set_resource(minion_resource).set_camp(self)
	
func init_style() -> void:
	style = StyleBoxFlat.new()
	var sides = ["left", "top", "right", "bottom"]
	set("theme_override_styles/panel", style)
	
	for side in sides:
		style.set("content_margin_" + side, border_width)
	
func set_active_minion(active_minion_: Minion) -> void:
	if battlefield.active_camp == self:
		active_minion = active_minion_
		move_minion_on_field()
		active_minion = null
	
func move_minion_on_field() -> void:
	if battlefield.sudoku.active_cell != null:
		battlefield.sudoku.set_cell_based_on_camp()
		battlefield.pass_banner()
		resource.move_minion_on_field(active_minion.resource)
		on_reserve_minions.remove_child(active_minion)
		active_minion.queue_free()
