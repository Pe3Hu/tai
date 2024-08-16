class_name Soil extends PanelContainer


@export var battlefield: Battlefield
@export var fields: GridContainer
@export var sprite: Sprite2D

@onready var field_scene = preload("res://scene/0/paneled_number.tscn")

var resource: SoilResource:
	set = set_resource
var blocks: Dictionary


func set_resource(resource_: SoilResource) -> Soil:
	resource = resource_
	sprite.texture.set("noise", resource.noise)
	#init_fields()
	return self
	
func init_fields() -> void:
	for filed_resource in resource.fileds:
		var field = field_scene.instantiate()
		fields.add_child(field)
		#field.style.bg_color = Global.color.camp[_i]
		field.zoom = 2
		#var camp = battlefield.resource.demon_camp
		#
		#if battlefield.camps.get_child_count() > _i:
			#camp = battlefield.camps.get_child(_i).resource
		#
		blocks[filed_resource] = field
